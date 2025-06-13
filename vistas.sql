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

-- VISTA 2 VISTA_GESTION_DE_TURNOS:
-- Vista de panel de control administrativo para supervisar y gestionar todos los turnos del negocio, centraliza información completa de 
-- turnos desde múltiples tablas relacionadas. El usuario objetivo de esta vista son los administradores y personal de gestión.
-- Caso de uso: Un administrador revisa los turnos del día, confirma citas, contacta clientes para recordatorios y actualiza el estado de servicios completados.

CREATE VIEW VISTA_GESTION_DE_TURNOS AS
SELECT 
    t.IdTurno,
    c.Nombre + ' ' + c.Apellido AS NombreCompleto,
    c.Telefono,
    c.Email,
    e.Nombre AS Empleado,
    s.Nombre AS Servicio,
    t.Fecha,
    t.Estado,
    t.Valoracion,
    s.Precio,
    t.Observaciones
FROM Turnos t
INNER JOIN Clientes c ON t.IdCliente = c.IdCliente
INNER JOIN Empleados e ON t.IdEmpleado = e.IdEmpleado
INNER JOIN Servicios s ON t.IdServicio = s.IdServicio;

-------------------- EJEMPLOS VISTA_GESTION_DE_TURNOS:

--1
-- SELECT * FROM VISTA_GESTION_DE_TURNOS;

--2
-- select * from VISTA_GESTION_DE_TURNOS 
-- where Estado = 'Pendiente'

--3
-- Select * from VISTA_GESTION_DE_TURNOS
-- where CONVERT(DATE, Fecha) = CONVERT(date, GETDATE())
-- Order By Fecha;

--4
-- SELECT * FROM VISTA_GESTION_DE_TURNOS
-- WHERE Empleado = 'Mar�a G�mez'
-- ORDER BY Fecha;

--5
-- SELECT 
--     Empleado,
--     AVG(Valoracion) AS ValoracionPromedio,
--     COUNT(*) AS CantidadTurnos
-- FROM VISTA_GESTION_DE_TURNOS
-- WHERE Estado = 'Completado'
-- GROUP BY Empleado
-- ORDER BY ValoracionPromedio DESC;


--6
-- SELECT NombreCompleto, Email, Telefono, Fecha, Servicio, Empleado
-- FROM VISTA_GESTION_DE_TURNOS
-- WHERE Estado = 'Confirmado'
-- AND CONVERT(DATE, Fecha) = CONVERT(DATE, DATEADD(day, 1, GETDATE())); 

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

-- VISTA 5 VISTA_HISTORIAL_CLIENTES:

-------------------- EJEMPLOS VISTA_HISTORIAL_CLIENTES: