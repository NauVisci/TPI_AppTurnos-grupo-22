USE GestionTurnos

-- PROCEDIMIENTO ALMACENADO: AGENDAR TURNO

CREATE PROCEDURE SP_AgendarTurno (
	@IdCliente int, @IdServicio INT, @IdEmpleado INT = NULL,@FechaTurno DATE, @HoraTurno TIME )
AS BEGIN
	
	SET NOCOUNT ON; 

	DECLARE @Error NVARCHAR(500);
	DECLARE @IdTurnoNuevo INT;
	DECLARE @NombreEmpleado NVARCHAR(255);
	
	BEGIN TRY 
		BEGIN TRANSACTION;

        -- Validación: fecha y hora deben ser futuras
        IF (CAST(@FechaTurno AS DATETIME) + CAST(@HoraTurno AS DATETIME)) <= GETDATE()
        BEGIN 
            SET @Error = 'No puedes reservar turnos en tiempo pasado';
            THROW 60001, @Error, 1;
        END


		--Validacion para sacar turnos los dias de atencion, martes a sabado

		IF DATEPART(WEEKDAY, @FechaTurno) = 1 OR DATEPART(WEEKDAY, @FechaTurno) = 2

			BEGIN 
				SET @Error = 'Los turnos solo se pueden agendar de martes a sabados';
				THROW 60002, @Error, 1;
			END

        -- Validación: turno entre 8:00 y 20:00
        IF @HoraTurno < '08:00:00' OR @HoraTurno >= '20:00:00'
        BEGIN 
            SET @Error = 'Los turnos solo se pueden agendar de 8:00 a 19:59 horas';
            THROW 60003, @Error, 1;
        END


		-- asignacion de empleado
			
		IF @IdEmpleado IS NULL
		BEGIN
			SELECT TOP 1 
				@IdEmpleado = E.IdEmpleado,
				@NombreEmpleado = E.Nombre + ' ' + E.Apellido
			FROM Empleados E
			INNER JOIN HorariosEmpleado H ON E.IdEmpleado = H.IdEmpleado
			WHERE H.DiaSemana = DATEPART(WEEKDAY, @FechaTurno) - 1
				AND H.Activo = 1
				AND E.IdRol = 2
				AND @HoraTurno BETWEEN H.HoraInicio AND H.HoraFin
				AND NOT EXISTS (
					SELECT 1 FROM Turnos T
					WHERE T.IdEmpleado = E.IdEmpleado
						AND T.FechaTurno = @FechaTurno
						AND T.HoraTurno = @HoraTurno
						AND T.Estado IN ('Confirmado', 'Completado')
				)
			ORDER BY NEWID();

			IF @IdEmpleado IS NULL
			BEGIN
				SET @Error = 'No hay empleados disponibles para ese horario';
				THROW 60006, @Error, 1;
			END
		END
		ELSE
		BEGIN
			SELECT @NombreEmpleado = Nombre + ' ' + Apellido
			FROM Empleados
			WHERE IdEmpleado = @IdEmpleado;
		END


		-- Validar que el empleado este disponible

        IF EXISTS (
            SELECT 1 FROM Turnos
            WHERE IdEmpleado = @IdEmpleado
                AND FechaTurno = @FechaTurno
                AND HoraTurno = @HoraTurno
                AND Estado IN ('Confirmado','Pendiente')
				--AND Estado IN ('Confirmado','Completado')
        )
        BEGIN 
            SET @Error = 'Empleado no disponible en ese horario';
            THROW 60004, @Error, 1;
        END

		-- Insertar el turno 

		
		INSERT INTO Turnos (
			IdCliente, IdServicio, IdEmpleado, ProfesionalElegido,
			Estado, FechaTurno, HoraTurno, Observaciones
		)
		VALUES (
			@IdCliente, @IdServicio, @IdEmpleado, @NombreEmpleado,
			'Pendiente', @FechaTurno, @HoraTurno, GETDATE()
		);

        SET @IdTurnoNuevo = SCOPE_IDENTITY();

        COMMIT TRANSACTION;


		-- Retornar info del turno creado

        SELECT  
            T.IdTurno,
            C.Nombre + ' ' + C.Apellido AS Cliente,
            E.Nombre AS Empleado,
            S.Nombre AS Servicio,
            T.FechaTurno,
            T.HoraTurno,
            T.Estado
        FROM Turnos T
        INNER JOIN Clientes C ON T.IdCliente = C.IdCliente
        INNER JOIN Empleados E ON T.IdEmpleado = E.IdEmpleado
        INNER JOIN Servicios S ON T.IdServicio = S.IdServicio
        WHERE T.IdTurno = @IdTurnoNuevo;

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH
END
