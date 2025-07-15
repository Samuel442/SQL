USE DB_Terremotos;

CREATE TABLE Terremotos (
  Id INT IDENTITY(1,1) PRIMARY KEY,
  Magnitude FLOAT,
  Localizacao NVARCHAR(255),
  DataHora DATETIME2,
  Longitude FLOAT,
  Latitude FLOAT
);

SELECT * 
FROM Terremotos