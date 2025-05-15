USE DB_ecommerce

-- Funções de texto

-- Quantidade de caracteres
SELECT LEN(ENDERECO)
	, ENDERECO
FROM tb_cliente;

-- Nome maiúsculo e minúsculo
SELECT nome
	, UPPER(nome)
	, LOWER(nome)
FROM tb_cliente;

SELECT UPPER('Fulano');

-- Nome maiúsculo e minúsculo

SELECT nome
	, LEFT(nome,6)
	, RIGHT(nome,6)
FROM tb_cliente;

SELECT nome
	, LEFT('Fulano Vieira',6)
	, LEFT('Fulano Vieira', 6)
FROM tb_cliente;

-- Duas funções
SELECT 'Fulano Vieira'
	, UPPER(LEFT('Fulano Vieira',6))
	, UPPER(RIGHT('Fulano Vieira',6))

-- Removendo espaços
SELECT 'Fulano Vieira'
	, LTRIM('     Fulano Vieira      ')
	, RTRIM('     Fulano Vieira      ')
	, TRIM('     Fulano Vieira      ')

-- Reovendo caracteres especiais
SELECT data_nascimento
		, REPLACE(data_nascimento,'-','')
FROM tb_cliente