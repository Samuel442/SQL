/*Inserção de dados*/
INSERT INTO tb_cliente (cpf, nome, data_nascimento, genero, endereco, bairro, cidade, uf, cep)
VALUES (1111, 'CAMILA', '1990-02-11', 'F', 'RUA: FONTE VERDE,100', 'VILA IPIRANGA', 'MOGI DAS CRUZES', 'SP', '873510');

INSERT INTO tb_cliente (cpf, nome, data_nascimento, genero, endereco, bairro, cidade, uf, cep)
VALUES (2222, 'KIKO', '1990-02-11', 'M', 'RUA SUZANO VERDE,100', 'VILA IPIRANGA', 'MOGI DAS CRUZES', 'SP', '873510');

INSERT INTO tb_cliente (cpf, nome, data_nascimento)
VALUES (3333, 'SEU MADRUGA', '1990-02-11');

INSERT INTO tb_cliente (cpf, nome, data_nascimento, genero, endereco, bairro, cidade, uf, cep)
VALUES (1111, 'CHIQUINHA', '1990-02-11', 'F', 'RUA: FONTE VERDE,100', 'VILA IPIRANGA', 'MOGI DAS CRUZES', 'SP', '873510');

SELECT * FROM tb_cliente


/*Inserção de emails*/
INSERT INTO tb_email (id_cliente, email, score)
VALUES (1, 'CHIQUINHA@GMAIL.COM',1);

INSERT INTO tb_email (id_cliente, email, score)
VALUES (2, 'KIKO@GMAIL.COM',1);

INSERT INTO tb_email (id_cliente, email, score)
VALUES (3, 'SEU_MADRUGA@GMAIL.COM',1);

INSERT INTO tb_email (id_cliente, email, score)
VALUES (3, 'SEU_MADRUGA@GMAIL.COM',2);

SELECT * FROM tb_email

/*Inserção de telefones*/
INSERT INTO  tb_telefone (id_cliente , ddd, telefone, tipo_telefone, score)
VALUES (1, 11, 985903841,'C',1);

INSERT INTO  tb_telefone (id_cliente , ddd, telefone, tipo_telefone, score)
VALUES (1, 11, 985903854,'C',2);

INSERT INTO  tb_telefone (id_cliente , ddd, telefone, tipo_telefone, score)
VALUES (2, 11, 985903823,'C',1);

INSERT INTO  tb_telefone (id_cliente , ddd, telefone, tipo_telefone, score)
VALUES (2, 11, 985903852,'C',2);

INSERT INTO  tb_telefone (id_cliente , ddd, telefone, tipo_telefone, score)
VALUES (3, 11, 985903828,'C',1);

SELECT * FROM tb_telefone;

/*Inserção de dados tabela produtos*/

INSERT INTO tb_produto (desc_produto, valor_produto, qtd_estoque)
VALUES ('Bola Quadrada', 90, 12452);

INSERT INTO tb_produto (desc_produto, valor_produto, qtd_estoque)
VALUES ('Maquina Fotografica', 120, 1245);

INSERT INTO tb_produto (desc_produto, valor_produto, qtd_estoque)
VALUES ('Sanduiche de Presunto', 60, 4574);

INSERT INTO tb_produto (desc_produto, valor_produto, qtd_estoque)
VALUES ('Chinforinfola', 40, 32569);

SELECT * FROM tb_produto;

/*Inserção de dados tabela de pedidos*/

INSERT INTO tb_pedido (id_cliente, data_compra, num_nota_fiscal, serie_nota_fiscal, valor_total, qtd_total)
VALUES (1, '20220209', 'aaa1254', 111,207,2);

INSERT INTO tb_pedido (id_cliente, data_compra, num_nota_fiscal, serie_nota_fiscal, valor_total, qtd_total)
VALUES (1, '20220213', 'aaa1255', 238,133,3);

INSERT INTO tb_pedido (id_cliente, data_compra, num_nota_fiscal, serie_nota_fiscal, valor_total, qtd_total)
VALUES (1, '20220215', 'aaa1256', 122,528,5);

INSERT INTO tb_pedido (id_cliente, data_compra, num_nota_fiscal, serie_nota_fiscal, valor_total, qtd_total)
VALUES (1, '20220320', 'aaa1257', 145,94,2);

INSERT INTO tb_pedido (id_cliente, data_compra, num_nota_fiscal, serie_nota_fiscal, valor_total, qtd_total)
VALUES (1, '20220320', 'aaa1258', 258,206,2);

INSERT INTO tb_pedido (id_cliente, data_compra, num_nota_fiscal, serie_nota_fiscal, valor_total, qtd_total)
VALUES (1, '20220320', 'aaa1259', 258,207,2);

SELECT * FROM tb_pedido

/*Inserção de dados tabela de itens*/

INSERT INTO tb_item_pedido(id_pedido, id_produto, valor_item, valor_desconto, qtd_item)
VALUES (1,1,88,2,1);

INSERT INTO tb_item_pedido(id_pedido, id_produto, valor_item, valor_desconto, qtd_item)
VALUES (1,1,119,1,1);

INSERT INTO tb_item_pedido(id_pedido, id_produto, valor_item, valor_desconto, qtd_item)
VALUES (2,3,55,5,1);

INSERT INTO tb_item_pedido(id_pedido, id_produto, valor_item, valor_desconto, qtd_item)
VALUES (2,4,39,1,2);

INSERT INTO tb_item_pedido(id_pedido, id_produto, valor_item, valor_desconto, qtd_item)
VALUES (3,1,87,3,2);

INSERT INTO tb_item_pedido(id_pedido, id_produto, valor_item, valor_desconto, qtd_item)
VALUES (3,2,118,2,3);

INSERT INTO tb_item_pedido(id_pedido, id_produto, valor_item, valor_desconto, qtd_item)
VALUES (3,2,120,1,2);

SELECT * FROM tb_item_pedido; 