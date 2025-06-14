
-- TRIGGER notificacion de turno confirmado. Se actualizan los registros de la tabla NotificacionesTurno

CREATE TRIGGER TR_GenerarNotificacionTurnoConfirmado
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

