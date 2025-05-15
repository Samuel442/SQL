USE DB_ecommerce;    -- criação do repositório

/*Criação da tabela de clientes*/
CREATE TABLE tb_cliente
( id_cliente SMALLINT IDENTITY NOT NULL PRIMARY KEY
, cpf VARCHAR(11)       NOT NULL
, nome VARCHAR(255)     NOT NULL
, data_nascimento DATE
, genero VARCHAR(1)
, endereco VARCHAR(500)
, bairro VARCHAR(100)
, cidade VARCHAR(100)
, uf VARCHAR(2)
, cep VARCHAR(8)
);

SELECT * FROM tb_cliente

EXEC sp_rename 'DBO.tb_cliente', 'TB_CLIENTE2';

EXEC sp_rename 'dbo.tb_cliente2.CPF', 'DOCUMENTO', 'COLUMN';

ALTER TABLE tb_cliente2 ADD escolaridade VARCHAR(30);

ALTER TABLE tb_cliente2 DROP COLUMN escolariade;

ALTER TABLE tb_cliente2 ALTER COLUMN data_nascimento DATETIME;

DROP TABLE tb_cliente2

/*Criação da tabela de e-mails*/

CREATE TABLE tb_email
( id_email SMALLINT IDENTITY NOT NULL PRIMARY KEY
	, id_cliente SMALLINT
	, email VARCHAR(255) NOT NULL
	, score INT
	, FOREIGN KEY (id_cliente) REFERENCES tb_cliente (id_cliente)
);



/*Criação de tabela telefone*/

CREATE TABLE tb_telefone
( id_telefone SMALLINT IDENTITY NOT NULL PRIMARY KEY
  , id_cliente SMALLINT
  , ddd INT NOT NULL
  , telefone INT NOT NULL
  , score INT
  , tipo_telefone VARCHAR(1) NOT NULL
  , FOREIGN KEY (id_cliente) REFERENCES tb_cliente (id_cliente)
);

SELECT * FROM tb_email

SELECT * FROM tb_telefone 

/* Criação de tabela de pedidos*/

CREATE TABLE tb_pedido
( id_pedido SMALLINT IDENTITY  NOT NULL PRIMARY KEY
	, id_cliente SMALLINT
	, data_compra DATE
	, num_nota_fiscal VARCHAR(100)
	, serie_nota_fiscal VARCHAR(100)
	, valor_total FLOAT
	, qtd_total INT
	, FOREIGN KEY (id_cliente) REFERENCES tb_cliente (id_cliente)
);

/*Criação de tabela de produto*/

CREATE TABLE tb_produto

( id_produto SMALLINT IDENTITY NOT NULL PRIMARY KEY
	, desc_produto VARCHAR(255) NOT NULL
	, valor_produto FLOAT
	, qtd_estoque INT
);


/* Criação tabela de item */

CREATE TABLE tb_item_pedido
( id_item SMALLINT IDENTITY NOT NULL PRIMARY KEY
	, id_pedido SMALLINT
	, id_produto SMALLINT
	, valor_item FLOAT
	, valor_desconto FLOAT
	, qtd_item INT
	, FOREIGN KEY (id_pedido) REFERENCES tb_item_pedido (id_item)
	, FOREIGN KEY (id_produto) REFERENCES tb_produto (id_produto)
);