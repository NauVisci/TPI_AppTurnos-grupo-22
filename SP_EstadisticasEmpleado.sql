-- PROCEDIMIENTO: SP_ESTADISTICAS_EMPLEADO
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