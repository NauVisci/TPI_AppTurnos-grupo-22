-- Ejemplos DB Gestión de Turnos - Ejecutar por partes.

USE GestionTurnos
GO

-- 1. SERVICIOS
INSERT INTO Servicios (IdServicio, Nombre, Duracion, Precio, Categoria) VALUES
(1, 'Corte Clásico', 45.00, 2500.00, 'Cortes'),
(2, 'Corte y Peinado Premium', 60.00, 3500.00, 'Cortes'),
(3, 'Planchado Express', 30.00, 1800.00, 'Peinados'),
(4, 'Planchado y Brushing', 50.00, 2800.00, 'Peinados'),
(5, 'Tintura Completa', 120.00, 8500.00, 'Coloración'),
(6, 'Retoque de Raíces', 75.00, 5200.00, 'Coloración'),
(7, 'Arreglo de Barba', 25.00, 1500.00, 'Barbería'),
(8, 'Barba Completa + Bigote', 40.00, 2200.00, 'Barbería');

-- 2. GESTIÓN DE ROLES
INSERT INTO GestionDeRoles (IdRol, NombreRol) VALUES
(1, 'Admin'),
(2, 'Empleado'),
(3, 'Cliente');

-- 3. EMPLEADOS (con diferentes especialidades)
INSERT INTO Empleados (IdEmpleado, Nombre, Apellido, IdServicio, FechaAltaEmpleado, IdRol) VALUES
(1, 'María', 'González', 1, '2023-01-15', 2),    -- Especialista en cortes clásicos
(2, 'Carlos', 'Rodríguez', 2, '2023-03-10', 2),  -- Especialista en cortes premium
(3, 'Ana', 'López', 3, '2023-02-20', 2),         -- Especialista en planchado
(4, 'Diego', 'Martínez', 5, '2022-11-05', 2),    -- Colorista experto
(5, 'Sofía', 'Fernández', 7, '2023-06-12', 2),   -- Barbera especializada
(6, 'Roberto', 'Silva', 8, '2022-08-18', 2),     -- Barbero senior
(7, 'Valentina', 'Torres', 4, '2023-04-25', 2),  -- Especialista en peinados
(8, 'Joaquín', 'Morales', 6, '2023-05-30', 2);   -- Especialista en retoques

-- 4. CLIENTES (perfil variado)
INSERT INTO Clientes (IdCliente, Nombre, Apellido, Email, Domicilio, Telefono, FechaCreacion, DNI, IdRol) VALUES
(1, 'Laura', 'Pérez', 'laura.perez@email.com', 'Av. Libertador 1250', '11-2345-6789', '2023-08-15', '35678912', 3),
(2, 'Miguel', 'Ramírez', 'miguel.ramirez@email.com', 'San Martín 890', '11-3456-7890', '2023-07-22', '28456789', 3),
(3, 'Carla', 'Jiménez', 'carla.jimenez@email.com', 'Rivadavia 2340', '11-4567-8901', '2023-09-10', '42123456', 3),
(4, 'Fernando', 'Castro', 'fernando.castro@email.com', 'Belgrano 567', '11-5678-9012', '2023-06-05', '31789654', 3),
(5, 'Natalia', 'Vega', 'natalia.vega@email.com', 'Corrientes 1789', '11-6789-0123', '2023-10-18', '39876543', 3),
(6, 'Pablo', 'Herrera', 'pablo.herrera@email.com', 'Florida 445', '11-7890-1234', '2023-05-12', '27654321', 3),
(7, 'Gabriela', 'Ruiz', 'gabriela.ruiz@email.com', 'Maipú 1123', '11-8901-2345', '2023-11-02', '44567890', 3),
(8, 'Andrés', 'Mendoza', 'andres.mendoza@email.com', 'Tucumán 778', '11-9012-3456', '2023-09-28', '33445566', 3);

-- 5. TURNOS (variedad de estados y fechas)
INSERT INTO Turnos (IdCliente, IdServicio, IdEmpleado, ProfesionalElegido, Estado, FechaTurno, HoraTurno, FechaCreacion, Observaciones, Valoracion) VALUES
-- Turnos completados con valoraciones
(1, 1, 1, 'María González', 'Completado', '2024-06-10', '10:00:00', '2024-06-08 14:30:00', 'Cliente habitual, prefiere corte tradicional', 4.8),
(2, 8, 6, 'Roberto Silva', 'Completado', '2024-06-12', '15:30:00', '2024-06-10 09:15:00', 'Primera vez, muy conforme con el resultado', 5.0),
(3, 5, 4, 'Diego Martínez', 'Completado', '2024-06-11', '11:00:00', '2024-06-09 16:20:00', 'Cambio de look completo, rubio ceniza', 4.9),

-- Turnos confirmados (próximos)
(4, 2, 2, 'Carlos Rodríguez', 'Confirmado', '2024-06-16', '09:00:00', '2024-06-14 10:45:00', 'Evento especial, requiere peinado elegante', NULL),
(5, 3, 3, 'Ana López', 'Confirmado', '2024-06-17', '14:00:00', '2024-06-15 12:30:00', 'Casamiento familiar, planchado perfecto', NULL),

-- Turnos pendientes de confirmación
(6, 7, 5, 'Sofía Fernández', 'Pendiente', '2024-06-18', '16:00:00', '2024-06-15 18:00:00', 'Primera vez con barbera mujer', NULL),
(7, 6, 8, 'Joaquín Morales', 'Pendiente', '2024-06-19', '10:30:00', '2024-06-15 20:15:00', 'Retoque urgente antes de entrevista laboral', NULL),

-- Turno cancelado
(8, 4, 7, 'Valentina Torres', 'Cancelado', '2024-06-13', '13:00:00', '2024-06-11 11:00:00', 'Cliente canceló por enfermedad', NULL);

-- 6. ESTADÍSTICAS (basadas en rendimiento)
INSERT INTO Estadisticas (IdEstadistica, IdEmpleado, TurnosAtendidos, IngresosGenerados, PromedioCalificacion, PromedioTurnosMes) VALUES
(1, 1, 85, 212500.00, 4.7, 28),  -- María: Alta demanda en cortes clásicos
(2, 2, 62, 217000.00, 4.8, 20),  -- Carlos: Menos turnos pero mayor precio
(3, 3, 78, 140400.00, 4.5, 26),  -- Ana: Volumen alto en planchados
(4, 4, 35, 297500.00, 4.9, 12),  -- Diego: Pocos turnos pero muy rentables (tinturas)
(5, 5, 45, 67500.00, 4.6, 15),   -- Sofía: Creciendo en barbería femenina
(6, 6, 92, 202400.00, 4.8, 31),  -- Roberto: Veterano con alta productividad
(7, 7, 58, 162400.00, 4.4, 19),  -- Valentina: Especialista en eventos
(8, 8, 41, 213200.00, 4.7, 14);  -- Joaquín: Especialista en retoques premium

-- 7. HORARIOS DE EMPLEADOS (patrones realistas)
-- María González (Lunes a Viernes)
INSERT INTO HorariosEmpleado (IdEmpleado, DiaSemana, HoraInicio, HoraFin, Activo) VALUES
(1, 1, '09:00:00', '18:00:00', 1), (1, 2, '09:00:00', '18:00:00', 1), (1, 3, '09:00:00', '18:00:00', 1),
(1, 4, '09:00:00', '18:00:00', 1), (1, 5, '09:00:00', '18:00:00', 1);

-- Carlos Rodríguez (Martes a Sábado)
INSERT INTO HorariosEmpleado (IdEmpleado, DiaSemana, HoraInicio, HoraFin, Activo) VALUES
(2, 2, '10:00:00', '19:00:00', 1), (2, 3, '10:00:00', '19:00:00', 1), (2, 4, '10:00:00', '19:00:00', 1),
(2, 5, '10:00:00', '19:00:00', 1), (2, 6, '09:00:00', '17:00:00', 1);

-- Ana López (Lunes a Sábado)
INSERT INTO HorariosEmpleado (IdEmpleado, DiaSemana, HoraInicio, HoraFin, Activo) VALUES
(3, 1, '09:00:00', '17:00:00', 1), (3, 2, '09:00:00', '17:00:00', 1), (3, 3, '09:00:00', '17:00:00', 1),
(3, 4, '09:00:00', '17:00:00', 1), (3, 5, '09:00:00', '17:00:00', 1), (3, 6, '10:00:00', '16:00:00', 1);

-- Diego Martínez (Miércoles a Domingo - horario especial colorista)
INSERT INTO HorariosEmpleado (IdEmpleado, DiaSemana, HoraInicio, HoraFin, Activo) VALUES
(4, 3, '09:00:00', '20:00:00', 1), (4, 4, '09:00:00', '20:00:00', 1), (4, 5, '09:00:00', '20:00:00', 1),
(4, 6, '08:00:00', '18:00:00', 1), (4, 7, '10:00:00', '16:00:00', 1);

-- Sofía Fernández (Lunes, Miércoles, Viernes, Sábado)
INSERT INTO HorariosEmpleado (IdEmpleado, DiaSemana, HoraInicio, HoraFin, Activo) VALUES
(5, 1, '14:00:00', '20:00:00', 1), (5, 3, '14:00:00', '20:00:00', 1),
(5, 5, '14:00:00', '20:00:00', 1), (5, 6, '09:00:00', '15:00:00', 1);

-- Roberto Silva (Todos los días)
INSERT INTO HorariosEmpleado (IdEmpleado, DiaSemana, HoraInicio, HoraFin, Activo) VALUES
(6, 1, '09:00:00', '19:00:00', 1), (6, 2, '09:00:00', '19:00:00', 1), (6, 3, '09:00:00', '19:00:00', 1),
(6, 4, '09:00:00', '19:00:00', 1), (6, 5, '09:00:00', '19:00:00', 1), (6, 6, '08:00:00', '18:00:00', 1),
(6, 7, '10:00:00', '16:00:00', 1);

-- Valentina Torres (Martes a Sábado)
INSERT INTO HorariosEmpleado (IdEmpleado, DiaSemana, HoraInicio, HoraFin, Activo) VALUES
(7, 2, '11:00:00', '19:00:00', 1), (7, 3, '11:00:00', '19:00:00', 1), (7, 4, '11:00:00', '19:00:00', 1),
(7, 5, '11:00:00', '19:00:00', 1), (7, 6, '09:00:00', '17:00:00', 1);

-- Joaquín Morales (Lunes a Viernes)
INSERT INTO HorariosEmpleado (IdEmpleado, DiaSemana, HoraInicio, HoraFin, Activo) VALUES
(8, 1, '13:00:00', '20:00:00', 1), (8, 2, '13:00:00', '20:00:00', 1), (8, 3, '13:00:00', '20:00:00', 1),
(8, 4, '13:00:00', '20:00:00', 1), (8, 5, '13:00:00', '20:00:00', 1);

-- 8. NOTIFICACIONES DE TURNO
INSERT INTO NotificacionesTurno (IdTurno, TipoNotificacion, FechaEnvio, Estado) VALUES
-- Notificaciones para turnos completados
(1, 'Confirmacion', '2024-06-08 15:00:00', 'Enviado'),
(1, 'Recordatorio', '2024-06-09 18:00:00', 'Enviado'),
(2, 'Confirmacion', '2024-06-10 10:00:00', 'Enviado'),
(3, 'Confirmacion', '2024-06-09 17:00:00', 'Enviado'),
(3, 'Recordatorio', '2024-06-10 20:00:00', 'Enviado'),

-- Notificaciones para turnos confirmados
(4, 'Confirmacion', '2024-06-14 11:00:00', 'Enviado'),
(5, 'Confirmacion', '2024-06-15 13:00:00', 'Enviado'),

-- Notificaciones pendientes
(6, 'Confirmacion', '2024-06-15 18:30:00', 'Pendiente'),
(7, 'Confirmacion', '2024-06-15 20:30:00', 'Error'),

-- Notificación de cancelación
(8, 'Cancelacion', '2024-06-12 09:30:00', 'Enviado');

-- VERIFICACIÓN DE DATOS INSERTADOS
PRINT 'Datos de ejemplo insertados correctamente:'
PRINT '- ' + CAST((SELECT COUNT(*) FROM Servicios) AS VARCHAR) + ' servicios'
PRINT '- ' + CAST((SELECT COUNT(*) FROM GestionDeRoles) AS VARCHAR) + ' roles'
PRINT '- ' + CAST((SELECT COUNT(*) FROM Empleados) AS VARCHAR) + ' empleados'
PRINT '- ' + CAST((SELECT COUNT(*) FROM Clientes) AS VARCHAR) + ' clientes'
PRINT '- ' + CAST((SELECT COUNT(*) FROM Turnos) AS VARCHAR) + ' turnos'
PRINT '- ' + CAST((SELECT COUNT(*) FROM Estadisticas) AS VARCHAR) + ' registros de estadísticas'
PRINT '- ' + CAST((SELECT COUNT(*) FROM HorariosEmpleado) AS VARCHAR) + ' horarios configurados'
PRINT '- ' + CAST((SELECT COUNT(*) FROM NotificacionesTurno) AS VARCHAR) + ' notificaciones'