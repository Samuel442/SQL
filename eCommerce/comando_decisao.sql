USE DB_ecommerce

-- Usando case e when para tratamento do mês
SELECT data_compra
		, DAY(data_compra) AS DIA
		, MONTH(data_compra) AS mes_numero
		, CASE WHEN MONTH(data_compra) = 1 THEN 'Janeiro'
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
	ELSE NULL END AS mes_tratado
   , YEAR(data_compra) AS ANO
FROM tb_pedido
WHERE YEAR(data_compra) = 2022

-- Caso de uso CASE e WHEN para tratamento de gênero
SELECT GEENRO
	, CASE WHEN GENERO = 'F' THEN 'Feminino'
		WHEN GENERO = 'M' THEN 'Masculino'
	ELSE 'Indefinido' END AS genero_tratado
FROM tb_cliente;

-- Usando o IF para tratamento de gênero
SELECT GENERO
		, IIF(GENERO = 'F', 'Feminino', 'Masculino')
FROM tb_cliente;
