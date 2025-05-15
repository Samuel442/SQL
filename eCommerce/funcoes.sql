USE DB_ecommerce
-- Uso de funções

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

	--Ajustar a idade se ainda não tiver completado o aniversário neste ano

	IF(DATEADD(YEAR, @idade, @DATA_NASCIMENTO) > GETDATE())
		SET @idade = @idade - 1

	RETURN @idade
END

-- Usando a função
DECLARE @DATA_NASCIMENTO DATE = '2000-02-01'

SELECT dbo.CALCULAR_IDADE(@DATA_NASCIMENTO) AS idade;

SELECT dbo.CALCULAR_IDADE('2000-02-01') AS idade;