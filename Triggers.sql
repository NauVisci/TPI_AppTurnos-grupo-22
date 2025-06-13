-- TRIGGERS

-- TRIGGER 1 TR_RECORDATORIO_TURNO:
-- Se ejecuta cuando se confirma una nueva cita, para enviar notificación al cliente. 
-- Se activa en INSERT y UPDATE de la tabla Turnos, específicamente cuando el estado cambia a “Confirmado”. 
-- Crea registros en la tabla NotificacionesTurno simulando el envío de emails y genera logs de auditoría para seguimiento. 
-- Solo procesa cambios de estado hacia “Confirmado” para evitar notificaciones duplicadas.


-------------------- EJEMPLOS TR_RECORDATORIO_TURNO:



-----------------------------------------------------------

-- TRIGGER 2 TR_ACTUALIZACION_TURNOS:
-- Se ejecuta cuando se modifica la disponibilidad horaria de empleados para actualizar automáticamente los turnos afectados, 
-- se activa en INSERT, UPDATE y DELETE de HorariosEmpleado.
-- Cancela automáticamente turnos futuros que quedan fuera del nuevo horario laboral, actualizando su estado a “Cancelado” y agregando observaciones
-- explicativas. Nos garantiza consistencia entre horarios de empleados y turnos programados evitando futuros overlaps o turnos en horarios que ya no son correctos.


CREATE TRIGGER TR_ACTUALIZACION_TURNOS
ON HorariosEmpleado
AFTER UPDATE, INSERT, DELETE
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @EmpleadosAfectados2 TABLE (IdEmpleado INT);
    
    INSERT INTO @EmpleadosAfectados2 (IdEmpleado)
    SELECT DISTINCT IdEmpleado FROM INSERTED
    UNION
    SELECT DISTINCT IdEmpleado FROM DELETED;
    
    UPDATE t
    SET Estado = 'Cancelado', Observaciones = ISNULL(t.Observaciones + '; ', '') + 'Cancelado automáticamente por cambio de horario'
    FROM Turnos t
    INNER JOIN @EmpleadosAfectados2 ea ON t.IdEmpleado = ea.IdEmpleado
    WHERE t.Estado IN ('Confirmado', 'Pendiente')
        AND t.FechaTurno > CAST(GETDATE() AS DATE)
        AND NOT EXISTS (
            SELECT 1 FROM HorariosEmpleado h
            WHERE h.IdEmpleado = t.IdEmpleado
                AND h.DiaSemana = DATEPART(WEEKDAY, t.FechaTurno)
                AND h.Activo = 1
                AND t.HoraTurno BETWEEN h.HoraInicio AND h.HoraFin
        );
    
    IF @@ROWCOUNT > 0
    BEGIN
        PRINT 'Se cancelaron turnos automáticamente debido a cambios en horarios de empleados';
    END
END;
GO

-------------------- EJEMPLOS TR_ACTUALIZACION_TURNOS:
-- traigo todos los horarios de los empleados
-- SELECT * FROM HorariosEmpleado

-- actualizo uno en especial
-- UPDATE HorariosEmpleado 
-- SET HoraInicio = '11:00', HoraFin = '15:00' 
-- WHERE IdEmpleado = 2 AND DiaSemana = 2;

-- selecciono los turnos modificados
-- SELECT t.IdTurno, c.Nombre + ' ' + c.Apellido AS Cliente, e.Nombre + ' ' + e.Apellido AS Empleado, t.FechaTurno, t.HoraTurno, t.Estado, t.Observaciones
-- FROM Turnos t
-- INNER JOIN Clientes c ON t.IdCliente = c.IdCliente
-- INNER JOIN Empleados e ON t.IdEmpleado = e.IdEmpleado
-- WHERE t.IdEmpleado = 1 AND t.Estado = 'Cancelado'
-- ORDER BY t.FechaTurno;

-----------------------------------------------------------

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
        -- Tabla temporal para empleados afectados
        DECLARE @EmpleadosAfectados3 TABLE (IdEmpleado INT);
        INSERT INTO @EmpleadosAfectados3 (IdEmpleado)
        SELECT DISTINCT IdEmpleado
        FROM INSERTED
        WHERE Estado IN ('Completado', 'Cancelado');

        -- Tabla temporal para estad�sticas calculadas
        DECLARE @datos TABLE (
            IdEmpleado INT,
            TurnosCompletados INT,
            IngresosTotal DECIMAL(10,2),
            PromedioVal DECIMAL(3,2),
            PromedioMensual INT
        );

        -- Calcular estad�sticas y almacenar en @datos
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

        -- Actualizar estad�sticas existentes
        UPDATE est
        SET 
            TurnosAtendidos = d.TurnosCompletados,
            IngresosGenerados = d.IngresosTotal,
            PromedioCalificacion = d.PromedioVal,
            PromedioTurnosMes = d.PromedioMensual
        FROM Estadisticas est
        INNER JOIN @datos d ON est.IdEmpleado = d.IdEmpleado;

        -- Insertar estad�sticas si no existen
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

-------------------- EJEMPLOS TR_ACTUALIZACION_ESTADISTICAS_EMPLEADO: