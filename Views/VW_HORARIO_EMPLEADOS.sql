USE GestionTurnos

-- VISTA 4 VW_HORARIO_EMPLEADOS:
-- Vista de gestión de recursos humanos para optimizar horarios y cargas de trabajo de empleados. 
-- Mapea la disponibilidad semanal de cada empleado y correlaciona horarios definidos con carga real de trabajo mediante el conteo de turnos por día. 
-- Los usuarios objetivo son administradores y gestores de personal.
-- Caso de uso: Identifica empleados con baja ocupación para asignar más turnos, detecta sobrecarga de trabajo y planificar horarios semanales según demanda.

CREATE VIEW VW_HORARIO_EMPLEADOS AS
SELECT 
    e.IdEmpleado, 
    e.Nombre, 
    e.Apellido, 
    s.Categoria AS Especialidad,
    h.DiaSemana,
    CASE h.DiaSemana WHEN 1 THEN 'Lunes' WHEN 2 THEN 'Martes' WHEN 3 THEN 'Miércoles' WHEN 4 THEN 'Jueves' WHEN 5 THEN 'Viernes' WHEN 6 THEN 'Sábado' END AS NombreDia,
    h.HoraInicio,
    h.HoraFin,
    h.Activo,
    COUNT(t.IdTurno) AS TurnosDelDia,
    DATEDIFF(HOUR, h.HoraInicio, h.HoraFin) AS HorasDisponibles,
    CASE WHEN COUNT(t.IdTurno) = 0 THEN 'Sin carga' WHEN COUNT(t.IdTurno) <= 3 THEN 'Carga baja' WHEN COUNT(t.IdTurno) <= 6 THEN 'Carga normal' ELSE 'Sobrecargado' END AS NivelCarga
FROM Empleados e
INNER JOIN Servicios s ON e.IdServicio = s.IdServicio
LEFT JOIN HorariosEmpleado h ON e.IdEmpleado = h.IdEmpleado
LEFT JOIN Turnos t ON e.IdEmpleado = t.IdEmpleado 
    AND CASE DATEPART(WEEKDAY, t.FechaTurno) WHEN 2 THEN 1 WHEN 3 THEN 2 WHEN 4 THEN 3 WHEN 5 THEN 4 WHEN 6 THEN 5 WHEN 7 THEN 6 END = h.DiaSemana
    AND t.Estado IN ('Confirmado', 'Completado')
    AND t.FechaTurno >= CAST(GETDATE() AS DATE)
WHERE e.IdRol = 2
GROUP BY e.IdEmpleado, e.Nombre, e.Apellido, s.Categoria, h.DiaSemana, h.HoraInicio, h.HoraFin, h.Activo;

-------------------- EJEMPLOS VISTA_HORARIO_EMPLEADOS:
-- pido todos los datos de la vista
-- SELECT * FROM VISTA_HORARIO_EMPLEADOS;

-- buscamos empleados con baja carga de trabajo
-- SELECT Nombre + ' ' + Apellido AS EmpleadoCompleto, NombreDia, HorasDisponibles, TurnosDelDia, NivelCarga
-- FROM VISTA_HORARIO_EMPLEADOS 
-- WHERE NivelCarga IN ('Sin carga', 'Carga baja')
-- ORDER BY TurnosDelDia;
