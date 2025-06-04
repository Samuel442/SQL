-- Cria��o do projeto
CREATE DATABASE DB_Eexercicios;

USE DB_Eexercicios;

-- Cria��o da tabela
CREATE TABLE Netflix (
    ID INTEGER PRIMARY KEY,
    Titulo VARCHAR(255),
    Tipo VARCHAR(50),
    Genero VARCHAR(100),
    Classificacao VARCHAR(10),
    Duracao VARCHAR(50),
    Ano_Lancamento INT,
    Pais VARCHAR(100)
);

-- Inser��o de dados fict�cios
INSERT INTO Netflix (ID, Titulo, Tipo, Genero, Classificacao, Duracao, Ano_Lancamento, Pais) VALUES
(1, 'O Resgate', 'Filme', 'A��o', '16', '1h 57min', 2020, 'Estados Unidos'),
(2, 'Stranger Things', 'S�rie', 'Fic��o Cient�fica', '14', '4 temporadas', 2016, 'Estados Unidos'),
(3, 'The Witcher', 'S�rie', 'Fantasia', '18', '3 temporadas', 2019, 'Pol�nia'),
(4, 'Bird Box', 'Filme', 'Suspense', '16', '2h 4min', 2018, 'Estados Unidos'),
(5, 'Lupin', 'S�rie', 'Crime', '14', '2 temporadas', 2021, 'Fran�a'),
(6, 'Enola Holmes', 'Filme', 'Aventura', '12', '2h 3min', 2020, 'Reino Unido'),
(7, 'Round 6', 'S�rie', 'Drama', '18', '1 temporada', 2021, 'Coreia do Sul'),
(8, 'Casamento �s Cegas', 'Reality Show', 'Romance', '12', '4 temporadas', 2020, 'Estados Unidos'),
(9, 'Narcos', 'S�rie', 'Crime', '18', '3 temporadas', 2015, 'Col�mbia'),
(10, 'N�o Olhe para Cima', 'Filme', 'Com�dia', '16', '2h 18min', 2021, 'Estados Unidos');

-- Selecionando os registros de toda a tabela (todas as colunas)
SELECT *
FROM Netflix

-- Seleciona list colunas espec�ficas
SELECT
	Titulo
	,Genero
FROM Netflix

-- Select trzendo colunas na frente
SELECT
	Classificacao
	, *
FROM Netflix

-- Renomeando colunas
SELECT 
	Tipo		AS [OPCAO ESCOLHA]
	, Genero    AS 'TIPO GENERO'
FROM Netflix

SELECT *
FROM NETFLIX 
WHERE 'OPCAO ESCOLHA' = 'Filme'

-- AND
SELECT *
FROM NETFLIX
WHERE Genero = 'A��o'
AND Tipo = 'Filme'

-- BETWEEN
SELECT *
FROM NETFLIX
WHERE ID
BETWEEN '3' AND '10'

-- IN
SELECT * 
FROM Netflix
WHERE Genero IN('Fantasia', 'Crime')



SELECT 
	Titulo
	, Tipo
	, Genero
FROM Netflix

-- Usada para contar valores
SELECT 
	COUNT(Classificacao) -- Conta linhas
FROM Netflix

SELECT 
	SUM(Ano_Lancamento)
FROM Netflix

-- Fun�ao replace para substituir valores de uma coluna
SELECT 
	Titulo
	, REPLACE(Genero, 'A��o', 'Atitude') AS Classificacao
	, Tipo
FROM Netflix

-- CONCATENA��O
SELECT CONCAT('SQL', 'MODULO', '1');

SELECT CONCAT(Classificacao, ' - ', Tipo) AS Nova_Coluna
	, Tipo
FROM Netflix

