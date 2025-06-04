-- Criação do projeto
CREATE DATABASE DB_Eexercicios;

USE DB_Eexercicios;

-- Criação da tabela
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

-- Inserção de dados fictícios
INSERT INTO Netflix (ID, Titulo, Tipo, Genero, Classificacao, Duracao, Ano_Lancamento, Pais) VALUES
(1, 'O Resgate', 'Filme', 'Ação', '16', '1h 57min', 2020, 'Estados Unidos'),
(2, 'Stranger Things', 'Série', 'Ficção Científica', '14', '4 temporadas', 2016, 'Estados Unidos'),
(3, 'The Witcher', 'Série', 'Fantasia', '18', '3 temporadas', 2019, 'Polônia'),
(4, 'Bird Box', 'Filme', 'Suspense', '16', '2h 4min', 2018, 'Estados Unidos'),
(5, 'Lupin', 'Série', 'Crime', '14', '2 temporadas', 2021, 'França'),
(6, 'Enola Holmes', 'Filme', 'Aventura', '12', '2h 3min', 2020, 'Reino Unido'),
(7, 'Round 6', 'Série', 'Drama', '18', '1 temporada', 2021, 'Coreia do Sul'),
(8, 'Casamento às Cegas', 'Reality Show', 'Romance', '12', '4 temporadas', 2020, 'Estados Unidos'),
(9, 'Narcos', 'Série', 'Crime', '18', '3 temporadas', 2015, 'Colômbia'),
(10, 'Não Olhe para Cima', 'Filme', 'Comédia', '16', '2h 18min', 2021, 'Estados Unidos');

-- Selecionando os registros de toda a tabela (todas as colunas)
SELECT *
FROM Netflix

-- Seleciona list colunas específicas
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
WHERE Genero = 'Ação'
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

-- Funçao replace para substituir valores de uma coluna
SELECT 
	Titulo
	, REPLACE(Genero, 'Ação', 'Atitude') AS Classificacao
	, Tipo
FROM Netflix

-- CONCATENAÇÃO
SELECT CONCAT('SQL', 'MODULO', '1');

SELECT CONCAT(Classificacao, ' - ', Tipo) AS Nova_Coluna
	, Tipo
FROM Netflix

