--Triggers

-- TRIGGER 3: Actualiza estadísticas cuando se completa o crea un turno 
-- Actualiza métricas de rendimiento cuando se crea o completa un turno. Se ejecuta en INSERT y UPDATE de Turnos para empleados con turnos 
--completados o cancelados. Calcula y actualiza estadísticas en tiempo real de turnos atendidos, ingresos generados, promedio de 
--calificaciones y promedio mensual de turnos. Inserta nuevos registros estadísticos para empleados que no los tienen, evitando la 
--necesidad de consultas agregadas costosas durante consultas frecuentes.


CREATE TRIGGER TR_ACTUALIZACION_ESTADISTICAS_EMPLEADO
ON Turnos
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Tabla temporal para empleados afectados
        DECLARE @EmpleadosAfectados3 TABLE (IdEmpleado INT);
        INSERT INTO @EmpleadosAfectados3 (IdEmpleado)
        SELECT DISTINCT IdEmpleado
        FROM INSERTED
        WHERE Estado IN ('Completado', 'Cancelado');

        -- Tabla temporal para estadísticas calculadas
        DECLARE @datos TABLE (
            IdEmpleado INT,
            TurnosCompletados INT,
            IngresosTotal DECIMAL(10,2),
            PromedioVal DECIMAL(3,2),
            PromedioMensual INT
        );

        -- Calcular estadísticas y almacenar en @datos
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

        -- Actualizar estadísticas existentes
        UPDATE est
        SET 
            TurnosAtendidos = d.TurnosCompletados,
            IngresosGenerados = d.IngresosTotal,
            PromedioCalificacion = d.PromedioVal,
            PromedioTurnosMes = d.PromedioMensual
        FROM Estadisticas est
        INNER JOIN @datos d ON est.IdEmpleado = d.IdEmpleado;

        -- Insertar estadísticas si no existen
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
        -- Captura de error
        DECLARE @ErrorMessage NVARCHAR(4000), @ErrorSeverity INT, @ErrorState INT;
        SELECT 
            @ErrorMessage = ERROR_MESSAGE(),
            @ErrorSeverity = ERROR_SEVERITY(),
            @ErrorState = ERROR_STATE();
        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END;