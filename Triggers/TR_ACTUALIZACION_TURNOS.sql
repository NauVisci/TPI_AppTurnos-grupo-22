USE GestionTurnos

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