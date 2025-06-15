USE GestionTurnos

-- TRIGGER 3 TR_ACTUALIZACION_ESTADISTICAS_EMPLEADO:
-- Actualiza métricas de rendimiento cuando se crea o completa un turno. 
-- Se ejecuta en INSERT y UPDATE de Turnos para empleados con turnos completados o cancelados. 
-- Calcula y actualiza estadísticas en tiempo real de turnos atendidos, ingresos generados, promedio de calificaciones y promedio mensual de turnos. 
-- Inserta nuevos registros estadísticos para empleados que no los tienen, evitando la necesidad de consultas agregadas costosas durante consultas frecuentes.

CREATE TRIGGER TR_ACTUALIZACION_ESTADISTICAS_EMPLEADO
ON Turnos
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        DECLARE @EmpleadosAfectados3 TABLE (IdEmpleado INT);
        INSERT INTO @EmpleadosAfectados3 (IdEmpleado)
        SELECT DISTINCT IdEmpleado
        FROM INSERTED
        WHERE Estado IN ('Completado', 'Cancelado');

        DECLARE @datos TABLE (
            IdEmpleado INT,
            TurnosCompletados INT,
            IngresosTotal DECIMAL(10,2),
            PromedioVal DECIMAL(3,2),
            PromedioMensual INT
        );

        INSERT INTO @datos
        SELECT 
            t.IdEmpleado,
            COUNT(CASE WHEN t.Estado = 'Completado' THEN 1 END),
            ISNULL(SUM(CASE WHEN t.Estado = 'Completado' THEN s.Precio ELSE 0 END), 0),
            ISNULL(AVG(CASE WHEN t.Estado = 'Completado' AND t.Valoracion IS NOT NULL THEN CAST(t.Valoracion AS FLOAT) END), 0),
            ISNULL(COUNT(CASE WHEN t.Estado = 'Completado' AND t.Fecha >= DATEADD(MONTH, -1, GETDATE()) THEN 1 END), 0)
        FROM Turnos t
        INNER JOIN Servicios s ON t.IdServicio = s.IdServicio
        WHERE t.IdEmpleado IN (SELECT IdEmpleado FROM @EmpleadosAfectados3)
        GROUP BY t.IdEmpleado;

        UPDATE est
        SET 
            TurnosAtendidos = d.TurnosCompletados,
            IngresosGenerados = d.IngresosTotal,
            PromedioCalificacion = d.PromedioVal,
            PromedioTurnosMes = d.PromedioMensual
        FROM Estadisticas est
        INNER JOIN @datos d ON est.IdEmpleado = d.IdEmpleado;

        INSERT INTO Estadisticas (IdEmpleado, TurnosAtendidos, IngresosGenerados, PromedioCalificacion, PromedioTurnosMes)
        SELECT 
            d.IdEmpleado,
            d.TurnosCompletados,
            d.IngresosTotal,
            d.PromedioVal,
            d.PromedioMensual
        FROM @datos d
        WHERE NOT EXISTS (
            SELECT 1 FROM Estadisticas e WHERE e.IdEmpleado = d.IdEmpleado
        );
        
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000), @ErrorSeverity INT, @ErrorState INT;
        SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE();
        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END;

-------------------- EJEMPLOS TR_ACTUALIZACION_ESTADISTICAS_EMPLEADO:
--1
-- Insertar un turno completado para el empleado con ID 1

--INSERT INTO Turnos (IdTurno, IdCliente, IdServicio, IdEmpleado, ProfesionalElegido, Estado, Fecha, Valoracion)
--VALUES (27, 5, 3, 1, 'María Gómez', 'Completado', '2023-09-07 11:00:00', 4.8);

-- El trigger actualizará automáticamente las estadísticas de María Gómez:
-- - Incrementará TurnosAtendidos
-- - Sumará $2800 a IngresosGenerados (precio del servicio 3)
-- - Recalculará el promedio de valoraciones
-- - Incrementará el contador de turnos del último mes

--2
-- Actualizar un turno pendiente a completado

--UPDATE Turnos 
--SET Estado = 'Confirmado' 
--WHERE IdTurno = 11;

-- El trigger:
-- 1. Detecta que el empleado (ID 6) tuvo un cambio relevante
-- 2. Recalcula todas sus estadísticas
-- 3. Actualiza la tabla Estadisticas con los nuevos valores