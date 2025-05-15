USE DB_ecommerce;

SELECT * FROM tb_cliente;

-- Quantidade de pessoas cadastradas
SELECT COUNT(DISTINCT CPF) FROM tb_cliente;

-- Maior e menor valor

SELECT max(valor_produto)
		min (qtd_estoque)
FROM tb_produto

-- Valor total que tenho

SELECT SUM(valor_produto)
FROM tb_produto

-- Quantidade de produtos, total vendidos

SELECT prd.DESC_PRODUTO
		, sum(int.VALOR_ITEM) AS VALOR_TOTAL
		, SUM(int.QTD_ITEM) AS QTD_TOTAL
FROM tb_pedido ped
INNER JOIN tb_item_pedido itn ON ped id_pedido = itn.id_pedido
INNER JOIN tb_produto prd ON itn.id_produto = prd id_produto
GROUP BY prd.DESC_PRODUTO
ORDER BY prd.DESC_PRODUTO;