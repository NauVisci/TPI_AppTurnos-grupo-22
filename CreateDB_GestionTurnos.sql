CREATE DATABASE GestionTurnos
GO

USE GestionTurnos
GO

CREATE TABLE Servicios (
    IdServicio INT PRIMARY KEY,
    Nombre NVARCHAR(255),
    Duracion DECIMAL(10, 2),
    Precio DECIMAL(10, 2),
    Categoria NVARCHAR(100)
);

CREATE TABLE GestionDeRoles (
    IdRol INT PRIMARY KEY,
    NombreRol NVARCHAR(255)
);

CREATE TABLE Clientes (
    IdCliente INT PRIMARY KEY,
	Nombre NVARCHAR(50),
	Apellido NVARCHAR(50),
	Email NVARCHAR(100),
    Domicilio NVARCHAR(255),
    Telefono NVARCHAR(50),
    FechaCreacion DATE,
    DNI NVARCHAR(50),
	IdRol INT,

	FOREIGN KEY (IdRol) REFERENCES GestionDeRoles(IdRol)
);

CREATE TABLE Empleados (
    IdEmpleado INT PRIMARY KEY,
    Nombre NVARCHAR(50),
	Apellido NVARCHAR(50),
    IdServicio INT,
    FechaAltaEmpleado DATE,
	IdRol INT,

	FOREIGN KEY (IdRol) REFERENCES GestionDeRoles(IdRol),
	FOREIGN KEY (IdServicio) REFERENCES Servicios(IdServicio)
);

CREATE TABLE Turnos (
    IdTurno INT PRIMARY KEY IDENTITY(1,1),
	IdCliente INT,
	IdServicio INT,
	IdEmpleado INT,
    ProfesionalElegido NVARCHAR(255),
    Estado NVARCHAR(50),
    FechaTurno DATE,
    HoraTurno TIME,
    FechaCreacion DATETIME DEFAULT GETDATE(),
    Observaciones NVARCHAR(500),
    Valoracion DECIMAL(4, 2)

    FOREIGN KEY (IdCliente)  REFERENCES Clientes(IdCliente),
    FOREIGN KEY (IdServicio) REFERENCES Servicios(IdServicio),
	FOREIGN KEY (IdEmpleado) REFERENCES Empleados(IdEmpleado)
);

CREATE TABLE Estadisticas (
    IdEstadistica INT PRIMARY KEY,
	IdEmpleado INT,
    TurnosAtendidos INT,
    IngresosGenerados DECIMAL(10,2),
	PromedioCalificacion DECIMAL(4, 2),
	PromedioTurnosMes INT, -- TIENE QUE SER INT EL TIPO DE DATO, ANTERIOR DECIMAL

	FOREIGN KEY (IdEmpleado) REFERENCES Empleados(IdEmpleado),
);

CREATE TABLE HorariosEmpleado (
    IdHorario INT PRIMARY KEY IDENTITY(1,1),
    IdEmpleado INT,
    DiaSemana INT, -- 1 Lunes, 6 Sábado
    HoraInicio TIME,
    HoraFin TIME,
    Activo BIT DEFAULT 1,
    FOREIGN KEY (IdEmpleado) REFERENCES Empleados(IdEmpleado)
);

CREATE TABLE NotificacionesTurno (
    IdNotificacion INT PRIMARY KEY IDENTITY(1,1),
    IdTurno INT,
    TipoNotificacion NVARCHAR(50), -- "Confirmacion", "Recordatorio", "Cancelacion"
    FechaEnvio DATETIME,
    Estado NVARCHAR(20), -- "Enviado", "Error", "Pendiente"
    FOREIGN KEY (IdTurno) REFERENCES Turnos(IdTurno)
);