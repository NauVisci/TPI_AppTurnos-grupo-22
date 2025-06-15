-- PROCEDIMIENTOS ALMACENADOS


-- PROCEDIMIENTO 3: SP_ACTUALIZAR_HORARIO
-- Gestiona la actualización de horarios de trabajo de empleados con validaciones de negocio. 
-- Valida días laborales (lunes a sábado), rangos horarios válidos (8-20hs) y coherencia entre hora inicio y fin. 
-- Implementa lógica UPSERT: actualiza registros existentes o crea nuevos según corresponda. 
-- Maneja transacciones con rollback automático y retorna el horario actualizado con formato legible, activando automáticamente el trigger de actualización de turnos afectados.

CREATE PROCEDURE SP_ACTUALIZAR_HORARIO @IdEmpleado INT, @DiaSemana INT, @HoraInicio TIME, @HoraFin TIME, @Activo BIT = 1
AS
BEGIN
    SET NOCOUNT ON;
   
    BEGIN TRY
        BEGIN TRANSACTION;
       
        IF NOT EXISTS (SELECT 1 FROM Empleados WHERE IdEmpleado = @IdEmpleado)
        BEGIN
            THROW 50000, 'El empleado especificado no existe', 1;
        END
       
        IF @DiaSemana NOT BETWEEN 2 AND 7
        BEGIN
            THROW 50001, 'El día de la semana debe estar entre 2 (Lunes) y 7 (Sábado)', 1;
        END
       
        IF @HoraInicio >= @HoraFin
        BEGIN
            THROW 50002, 'La hora de inicio debe ser menor que la hora de fin', 1;
        END
       
        IF @HoraInicio < '08:00' OR @HoraFin > '20:00'
        BEGIN
            THROW 50003, 'El horario debe estar entre las 08:00 y 20:00 horas', 1;
        END
       
        IF EXISTS (SELECT 1 FROM HorariosEmpleado WHERE IdEmpleado = @IdEmpleado AND DiaSemana = @DiaSemana)
        BEGIN
            UPDATE HorariosEmpleado
            SET HoraInicio = @HoraInicio, HoraFin = @HoraFin, Activo = @Activo
            WHERE IdEmpleado = @IdEmpleado AND DiaSemana = @DiaSemana;
        END
        ELSE
        BEGIN
            INSERT INTO HorariosEmpleado (IdEmpleado, DiaSemana, HoraInicio, HoraFin, Activo)
            VALUES (@IdEmpleado, @DiaSemana, @HoraInicio, @HoraFin, @Activo);
        END
       
        COMMIT TRANSACTION;
       
        SELECT
            h.IdHorario,
            e.Nombre + ' ' + e.Apellido AS Empleado,
            h.DiaSemana,
            CASE h.DiaSemana WHEN 2 THEN 'Lunes' WHEN 3 THEN 'Martes' WHEN 4 THEN 'Miércoles' WHEN 5 THEN 'Jueves' WHEN 6 THEN 'Viernes' WHEN 7 THEN 'Sábado'
            END AS NombreDia,
            h.HoraInicio,
            h.HoraFin,
            h.Activo
        FROM HorariosEmpleado h
        INNER JOIN Empleados e ON h.IdEmpleado = e.IdEmpleado
        WHERE h.IdEmpleado = @IdEmpleado AND h.DiaSemana = @DiaSemana;
       
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
           
        THROW;
    END CATCH   
END;
GO

-------------------- EJEMPLOS SP_ACTUALIZAR_HORARIO:
-- traigo todos los horarios para modificarlos con el SP
-- select * from HorariosEmpleado

-- actualizo el horario de un empleado especifico
-- EXEC SP_ACTUALIZAR_HORARIO @IdEmpleado = 2, @DiaSemana = 2, @HoraInicio = '19:00', @HoraFin = '20:00', @Activo = 1;

-- creo nuevo horario para un dia especifico
-- EXEC SP_ACTUALIZAR_HORARIO @IdEmpleado = 2, @DiaSemana = 7, @HoraInicio = '08:00', @HoraFin = '14:00', @Activo = 1;