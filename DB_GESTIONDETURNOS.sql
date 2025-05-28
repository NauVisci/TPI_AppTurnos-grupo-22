Select * from Clientes;
Select * from Empleados;
Select * from GestionDeRoles;
Select * from Servicios;
Select * from Turnos;
Select * from Estadisticas;

--INSERT INTO GestionDeRoles (IdRol, NombreRol) VALUES
--(1, 'Administrador'),
--(2, 'Empleado'),
--(3, 'Cliente');

--INSERT INTO Servicios (IdServicio, Nombre, Duracion, Precio) VALUES
--(1, 'Corte de cabello', 0.5, 1500.00),
--(2, 'Tinte completo', 2.0, 3500.00),
--(3, 'Reflejos', 1.5, 2800.00),
--(4, 'Alisado permanente', 3.0, 6000.00),
--(5, 'Arreglo de barba', 0.5, 1000.00),
--(6, 'Peinado para evento', 1.0, 2500.00),
--(7, 'Manicuría básica', 0.5, 1200.00),
--(8, 'Tratamiento capilar', 1.0, 2000.00);

--INSERT INTO Clientes (IdCliente, Domicilio, Telefono, FechaCreacion, DNI, IdRol) VALUES
--(1, 'Av. Corrientes 1234', '11-5555-1234', '2023-01-15', '30123456', 3),
--(2, 'Lavalle 567', '11-5555-5678', '2023-02-20', '32567890', 3),
--(3, 'Florida 789', '11-5555-9012', '2023-03-10', '28901234', 3),
--(4, 'Cabildo 2345', '11-5555-3456', '2023-04-05', '33456789', 3),
--(5, 'Santa Fe 123', '11-5555-7890', '2023-05-12', '35789012', 3),
--(6, 'Pueyrredón 456', '11-5555-2345', '2023-06-18', '31234567', 3),
--(7, 'Rivadavia 7890', '11-5555-6789', '2023-07-22', '34678901', 3),
--(8, 'Belgrano 345', '11-5555-0123', '2023-08-30', '29876543', 3);

--INSERT INTO Empleados (IdEmpleado, Nombre, Especialidad, AltaEmpleado, IdRol) VALUES
--(1, 'María Gómez', 'Colorista', '2022-01-10', 2),
--(2, 'Carlos López', 'Barbero', '2022-03-15', 2),
--(3, 'Ana Rodríguez', 'Peinados', '2022-05-20', 2),
--(4, 'Lucía Fernández', 'Tratamientos capilares', '2022-07-12', 2),
--(5, 'Pedro Martínez', 'Cortes unisex', '2022-09-05', 2),
--(6, 'Sofía Pérez', 'Manicuría', '2022-11-18', 2),
--(7, 'Juan García', 'Administrador', '2022-01-05', 1);

--INSERT INTO Turnos (IdTurno, IdCliente, IdServicio, IdEmpleado, ProfesionalElegido, Estado, Fecha, Valoracion) VALUES
--(1, 1, 1, 5, 'Pedro Martínez', 'Completado', '2023-09-01 10:00:00', 4.5),
--(2, 2, 2, 1, 'María Gómez', 'Completado', '2023-09-01 11:00:00', 5.0),
--(3, 3, 5, 2, 'Carlos López', 'Completado', '2023-09-01 12:00:00', 4.0),
--(4, 4, 3, 1, 'María Gómez', 'Cancelado', '2023-09-02 14:00:00', NULL),
--(5, 5, 6, 3, 'Ana Rodríguez', 'Completado', '2023-09-02 16:00:00', 4.8),
--(6, 6, 4, 4, 'Lucía Fernández', 'Completado', '2023-09-03 10:00:00', 4.2),
--(7, 7, 7, 6, 'Sofía Pérez', 'Pendiente', '2023-09-04 11:00:00', NULL),
--(8, 8, 1, 5, 'Pedro Martínez', 'Confirmado', '2023-09-04 15:00:00', NULL),
--(9, 1, 8, 4, 'Lucía Fernández', 'Completado', '2023-09-05 12:00:00', 4.7),
--(10, 2, 1, 5, 'Pedro Martínez', 'Completado', '2023-09-05 16:00:00', 4.9),
--(11, 3, 2, 1, 'María Gómez', 'Confirmado', '2023-09-06 10:00:00', NULL),
--(12, 4, 5, 2, 'Carlos López', 'Pendiente', '2023-09-06 14:00:00', NULL);

--INSERT INTO Estadisticas (IdEstadistica, IdEmpleado, TurnosAtendidos, IngresosGenerados, PromedioCalificacion, PromedioTurnosMes) VALUES
--(1, 1, 45, 157500.00, 4.8, 175),
--(2, 2, 38, 38000.00, 4.3, 143),
--(3, 3, 28, 70000.00, 4.6, 186),
--(4, 4, 32, 128000.00, 4.5, 165),
--(5, 5, 50, 75000.00, 4.7, 120),
--(6, 6, 25, 30000.00, 4.4, 138);