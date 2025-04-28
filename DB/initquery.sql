CREATE TABLE Mediciones (
    Id INT PRIMARY KEY IDENTITY(1,1),
    DeviceId VARCHAR(50),
    Temperatura FLOAT,
    Humedad FLOAT,
    Ubicacion VARCHAR(100),
    FechaHora DATETIME DEFAULT GETDATE()
);


select * from mediciones