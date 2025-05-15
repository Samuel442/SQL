USE DB_ecommerce

-- Tratamento de data

SELECT *
FROM tb_pedido
WHERE MONTH(data_compra) = 12;

-- Selecionando os pedidos que foram feitos no ano de 2022

SELECT *
FROM tb_item_pedido
WHERE YEAR(data_compra) = 2022;

-- selecionando os pedidos feitos dia 20
SELECT *
FROM tb_pedido
WHERE DAY(data_compra) = 20;

-- selecionando dia mes e ano da compra

SELECT *
	, DAY(data_compra) AS Dia
	, MONTH(data_compra) AS Mes
	, YEAR(data_compra) As Ano
FROM tb_pedido
WHERE YEAR(data_compra) = 2022

-- CALCULANDO IDADE
SELECT data_nascimento
	, GETDATE()
	, DATEDIFF(YY,data_nascimento, GETDATE()) AS idade
FROM tb_cliente

-- Formatando a data

SELECT convert (VARCHAR, GETDATE(), 100)
	, convert (VARCHAR, GETDATE(), 101)
	, convert (VARCHAR, GETDATE(), 102)
	, convert (VARCHAR, GETDATE(), 103)
	, convert (VARCHAR, GETDATE(), 104)
	, convert (VARCHAR, GETDATE(), 105)
	, convert (VARCHAR, GETDATE(), 106)
	, convert (VARCHAR, GETDATE(), 107)
	, convert (VARCHAR, GETDATE(), 108)