USE GestionTurnos

-- TRIGGER 1 TR_GENERAR_NOTIFICACION_TURNO:
-- Se ejecuta cuando se confirma una nueva cita, para enviar notificación al cliente. 
-- Se activa en INSERT y UPDATE de la tabla Turnos, específicamente cuando el estado cambia a “Confirmado”. 
-- Crea registros en la tabla NotificacionesTurno simulando el envío de emails y genera logs de auditoría para seguimiento. 
-- Solo procesa cambios de estado hacia “Confirmado” para evitar notificaciones duplicadas.

CREATE TRIGGER TR_GENERAR_NOTIFICACION_TURNO
ON Turnos
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO NotificacionesTurno (IdTurno, TipoNotificacion, FechaEnvio, Estado)
    SELECT
        i.IdTurno,
        'Confirmacion',
        GETDATE(),
        'Pendiente'
    FROM inserted i
    INNER JOIN deleted d ON i.IdTurno = d.IdTurno
    WHERE i.Estado = 'Confirmado' AND d.Estado <> 'Confirmado';
END;