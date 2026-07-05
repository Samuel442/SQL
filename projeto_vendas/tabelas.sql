CREATE DATABASE IF NOT EXISTS sales_db
CHARACTER SET utf8mb4
COLLATE utf8mb4_general_ci;

USE sales_db;

-- -------------------
-- Criação das tabelas
-- -------------------

-- 1) TABELA: "FTOPED" (TABELA DE PEDIDOS)
CREATE TABLE FTOPED(
	IDDATA   INT,     -- id de data
    IDFILIAL INT,     -- id de filial de expedição
    IDPRD    INT,     -- id de produto
    IDTETVND INT,     -- id de território de venda
    IDCLIENT INT,     -- id de cliente
    NUMPED   DECIMAL(18,2),      -- número de pedido
    VLRVNDEFTFAT  DECIMAL(18,2), -- valor de venda bruta
    VLRRCTLIQ  DECIMAL(18,2),    -- valor de receita líquida
    VLRMRGBRT  DECIMAL(18,2),    -- valor de margem bruta
    VLRMRGCRB  DECIMAL(18,2)     -- valor de margem de contribuição
);

-- 2) TABELA: "DIMFIL" (TABELA DE FILIAIS DE EXPEDIÇÃO)
CREATE TABLE DIMFIL(
	IDFILIAL INT,        -- id de filial de expedição
    CODFIL   VARCHAR(50),-- código da filial de expedição
    DESFIL   VARCHAR(150) -- nome da filial de expedição
);

-- 3) TABELA: "DIMPRD" (TABELA DE PRODUTOS)
CREATE TABLE DIMPRD(
	IDPRD INT,             -- id de produto
	CODPRD	VARCHAR(50),   -- código do produto
	DESPRD	VARCHAR(255),  -- descrição do produto
	CODFRN	VARCHAR(50),   -- código do fornecedor do produto
	DESFRN	VARCHAR(255)   -- descrição do fornecedor do produto
);

-- 4) TABELA: "DIMTETVND" (TABELA DE TERRITÓRIOS/VENDEDORES)
CREATE TABLE DIMTETVND(
	IDTETVND INT,           -- id de território de venda
	CODTETVND VARCHAR(50),	-- código do território de vendas
	DESTETVND VARCHAR(255),	-- descrição do território de vendas
	NOMVND VARCHAR(255),	-- nome do vendedor responsável pelo território 
	UFTETVND CHAR(2)	    -- estado (UF) onde o território está localizado
);

-- 5) TABELA: "DIMCLIENT" (TABELA DE CLIENTES)
CREATE TABLE DIMCLIENT(
	IDCLIENT INT,          -- id do cliente 
	CODCLIENT VARCHAR(50), -- código do cliente 
	NOMRAZSOC VARCHAR(255) -- nome da razão social do cliente
);

-- 6) TABELA: "DIMPOD" (TABELA DE DATAS/PERÍODOS)
CREATE TABLE DIMPOD(
	IDDATA INT,     -- id de data
	NUMANOMES INT	-- DATA NO FORMATO "AAAMM"
);


