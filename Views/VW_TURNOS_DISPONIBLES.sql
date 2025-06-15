USE GestionTurnos

-- VISTA 1 VW_TURNOS_DISPONIBLES:
-- Vista principal para que los clientes visualicen la disponibilidad de turnos en tiempo real. 
-- Combina la información de los empleados (horarios laborales, servicios disponibles, si está activo o no) y 
-- presenta horarios en formato legible con nombres de días de la semana para mostrar la información esencial para la toma de decisiones.
-- Caso de uso: Un cliente accede al sistema y consulta esta vista para ver qué empleados están disponibles el martes por la tarde para un servicio de corte de cabello.

CREATE VIEW VW_TURNOS_DISPONIBLES AS
SELECT 
    e.IdEmpleado, 
    e.Nombre AS NombreEmpleado, 
    h.DiaSemana,
    CASE h.DiaSemana 
        WHEN 1 THEN 'Lunes' 
        WHEN 2 THEN 'Martes' 
        WHEN 3 THEN 'Miércoles' 
        WHEN 4 THEN 'Jueves' 
        WHEN 5 THEN 'Viernes' 
        WHEN 6 THEN 'Sábado' 
    END AS NombreDia, 
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

-------------------- EJEMPLOS VW_TURNOS_DISPONIBLES:

-- pido todos los datos de la vista
-- SELECT * FROM VW_TURNOS_DISPONIBLES;

-- buscamos disponibilidad para un dia concreto
-- SELECT NombreEmpleado, NombreDia, HoraInicio, HoraFin, NombreServicio, Precio, Duracion
-- FROM VW_TURNOS_DISPONIBLES 
-- WHERE NombreDia = 'Martes'
-- AND HoraFin = '17:00'
-- ORDER BY HoraInicio;