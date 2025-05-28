CREATE DATABASE GestionTurnos
GO

USE GestionTurnos
GO

CREATE TABLE Servicios (
    IdServicio INT PRIMARY KEY,
    Nombre NVARCHAR(255),
    Duracion DECIMAL(10, 2),
    Precio DECIMAL(10, 2)
	);

CREATE TABLE GestionDeRoles (
    IdRol INT PRIMARY KEY,
    NombreRol NVARCHAR(255)
	);

CREATE TABLE Clientes (
    IdCliente INT PRIMARY KEY,
    Domicilio NVARCHAR(255),
    Telefono NVARCHAR(50),
    FechaCreacion DATE,
    DNI NVARCHAR(50),
	IdRol INT,

	FOREIGN KEY (IdRol) REFERENCES GestionDeRoles(IdRol)
	);

CREATE TABLE Empleados (
    IdEmpleado INT PRIMARY KEY,
    Nombre NVARCHAR(255),
    Especialidad NVARCHAR(255),
    AltaEmpleado DATE,
	IdRol INT,

	FOREIGN KEY (IdRol) REFERENCES GestionDeRoles(IdRol)
	);

CREATE TABLE Turnos (
    IdTurno INT PRIMARY KEY,
	IdCliente INT,
	IdServicio INT,
	IdEmpleado INT,
    ProfesionalElegido NVARCHAR(255),
    Estado NVARCHAR(50),
    Fecha DATETIME,
    Valoracion DECIMAL(3, 2)

    FOREIGN KEY (IdCliente)  REFERENCES Clientes(IdCliente),
    FOREIGN KEY (IdServicio) REFERENCES Servicios(IdServicio),
	FOREIGN KEY (IdEmpleado) REFERENCES Empleados(IdEmpleado)
	);

CREATE TABLE Estadisticas (
    IdEstadistica INT PRIMARY KEY,
	IdEmpleado INT,
    TurnosAtendidos INT,
    IngresosGenerados DECIMAL(10,2),
	PromedioCalificacion DECIMAL(3, 2),
	PromedioTurnosMes DECIMAL(3, 2)

	FOREIGN KEY (IdEmpleado) REFERENCES Empleados(IdEmpleado),
	);

