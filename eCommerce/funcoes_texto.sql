USE DB_ecommerce

-- Fun��es de texto

-- Quantidade de caracteres
SELECT LEN(ENDERECO)
	, ENDERECO
FROM tb_cliente;

-- Nome mai�sculo e min�sculo
SELECT nome
	, UPPER(nome)
	, LOWER(nome)
FROM tb_cliente;

SELECT UPPER('Fulano');

-- Nome mai�sculo e min�sculo

SELECT nome
	, LEFT(nome,6)
	, RIGHT(nome,6)
FROM tb_cliente;

SELECT nome
	, LEFT('Fulano Vieira',6)
	, LEFT('Fulano Vieira', 6)
FROM tb_cliente;

-- Duas fun��es
SELECT 'Fulano Vieira'
	, UPPER(LEFT('Fulano Vieira',6))
	, UPPER(RIGHT('Fulano Vieira',6))

-- Removendo espa�os
SELECT 'Fulano Vieira'
	, LTRIM('     Fulano Vieira      ')
	, RTRIM('     Fulano Vieira      ')
	, TRIM('     Fulano Vieira      ')

-- Reovendo caracteres especiais
SELECT data_nascimento
		, REPLACE(data_nascimento,'-','')
FROM tb_cliente