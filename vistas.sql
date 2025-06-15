-- VISTAS

-- VISTA 1 VISTA_TURNOS_DISPONIBLES:
-- Vista principal para que los clientes visualicen la disponibilidad de turnos en tiempo real. 
-- Combina la información de los empleados (horarios laborales, servicios disponibles, si está activo o no) y 
-- presenta horarios en formato legible con nombres de días de la semana para mostrar la información esencial para la toma de decisiones.
-- Caso de uso: Un cliente accede al sistema y consulta esta vista para ver qué empleados están disponibles el martes por la tarde para un servicio de corte de cabello.

CREATE VIEW VISTA_TURNOS_DISPONIBLES AS
SELECT 
    e.IdEmpleado, 
    e.Nombre AS NombreEmpleado, 
    h.DiaSemana,
    CASE h.DiaSemana WHEN 1 THEN 'Lunes' WHEN 2 THEN 'Martes' WHEN 3 THEN 'Miércoles' WHEN 4 THEN 'Jueves' WHEN 5 THEN 'Viernes' WHEN 6 THEN 'Sábado' END AS NombreDia, 
    h.HoraInicio, 
    h.HoraFin, 
    s.IdServicio, 
    s.Nombre AS NombreServicio, 
    s.Duracion, 
    s.Precio
FROM Empleados e
INNER JOIN HorariosEmpleado h ON e.IdEmpleado = h.IdEmpleado
INNER JOIN Servicios s ON e.IdServicio = s.IdServicio
WHERE h.Activo = 1 AND e.IdRol = 2;

-------------------- EJEMPLOS VISTA_TURNOS_DISPONIBLES:

-- pido todos los datos de la vista
-- SELECT * FROM VISTA_TURNOS_DISPONIBLES;

-- buscamos disponibilidad para un dia concreto
-- SELECT NombreEmpleado, NombreDia, HoraInicio, HoraFin, NombreServicio, Precio, Duracion
-- FROM VISTA_TURNOS_DISPONIBLES 
-- WHERE NombreDia = 'Martes'
-- AND HoraFin = '17:00'
-- ORDER BY HoraInicio;

-----------------------------------------------------------


-- VISTA 3 VISTA_SERVICIOS:

-------------------- EJEMPLOS VISTA_SERVICIOS:



-----------------------------------------------------------

-- VISTA 4 VISTA_HORARIO_EMPLEADOS:
-- Vista de gestión de recursos humanos para optimizar horarios y cargas de trabajo de empleados. 
-- Mapea la disponibilidad semanal de cada empleado y correlaciona horarios definidos con carga real de trabajo mediante el conteo de turnos por día. 
-- Los usuarios objetivo son administradores y gestores de personal.
-- Caso de uso: Identifica empleados con baja ocupación para asignar más turnos, detecta sobrecarga de trabajo y planificar horarios semanales según demanda.

CREATE VIEW VISTA_HORARIO_EMPLEADOS AS
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

-----------------------------------------------------------

