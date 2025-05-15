-- HAVING: FILTRNADO OS RESULTADOS DE UM AGRUPAMENTO

SELECT colunas, funcao_agregacao()
FROM tabela
WHERE filtro
GROUP BY colunas
HAVING filtro_agrupamento

SELECT * FROM tb_cliente

SELECT *
FROM tb_cliente
WHERE id_cliente BETWEEN 1 AND 2

SELECT *
FROM tb_cliente
WHERE YEAR(data_nascimento) BETWEEN 1985 AND 1988;

SELECT nome, COUNT(*)
FROM tb_cliente
GROUP BY nome
HAVING COUNT(*) = 1