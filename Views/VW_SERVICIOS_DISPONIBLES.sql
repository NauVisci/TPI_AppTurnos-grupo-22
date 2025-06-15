USE GestionTurnos

-- VISTA 3 VW_SERVICIOS_DISPONIBLES:
-- Vista de dashboard analítico de servicios con métricas de rendimiento y popularidad. 
-- Presenta el catálogo completo de servicios con información básica y calcula métricas agregadas 
-- (total de turnos, promedio de valoraciones, ingresos totales). El público objetivo de la vista son clientes (información básica) 
-- y administradores (algunos datos relevantes del negocio).
-- Caso de uso: Los clientes consultan servicios disponibles y precios, mientras los administradores analizan qué 
-- servicios son más demandados y rentables para tomar decisiones de negocio. La vista se puede combinar con otraconsulta de tipo 
-- “select” para precisar más datos, por ejemplo, obtener datos por fecha.

CREATE VIEW VW_SERVICIOS_DISPONIBLES AS
SELECT
	S.IdServicio,
	S.Nombre,
	S.Duracion * 60 AS DuracionMinutos,
	S.Precio,
	COUNT(DISTINCT E.IdEmpleado) AS PersonalCapacitado,
	COUNT(DISTINCT T.IdTurno) AS HistoricoTurnos,
	AVG(T.Valoracion) AS PromedioValoracion,
	S.Precio * COUNT(DISTINCT T.IdTurno) AS IngresoTotal
FROM Servicios S
LEFT JOIN Empleados E ON E.IdServicio = S.IdServicio AND E.IdRol = 2
LEFT JOIN Turnos T ON T.IdServicio = S.IdServicio AND T.Estado = 'Completado'
GROUP BY S.IdServicio, S.Nombre, S.Duracion, S.Precio;