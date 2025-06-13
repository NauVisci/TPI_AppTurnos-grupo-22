--Vista VISTA_GESTION_DE_TURNOS
--Combina datos relevantes para la administración de turnos.
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

--1
SELECT * FROM VISTA_GESTION_DE_TURNOS;

--2
select * from VISTA_GESTION_DE_TURNOS 
where Estado = 'Pendiente'

--3
Select * from VISTA_GESTION_DE_TURNOS
where CONVERT(DATE, Fecha) = CONVERT(date, GETDATE())
Order By Fecha;

--4
SELECT * FROM VISTA_GESTION_DE_TURNOS
WHERE Empleado = 'María Gómez'
ORDER BY Fecha;

--5
SELECT 
    Empleado,
    AVG(Valoracion) AS ValoracionPromedio,
    COUNT(*) AS CantidadTurnos
FROM VISTA_GESTION_DE_TURNOS
WHERE Estado = 'Completado'
GROUP BY Empleado
ORDER BY ValoracionPromedio DESC;


--6
SELECT NombreCompleto, Email, Telefono, Fecha, Servicio, Empleado
FROM VISTA_GESTION_DE_TURNOS
WHERE Estado = 'Confirmado'
AND CONVERT(DATE, Fecha) = CONVERT(DATE, DATEADD(day, 1, GETDATE())); 