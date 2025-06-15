USE GestionTurnos
GO

INSERT INTO Servicios (IdServicio, Nombre, Duracion, Precio, Categoria) VALUES
(1, 'Corte Clásico', 45.00, 2500.00, 'Cortes'),
(2, 'Corte y Peinado Premium', 60.00, 3500.00, 'Cortes'),
(3, 'Planchado Express', 30.00, 1800.00, 'Peinados'),
(4, 'Planchado y Brushing', 50.00, 2800.00, 'Peinados'),
(5, 'Tintura Completa', 120.00, 8500.00, 'Coloración'),
(6, 'Retoque de Raíces', 75.00, 5200.00, 'Coloración'),
(7, 'Arreglo de Barba', 25.00, 1500.00, 'Barbería'),
(8, 'Barba Completa + Bigote', 40.00, 2200.00, 'Barbería'),
(9, 'Corte Moderno Fade', 50.00, 3000.00, 'Cortes'),
(10, 'Corte Infantil', 35.00, 2000.00, 'Cortes'),
(11, 'Peinado Novia', 90.00, 6500.00, 'Peinados'),
(12, 'Rulos y Ondas', 40.00, 2400.00, 'Peinados'),
(13, 'Mechas Californianas', 150.00, 12000.00, 'Coloración'),
(14, 'Balayage', 180.00, 15000.00, 'Coloración'),
(15, 'Decoloración Completa', 200.00, 18000.00, 'Coloración'),
(16, 'Afeitado Clásico', 30.00, 1800.00, 'Barbería'),
(17, 'Tratamiento Capilar', 60.00, 4500.00, 'Tratamientos'),
(18, 'Botox Capilar', 120.00, 8000.00, 'Tratamientos'),
(19, 'Keratina', 150.00, 12500.00, 'Tratamientos'),
(20, 'Corte Bob', 55.00, 3200.00, 'Cortes');

INSERT INTO GestionDeRoles (IdRol, NombreRol) VALUES
(1, 'Admin'),
(2, 'Empleado'),

INSERT INTO Empleados (IdEmpleado, Nombre, Apellido, IdServicio, FechaAltaEmpleado, IdRol) VALUES
(1, 'María', 'González', 1, '2023-01-15', 2),
(2, 'Carlos', 'Rodríguez', 2, '2023-03-10', 2),
(3, 'Ana', 'López', 3, '2023-02-20', 2),
(4, 'Diego', 'Martínez', 5, '2022-11-05', 2),
(5, 'Sofía', 'Fernández', 7, '2023-06-12', 2),
(6, 'Roberto', 'Silva', 8, '2022-08-18', 2),
(7, 'Valentina', 'Torres', 4, '2023-04-25', 2),
(8, 'Joaquín', 'Morales', 6, '2023-05-30', 2),
(9, 'Lucía', 'Campos', 9, '2023-07-18', 2),
(10, 'Mateo', 'Vargas', 10, '2023-08-22', 2),
(11, 'Isabella', 'Ramos', 11, '2022-12-03', 2),
(12, 'Sebastián', 'Ortega', 16, '2023-09-15', 2),
(13, 'Camila', 'Herrera', 13, '2022-10-12', 2),
(14, 'Nicolás', 'Peña', 17, '2023-01-28', 2),
(15, 'Valeria', 'Cruz', 14, '2022-09-07', 2),
(16, 'Adrián', 'Soto', 18, '2023-03-14', 2),
(17, 'Florencia', 'Mendez', 19, '2022-11-25', 2),
(18, 'Tomás', 'Aguilar', 20, '2023-05-09', 2);

INSERT INTO Clientes (IdCliente, Nombre, Apellido, Email, Domicilio, Telefono, FechaCreacion, DNI, IdRol) VALUES
(1, 'Laura', 'Pérez', 'laura.perez@email.com', 'Av. Libertador 1250', '11-2345-6789', '2023-08-15', '35678912', 1),
(2, 'Miguel', 'Ramírez', 'miguel.ramirez@email.com', 'San Martín 890', '11-3456-7890', '2023-07-22', '28456789', 1),
(3, 'Carla', 'Jiménez', 'carla.jimenez@email.com', 'Rivadavia 2340', '11-4567-8901', '2023-09-10', '42123456', 1),
(4, 'Fernando', 'Castro', 'fernando.castro@email.com', 'Belgrano 567', '11-5678-9012', '2023-06-05', '31789654', 1),
(5, 'Natalia', 'Vega', 'natalia.vega@email.com', 'Corrientes 1789', '11-6789-0123', '2023-10-18', '39876543', 1),
(6, 'Pablo', 'Herrera', 'pablo.herrera@email.com', 'Florida 445', '11-7890-1234', '2023-05-12', '27654321', 1),
(7, 'Gabriela', 'Ruiz', 'gabriela.ruiz@email.com', 'Maipú 1123', '11-8901-2345', '2023-11-02', '44567890', 1),
(8, 'Andrés', 'Mendoza', 'andres.mendoza@email.com', 'Tucumán 778', '11-9012-3456', '2023-09-28', '33445566', 1),
(9, 'Julieta', 'Romero', 'julieta.romero@email.com', 'Av. Cabildo 2890', '11-1122-3344', '2023-12-05', '36789123', 1),
(10, 'Ricardo', 'Díaz', 'ricardo.diaz@email.com', 'Callao 1456', '11-2233-4455', '2023-11-18', '29876543', 1),
(11, 'Martina', 'Paredes', 'martina.paredes@email.com', 'Santa Fe 3421', '11-3344-5566', '2024-01-12', '41234567', 1),
(12, 'Emilio', 'Gutiérrez', 'emilio.gutierrez@email.com', 'Las Heras 789', '11-4455-6677', '2024-02-20', '32567890', 1),
(13, 'Antonella', 'Moreno', 'antonella.moreno@email.com', 'Palermo 1567', '11-5566-7788', '2023-10-30', '38901234', 1),
(14, 'Ignacio', 'Iglesias', 'ignacio.iglesias@email.com', 'Recoleta 234', '11-6677-8899', '2024-03-08', '30123456', 1),
(15, 'Renata', 'Flores', 'renata.flores@email.com', 'Núñez 890', '11-7788-9900', '2023-09-14', '37456789', 1),
(16, 'Maximiliano', 'Luna', 'maximiliano.luna@email.com', 'Vicente López 1123', '11-8899-0011', '2024-01-25', '34789012', 1),
(17, 'Agustina', 'Blanco', 'agustina.blanco@email.com', 'Belgrano R 456', '11-9900-1122', '2023-12-12', '43210987', 1),
(18, 'Santiago', 'Navarro', 'santiago.navarro@email.com', 'Villa Urquiza 678', '11-0011-2233', '2024-02-05', '35678901', 1),
(19, 'Valentino', 'Acosta', 'valentino.acosta@email.com', 'Colegiales 345', '11-1234-5678', '2023-11-28', '29345678', 1),
(20, 'Delfina', 'Suárez', 'delfina.suarez@email.com', 'Villa Crespo 912', '11-2345-6789', '2024-03-15', '40567890', 1);

INSERT INTO Turnos (IdCliente, IdServicio, IdEmpleado, ProfesionalElegido, Estado, FechaTurno, HoraTurno, FechaCreacion, Observaciones, Valoracion) VALUES
(1, 1, 1, 'María González', 'Completado', '2024-06-10', '10:00:00', '2024-06-08 14:30:00', 'Cliente habitual, prefiere corte tradicional', 4.8),
(2, 8, 6, 'Roberto Silva', 'Completado', '2024-06-12', '15:30:00', '2024-06-10 09:15:00', 'Primera vez, muy conforme con el resultado', 5.0),
(3, 5, 4, 'Diego Martínez', 'Completado', '2024-06-11', '11:00:00', '2024-06-09 16:20:00', 'Cambio de look completo, rubio ceniza', 4.9),
(4, 2, 2, 'Carlos Rodríguez', 'Confirmado', '2024-06-16', '09:00:00', '2024-06-14 10:45:00', 'Evento especial, requiere peinado elegante', NULL),
(5, 3, 3, 'Ana López', 'Confirmado', '2024-06-17', '14:00:00', '2024-06-15 12:30:00', 'Casamiento familiar, planchado perfecto', NULL),
(6, 7, 5, 'Sofía Fernández', 'Pendiente', '2024-06-18', '16:00:00', '2024-06-15 18:00:00', 'Primera vez con barbera mujer', NULL),
(7, 6, 8, 'Joaquín Morales', 'Pendiente', '2024-06-19', '10:30:00', '2024-06-15 20:15:00', 'Retoque urgente antes de entrevista laboral', NULL),
(8, 4, 7, 'Valentina Torres', 'Cancelado', '2024-06-13', '13:00:00', '2024-06-11 11:00:00', 'Cliente canceló por enfermedad', NULL),
(9, 9, 9, 'Lucía Campos', 'Completado', '2024-06-14', '11:30:00', '2024-06-12 16:45:00', 'Fade moderno, cliente joven muy satisfecho', 4.7),
(10, 10, 10, 'Mateo Vargas', 'Completado', '2024-06-15', '10:00:00', '2024-06-13 14:20:00', 'Niño de 8 años, primera vez en peluquería', 4.6),
(11, 11, 11, 'Isabella Ramos', 'Confirmado', '2024-06-20', '08:00:00', '2024-06-16 19:30:00', 'Peinado para boda, prueba previa realizada', NULL),
(12, 16, 12, 'Sebastián Ortega', 'Completado', '2024-06-16', '17:00:00', '2024-06-14 11:15:00', 'Afeitado tradicional con navaja', 4.9),
(13, 13, 13, 'Camila Herrera', 'Pendiente', '2024-06-21', '15:00:00', '2024-06-17 10:00:00', 'Mechas rubias sobre base castaña', NULL),
(14, 17, 14, 'Nicolás Peña', 'Completado', '2024-06-17', '16:30:00', '2024-06-15 13:45:00', 'Tratamiento para cabello graso', 4.5),
(15, 14, 15, 'Valeria Cruz', 'Confirmado', '2024-06-22', '09:30:00', '2024-06-18 15:20:00', 'Balayage en cabello largo y oscuro', NULL),
(16, 18, 16, 'Adrián Soto', 'Pendiente', '2024-06-23', '12:00:00', '2024-06-18 17:30:00', 'Botox capilar para cabello dañado', NULL),
(17, 19, 17, 'Florencia Mendez', 'Confirmado', '2024-06-24', '10:00:00', '2024-06-19 14:15:00', 'Keratina brasilera, cabello rizado', NULL),
(18, 20, 18, 'Tomás Aguilar', 'Completado', '2024-06-18', '14:00:00', '2024-06-16 12:30:00', 'Corte bob asimétrico moderno', 4.8),
(19, 15, 15, 'Valeria Cruz', 'Cancelado', '2024-06-19', '11:00:00', '2024-06-17 09:45:00', 'Cliente reprogramó por trabajo', NULL),
(20, 12, 3, 'Ana López', 'Completado', '2024-06-20', '15:30:00', '2024-06-18 16:00:00', 'Rulos suaves para evento nocturno', 4.4),
(1, 6, 8, 'Joaquín Morales', 'Confirmado', '2024-06-25', '09:00:00', '2024-06-20 11:30:00', 'Cliente frecuente, retoque mensual', NULL),
(9, 1, 1, 'María González', 'Pendiente', '2024-06-26', '16:00:00', '2024-06-21 14:45:00', 'Mantenimiento de corte anterior', NULL),
(11, 4, 7, 'Valentina Torres', 'Confirmado', '2024-06-27', '13:30:00', '2024-06-22 10:15:00', 'Planchado para cena importante', NULL),
(15, 7, 5, 'Sofía Fernández', 'Completado', '2024-06-21', '18:00:00', '2024-06-19 15:20:00', 'Arreglo de barba para novio', 4.7);

INSERT INTO Estadisticas (IdEstadistica, IdEmpleado, TurnosAtendidos, IngresosGenerados, PromedioCalificacion, PromedioTurnosMes) VALUES
(1, 1, 85, 212500.00, 4.7, 28),
(2, 2, 62, 217000.00, 4.8, 20),
(3, 3, 78, 140400.00, 4.5, 26),
(4, 4, 35, 297500.00, 4.9, 12),
(5, 5, 45, 67500.00, 4.6, 15),
(6, 6, 92, 202400.00, 4.8, 31),
(7, 7, 58, 162400.00, 4.4, 19),
(8, 8, 41, 213200.00, 4.7, 14),
(9, 9, 73, 219000.00, 4.6, 24),
(10, 10, 89, 178000.00, 4.5, 30),
(11, 11, 42, 273000.00, 4.9, 14),
(12, 12, 67, 120600.00, 4.8, 22),
(13, 13, 29, 348000.00, 4.9, 10),
(14, 14, 54, 243000.00, 4.4, 18),
(15, 15, 38, 570000.00, 4.8, 13),
(16, 16, 31, 248000.00, 4.6, 10),
(17, 17, 25, 312500.00, 4.7, 8),
(18, 18, 49, 156800.00, 4.5, 16);

INSERT INTO HorariosEmpleado (IdEmpleado, DiaSemana, HoraInicio, HoraFin, Activo) VALUES
(1, 1, '09:00:00', '18:00:00', 1), (1, 2, '09:00:00', '18:00:00', 1), (1, 3, '09:00:00', '18:00:00', 1),
(1, 4, '09:00:00', '18:00:00', 1), (1, 5, '09:00:00', '18:00:00', 1);

INSERT INTO HorariosEmpleado (IdEmpleado, DiaSemana, HoraInicio, HoraFin, Activo) VALUES
(2, 2, '10:00:00', '19:00:00', 1), (2, 3, '10:00:00', '19:00:00', 1), (2, 4, '10:00:00', '19:00:00', 1),
(2, 5, '10:00:00', '19:00:00', 1), (2, 6, '09:00:00', '17:00:00', 1);

INSERT INTO HorariosEmpleado (IdEmpleado, DiaSemana, HoraInicio, HoraFin, Activo) VALUES
(3, 1, '09:00:00', '17:00:00', 1), (3, 2, '09:00:00', '17:00:00', 1), (3, 3, '09:00:00', '17:00:00', 1),
(3, 4, '09:00:00', '17:00:00', 1), (3, 5, '09:00:00', '17:00:00', 1), (3, 6, '10:00:00', '16:00:00', 1);

INSERT INTO HorariosEmpleado (IdEmpleado, DiaSemana, HoraInicio, HoraFin, Activo) VALUES
(4, 3, '09:00:00', '20:00:00', 1), (4, 4, '09:00:00', '20:00:00', 1), (4, 5, '09:00:00', '20:00:00', 1),
(4, 6, '08:00:00', '18:00:00', 1), (4, 7, '10:00:00', '16:00:00', 1);

INSERT INTO HorariosEmpleado (IdEmpleado, DiaSemana, HoraInicio, HoraFin, Activo) VALUES
(5, 1, '14:00:00', '20:00:00', 1), (5, 3, '14:00:00', '20:00:00', 1),
(5, 5, '14:00:00', '20:00:00', 1), (5, 6, '09:00:00', '15:00:00', 1);

INSERT INTO HorariosEmpleado (IdEmpleado, DiaSemana, HoraInicio, HoraFin, Activo) VALUES
(6, 1, '09:00:00', '19:00:00', 1), (6, 2, '09:00:00', '19:00:00', 1), (6, 3, '09:00:00', '19:00:00', 1),
(6, 4, '09:00:00', '19:00:00', 1), (6, 5, '09:00:00', '19:00:00', 1), (6, 6, '08:00:00', '18:00:00', 1),
(6, 7, '10:00:00', '16:00:00', 1);

INSERT INTO HorariosEmpleado (IdEmpleado, DiaSemana, HoraInicio, HoraFin, Activo) VALUES
(7, 2, '11:00:00', '19:00:00', 1), (7, 3, '11:00:00', '19:00:00', 1), (7, 4, '11:00:00', '19:00:00', 1),
(7, 5, '11:00:00', '19:00:00', 1), (7, 6, '09:00:00', '17:00:00', 1);

INSERT INTO HorariosEmpleado (IdEmpleado, DiaSemana, HoraInicio, HoraFin, Activo) VALUES
(8, 1, '13:00:00', '20:00:00', 1), (8, 2, '13:00:00', '20:00:00', 1), (8, 3, '13:00:00', '20:00:00', 1),
(8, 4, '13:00:00', '20:00:00', 1), (8, 5, '13:00:00', '20:00:00', 1);

INSERT INTO HorariosEmpleado (IdEmpleado, DiaSemana, HoraInicio, HoraFin, Activo) VALUES
(9, 1, '08:00:00', '16:00:00', 1), (9, 2, '08:00:00', '16:00:00', 1), (9, 3, '08:00:00', '16:00:00', 1),
(9, 4, '08:00:00', '16:00:00', 1), (9, 5, '08:00:00', '16:00:00', 1), (9, 6, '09:00:00', '15:00:00', 1);

INSERT INTO HorariosEmpleado (IdEmpleado, DiaSemana, HoraInicio, HoraFin, Activo) VALUES
(10, 2, '10:00:00', '18:00:00', 1), (10, 3, '10:00:00', '18:00:00', 1), (10, 4, '10:00:00', '18:00:00', 1),
(10, 5, '10:00:00', '18:00:00', 1), (10, 6, '08:00:00', '16:00:00', 1);

INSERT INTO HorariosEmpleado (IdEmpleado, DiaSemana, HoraInicio, HoraFin, Activo) VALUES
(11, 3, '07:00:00', '15:00:00', 1), (11, 4, '07:00:00', '15:00:00', 1), (11, 5, '07:00:00', '15:00:00', 1),
(11, 6, '06:00:00', '14:00:00', 1), (11, 7, '08:00:00', '16:00:00', 1);

INSERT INTO HorariosEmpleado (IdEmpleado, DiaSemana, HoraInicio, HoraFin, Activo) VALUES
(12, 1, '12:00:00', '20:00:00', 1), (12, 2, '12:00:00', '20:00:00', 1), (12, 3, '12:00:00', '20:00:00', 1),
(12, 4, '12:00:00', '20:00:00', 1), (12, 6, '10:00:00', '18:00:00', 1);

INSERT INTO HorariosEmpleado (IdEmpleado, DiaSemana, HoraInicio, HoraFin, Activo) VALUES
(13, 2, '09:00:00', '18:00:00', 1), (13, 3, '09:00:00', '18:00:00', 1), (13, 4, '09:00:00', '18:00:00', 1),
(13, 5, '09:00:00', '18:00:00', 1), (13, 6, '08:00:00', '16:00:00', 1);

INSERT INTO HorariosEmpleado (IdEmpleado, DiaSemana, HoraInicio, HoraFin, Activo) VALUES
(14, 1, '11:00:00', '19:00:00', 1), (14, 2, '11:00:00', '19:00:00', 1), (14, 3, '11:00:00', '19:00:00', 1),
(14, 4, '11:00:00', '19:00:00', 1), (14, 5, '11:00:00', '19:00:00', 1);

INSERT INTO HorariosEmpleado (IdEmpleado, DiaSemana, HoraInicio, HoraFin, Activo) VALUES
(15, 3, '08:00:00', '17:00:00', 1), (15, 4, '08:00:00', '17:00:00', 1), (15, 5, '08:00:00', '17:00:00', 1),
(15, 6, '07:00:00', '15:00:00', 1), (15, 7, '09:00:00', '17:00:00', 1);

INSERT INTO HorariosEmpleado (IdEmpleado, DiaSemana, HoraInicio, HoraFin, Activo) VALUES
(16, 1, '14:00:00', '21:00:00', 1), (16, 2, '14:00:00', '21:00:00', 1), (16, 3, '14:00:00', '21:00:00', 1),
(16, 4, '14:00:00', '21:00:00', 1), (16, 6, '12:00:00', '20:00:00', 1);

INSERT INTO HorariosEmpleado (IdEmpleado, DiaSemana, HoraInicio, HoraFin, Activo) VALUES
(17, 2, '08:00:00', '16:00:00', 1), (17, 3, '08:00:00', '16:00:00', 1), (17, 4, '08:00:00', '16:00:00', 1),
(17, 5, '08:00:00', '16:00:00', 1), (17, 6, '09:00:00', '17:00:00', 1);

INSERT INTO HorariosEmpleado (IdEmpleado, DiaSemana, HoraInicio, HoraFin, Activo) VALUES
(18, 1, '10:00:00', '18:00:00', 1), (18, 2, '10:00:00', '18:00:00', 1), (18, 3, '10:00:00', '18:00:00', 1),
(18, 4, '10:00:00', '18:00:00', 1), (18, 5, '10:00:00', '18:00:00', 1), (18, 6, '09:00:00', '17:00:00', 1);

INSERT INTO NotificacionesTurno (IdTurno, TipoNotificacion, FechaEnvio, Estado) VALUES
(1, 'Confirmacion', '2024-06-08 15:00:00', 'Enviado'),
(1, 'Recordatorio', '2024-06-09 18:00:00', 'Enviado'),
(2, 'Confirmacion', '2024-06-10 10:00:00', 'Enviado'),
(3, 'Confirmacion', '2024-06-09 17:00:00', 'Enviado'),
(3, 'Recordatorio', '2024-06-10 20:00:00', 'Enviado'),
(4, 'Confirmacion', '2024-06-14 11:00:00', 'Enviado'),
(5, 'Confirmacion', '2024-06-15 13:00:00', 'Enviado'),
(6, 'Confirmacion', '2024-06-15 18:30:00', 'Pendiente'),
(7, 'Confirmacion', '2024-06-15 20:30:00', 'Error'),
(8, 'Cancelacion', '2024-06-12 09:30:00', 'Enviado'),
(9, 'Confirmacion', '2024-06-12 17:00:00', 'Enviado'),
(9, 'Recordatorio', '2024-06-13 20:00:00', 'Enviado'),
(10, 'Confirmacion', '2024-06-13 14:30:00', 'Enviado'),
(11, 'Confirmacion', '2024-06-16 19:45:00', 'Enviado'),
(12, 'Confirmacion', '2024-06-14 11:30:00', 'Enviado'),
(12, 'Recordatorio', '2024-06-15 18:00:00', 'Enviado'),
(13, 'Confirmacion', '2024-06-17 10:15:00', 'Pendiente'),
(14, 'Confirmacion', '2024-06-15 14:00:00', 'Enviado'),
(14, 'Recordatorio', '2024-06-16 20:00:00', 'Enviado'),
(15, 'Confirmacion', '2024-06-18 15:35:00', 'Enviado'),
(16, 'Confirmacion', '2024-06-18 17:45:00', 'Error'),
(17, 'Confirmacion', '2024-06-19 14:30:00', 'Enviado'),
(18, 'Confirmacion', '2024-06-16 12:45:00', 'Enviado'),
(18, 'Recordatorio', '2024-06-17 19:00:00', 'Enviado'),
(19, 'Cancelacion', '2024-06-18 08:30:00', 'Enviado'),
(20, 'Confirmacion', '2024-06-18 16:15:00', 'Enviado'),
(20, 'Recordatorio', '2024-06-19 18:30:00', 'Enviado'),
(21, 'Confirmacion', '2024-06-20 11:45:00', 'Enviado'),
(22, 'Confirmacion', '2024-06-21 15:00:00', 'Pendiente'),
(23, 'Confirmacion', '2024-06-22 10:30:00', 'Enviado'),
(24, 'Confirmacion', '2024-06-19 15:35:00', 'Enviado'),
(24, 'Recordatorio', '2024-06-20 20:00:00', 'Enviado');