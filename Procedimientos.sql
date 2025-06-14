-- PROCEDIMIENTOS ALMACENADOS

-- PROCEDIMIENTO 1: SP_ESTADISTICAS_EMPLEADO
-- Calcula estadisticas de rendimiento detalladas por empleado en un rango de fechas especifico. Si no se proporcionan fechas, usa el mes actual 
-- por defecto. Genera metricas completas: turnos totales, completados, cancelados, ingresos generados, promedio de calificaciones y promedio de turnos 
-- por dia. Permite consultar un empleado especifico o todos los empleados, ordenando resultados por ingresos generados para identificar empleados mas 
-- productivos.

CREATE PROCEDURE SP_ESTADISTICAS_EMPLEADO
    @IdEmpleado INT = NULL, -- Si es NULL, devuelve todos los empleados
    @FechaDesde DATE = NULL,
    @FechaHasta DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Si no se especifican fechas, usar el mes actual
    IF @FechaDesde IS NULL
        SET @FechaDesde = DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1);
    
    IF @FechaHasta IS NULL
        SET @FechaHasta = EOMONTH(GETDATE());
    
    SELECT 
        e.IdEmpleado,
        e.Nombre,
        COUNT(t.IdTurno) AS TurnosTotal,
        COUNT(CASE WHEN t.Estado = 'Completado' THEN 1 END) AS TurnosCompletados,
        COUNT(CASE WHEN t.Estado = 'Cancelado' THEN 1 END) AS TurnosCancelados,
        ISNULL(SUM(CASE WHEN t.Estado = 'Completado' THEN s.Precio ELSE 0 END), 0) AS IngresosGenerados,
        ISNULL(AVG(CASE WHEN t.Estado = 'Completado' THEN CAST(t.Valoracion AS FLOAT) END), 0) AS PromedioCalificacion,
        ISNULL(COUNT(CASE WHEN t.Estado = 'Completado' THEN 1 END) * 1.0 / NULLIF(DATEDIFF(DAY, @FechaDesde, @FechaHasta), 0), 0) AS PromedioTurnosPorDia
    FROM Empleados e
    LEFT JOIN Turnos t ON e.IdEmpleado = t.IdEmpleado 
        AND CAST(t.Fecha AS DATE) BETWEEN @FechaDesde AND @FechaHasta
    LEFT JOIN Servicios s ON t.IdServicio = s.IdServicio
    WHERE e.IdRol = 2 -- Solo empleados
        AND (@IdEmpleado IS NULL OR e.IdEmpleado = @IdEmpleado)
    GROUP BY e.IdEmpleado, e.Nombre
    ORDER BY IngresosGenerados DESC;
END;

-------------------- EJEMPLOS SP_ESTADISTICAS_EMPLEADO:
--1
--Estadísticas de un empleado específico (ID 1) en septiembre 2023:
--EXEC SP_ESTADISTICAS_EMPLEADO 
--    @IdEmpleado = 1, 
--    @FechaDesde = '2023-09-01', 
--    @FechaHasta = '2023-09-30';

--2
--Comparativa de todos los empleados en el último trimestre:
--EXEC SP_ESTADISTICAS_EMPLEADO
--    @FechaDesde = '2023-07-01',
--    @FechaHasta = '2023-09-30';

--3
--Análisis de la primera quincena de septiembre:
--EXEC SP_ESTADISTICAS_EMPLEADO
--    @FechaDesde = '2023-09-01',
--    @FechaHasta = '2023-09-15';
-----------------------------------------------------------

-- PROCEDIMIENTO 2 SP_ESTADISTICAS_EMPLEADO:

-------------------- EJEMPLOS SP_ESTADISTICAS_EMPLEADO:



-----------------------------------------------------------

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