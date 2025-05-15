SELECT * FROM tb_cliente

SELECT *
FROM tb_cliente
WHERE uf = 'SP';

SELECT *
FROM tb_cliente
WHERE uf IS NOT NULL
AND genero = 'F';

SELECT *
FROM tb_cliente
WHERE uf = 'PR';

SELECT *
FROM tb_cliente
WHERE uf = 'RJ'
OR genero = 'F';

SELECT * 
FROM tb_cliente
WHERE uf IN ('MG', 'SP');

SELECT *
FROM tb_cliente
WHERE nome LIKE 'C%';