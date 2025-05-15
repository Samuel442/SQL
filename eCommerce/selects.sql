SELECT * FROM tb_cliente;

SELECT cpf
		, nome
		, uf
FROM tb_cliente;

SELECT DISTINCT uf FROM tb_cliente;

SELECT COUNT(*) FROM tb_cliente;

SELECT COUNT(DISTINCT cpf) FROM tb_cliente;

SELECT TOP 2 * FROM tb_cliente;

SELECT * FROM tb_cliente ORDER BY nome;

SELECT * FROM tb_cliente ORDER BY data_nascimento DESC;

SELECT * FROM tb_cliente ORDER BY NEWID();