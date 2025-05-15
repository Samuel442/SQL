USE DB_ecommerce

-- Atualizando campo de UF

SELECT * FROM tb_cliente

UPDATE tb_cliente
SET UF = 'PR'
WHERE id_cliente = 2;

SELECT UF
FROM tb_cliente;

ALTER TABLE tb_pedido ADD DIA INT
ALTER TABLE tb_pedido ADD MES INT
ALTER TABLE tb_pedido ADD ANO INT

SELECT * FROM tb_pedido

-- Atualizando os novos campos de data criados
UPDATE tb_pedido
SET DIA =  DAY(data_compra)
	, MES = CASE WHEN MONTH(data_compra) = 1 THEN 'Janeiro'
	             WHEN MONTH(data_compra) = 2 THEN 'Fevereiro'
				 WHEN MONTH(data_compra) = 3 THEN 'Março'
				 WHEN MONTH(data_compra) = 4 THEN 'Abril'
				 WHEN MONTH(data_compra) = 5 THEN 'Maio'
				 WHEN MONTH(data_compra) = 6 THEN 'Junho'
				 WHEN MONTH(data_compra) = 7 THEN 'Julho'
				 WHEN MONTH(data_compra) = 8 THEN 'Agosto'
				 WHEN MONTH(data_compra) = 9 THEN 'Setembro'
				 WHEN MONTH(data_compra) = 10 THEN 'Outubro'
				 WHEN MONTH(data_compra) = 11 THEN 'Novembro'
				 WHEN MONTH(data_compra) = 12 THEN 'Dezembro'
		      ELSE NULL END
			, ANO = YEAR(data_compra)
		WHERE id_cliente = 2;

SELECT * FROM tb_pedido;
