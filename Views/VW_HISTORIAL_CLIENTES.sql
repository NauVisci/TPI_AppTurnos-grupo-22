USE GestionTurnos

-- VISTA 5 VW_HISTORIAL_CLIENTES:
-- Vista de registro histórico completo de la relación comercial con cada cliente. 
-- Mantiene trazabilidad de todos los servicios completados por cliente, ordenados cronológicamente y 
-- numerados secuencialmente. Los usuarios objetivo son administradores, empleados y opcionalmente clientes (su propio historial).
-- Caso de uso: Identificar clientes frecuentes para programas de lealtad, revisar preferencias antes de nuevos turnos, y 
-- contactar clientes para promociones de servicios que ya utilizaron.

CREATE VIEW VW_HISTORIAL_CLIENTES AS
SELECT c.IdCliente, c.Nombre + ' ' + c.Apellido 
    AS NombreCompleto, c.DNI, c.Telefono, t.IdTurno, t.Fecha, e.Nombre 
    AS Empleado, s.Nombre 
    AS Servicio, s.Precio, t.Estado, t.Valoracion, t.Observaciones,
    ROW_NUMBER() OVER (PARTITION BY c.IdCliente ORDER BY t.Fecha DESC) AS NumeroVisita
FROM Clientes c
INNER JOIN Turnos t ON c.IdCliente = t.IdCliente
INNER JOIN Empleados e ON t.IdEmpleado = e.IdEmpleado
INNER JOIN Servicios s ON t.IdServicio = s.IdServicio
WHERE t.Estado = 'Completado';

-------------------- EJEMPLOS VISTA_HISTORIAL_CLIENTES:

--1
--IdentificaciOn de clientes frecuentes

--SELECT 
--    NombreCompleto, 
--    MAX(NumeroVisita) AS TotalVisitas,
--    AVG(Valoracion) AS SatisfaccionPromedio
--FROM VISTA_HISTORIAL_CLIENTES
--GROUP BY IdCliente, NombreCompleto
--HAVING MAX(NumeroVisita) > 3
--ORDER BY TotalVisitas DESC;

--2
--Historial individual para atenciOn al cliente

--SELECT * FROM VISTA_HISTORIAL_CLIENTES
--WHERE IdCliente = 5  -- ID del cliente especIfico
--ORDER BY Fecha DESC;

--3
--AnAlisis de preferencias por cliente
--SELECT 
--    NombreCompleto,
--    Servicio,
--    COUNT(*) AS VecesSolicitado,
--    AVG(Precio) AS GastoPromedio
--FROM VISTA_HISTORIAL_CLIENTES
--WHERE NumeroVisita <= 5  -- Primeras 5 visitas
--GROUP BY IdCliente, NombreCompleto, Servicio;