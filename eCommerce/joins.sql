USE DB_ecommerce

-- Usando joins

SELECT * FROM tb_cliente;

SELECT * FROM tb_cliente;

SELECT cli.cpf
	   , cli.nome
	   , em.email
FROM tb_cliente cli
INNER JOIN tb_email em ON cli.id_cliente = em.id_cliente

-- LEFT JOIN

INSERT INTO tb_cliente(cpf, nome, data_nascimento, genero, endereco, bairro, cidade, uf, cep)
VALUE(4444, 'JULIO', '20000508', 'M', 'RUA: FLORENCIO DE ABREU, 500', 'CENTRO', 'EXTREMA', 'MG', '4535510');

SELECT DISTINCT cli.cpf
	   , cli.nome
	   , em.email
FROM tb_cliente cli
LEFT JOIN tb_email em ON cli.id_cliente = em.id_cliente

SELECT cli.cpf
		cli.nome
		cli.email
FROM tb_cliente cli
LEFT JOIN tb_email em ON cli.id_cliente = em.id_cliente
WHERE em.id_cliente IS NULL;

SELECT DISTINCT cli.cpf
		, cli.nome
		, em.email
		, tel.ddd
		, tel.telefone
		, ped.num_nota_fiscal
		, ped.qtd_total
		, ped.valor_total
		, prd.desc_produto
FROM tb_cliente cli
INNER JOIN tb_email em ON cli.id_cliente = em.id_cliente
INNER JOIN tb_telefone tel ON cli.id_cliente = tel.id_cliente
INNER JOIN tb_pedido ped ON cli.id_cliente = ped.id_cliente
LEFT JOIN tb_item_pedido itm ON ped.id_pedido = itm.id_item
LEFT JOIN tb_pedido prd ON prd.id_produto = itm.id_produto
ORDER BY cpf,nome;