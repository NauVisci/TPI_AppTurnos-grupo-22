--Procedimientos almacenados

-- PROCEDIMIENTO 1: SP_ESTADISTICAS_EMPLEADO
-- Calcula estadísticas de rendimiento detalladas por empleado en un rango de fechas específico. Si no se proporcionan fechas, usa el mes actual 
--por defecto. Genera métricas completas: turnos totales, completados, cancelados, ingresos generados, promedio de calificaciones y promedio de turnos 
--por día. Permite consultar un empleado específico o todos los empleados, ordenando resultados por ingresos generados para identificar empleados más 
--productivos.

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