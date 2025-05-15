USE DB_ecommerce
-- Uso de fun��es

-- CALCULO DE IDADE
SELECT data_nascimento
		, DATEDIFF(dd, data_nascimento, GETDATE()) / 365 AS idade
FROM tb_cliente;

SELECT GETDATE();

CREATE FUNCTION CALCULAR_IDADE(DATA_NASCIMENTO DATE)
RETURNS INT
AS
BEGIN
	DECLARE @idade INT

	SET @idade = DATEDIFF(YEAR, @DATA_NASCIMENTO, GETDATE())

	--Ajustar a idade se ainda n�o tiver completado o anivers�rio neste ano

	IF(DATEADD(YEAR, @idade, @DATA_NASCIMENTO) > GETDATE())
		SET @idade = @idade - 1

	RETURN @idade
END

-- Usando a fun��o
DECLARE @DATA_NASCIMENTO DATE = '2000-02-01'

SELECT dbo.CALCULAR_IDADE(@DATA_NASCIMENTO) AS idade;

SELECT dbo.CALCULAR_IDADE('2000-02-01') AS idade;