USE GestionTurnos

CREATE VIEW VW_ServiciosDisponibles AS
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
	GROUP BY S.IdServicio, S.Nombre, S.Duracion, S.Precio
;
