-- VISTA 5 VISTA_HISTORIAL_CLIENTES:
--Esta vista est� dise�ada para proporcionar un historial completo de los servicios que han utilizado los clientes, enfoc�ndose espec�ficamente en los turnos 
--completados. Es particularmente �til para an�lisis de fidelizaci�n y seguimiento de clientes recurrentes.

CREATE VIEW VISTA_HISTORIAL_CLIENTES AS
SELECT c.IdCliente, c.Nombre + ' ' + c.Apellido AS NombreCompleto, c.DNI, c.Telefono, t.IdTurno, t.Fecha, e.Nombre AS Empleado, s.Nombre AS Servicio, s.Precio, t.Estado, t.Valoracion, t.Observaciones,
    ROW_NUMBER() OVER (PARTITION BY c.IdCliente ORDER BY t.Fecha DESC) AS NumeroVisita
FROM Clientes c
INNER JOIN Turnos t ON c.IdCliente = t.IdCliente
INNER JOIN Empleados e ON t.IdEmpleado = e.IdEmpleado
INNER JOIN Servicios s ON t.IdServicio = s.IdServicio
WHERE t.Estado = 'Completado';

-------------------- EJEMPLOS VISTA_HISTORIAL_CLIENTES:

--1
--Identificaci�n de clientes frecuentes

--SELECT 
--    NombreCompleto, 
--    MAX(NumeroVisita) AS TotalVisitas,
--    AVG(Valoracion) AS SatisfaccionPromedio
--FROM VISTA_HISTORIAL_CLIENTES
--GROUP BY IdCliente, NombreCompleto
--HAVING MAX(NumeroVisita) > 3
--ORDER BY TotalVisitas DESC;

--2
--Historial individual para atenci�n al cliente

--SELECT * FROM VISTA_HISTORIAL_CLIENTES
--WHERE IdCliente = 5  -- ID del cliente espec�fico
--ORDER BY Fecha DESC;

--3
--An�lisis de preferencias por cliente
--SELECT 
--    NombreCompleto,
--    Servicio,
--    COUNT(*) AS VecesSolicitado,
--    AVG(Precio) AS GastoPromedio
--FROM VISTA_HISTORIAL_CLIENTES
--WHERE NumeroVisita <= 5  -- Primeras 5 visitas
--GROUP BY IdCliente, NombreCompleto, Servicio;