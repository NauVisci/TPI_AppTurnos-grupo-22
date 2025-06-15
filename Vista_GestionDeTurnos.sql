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