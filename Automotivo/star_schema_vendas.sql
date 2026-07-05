-- Conecta no banco
USE EV_BYD_Motors;

/************************************************************************************
						1. STAR SCHEMA DE VENDAS - SCRIPT REAL DDL
************************************************************************************/

-- ==================================================================================
-- TABELAS DIMENSÃO
-- ==================================================================================

CREATE TABLE Dim_Tempo (
	sk_tempo        INT PRIMARY KEY,      -- Formato: YYYYMMDD
    data_completa   DATE NOT NULL,
	ano             INT NOT NULL,
    trimestre       INT NOT NULL,
    mes             INT NOT NULL,
    nome_mes        VARCHAR(20) NOT NULL,
    dia_semana      INT NOT NULL,
    nome_dia_semana VARCHAR(20) NOT NULL,
    eh_fim_semana   CHAR(1) NOT NULL,               -- 'S' ou 'N'
    CONSTRAINT CK_tempo_fim_semana CHECK(eh_fim_semana IN('S', 'N'))
);

CREATE TABLE Dim_Modelo_Veiculo (
	sk_modelo          INT PRIMARY KEY,        -- Gerado seqencialmente no ETL 
    id_modelo_original VARCHAR(20) NOT NULL,   -- ID do sistema de origem
	nome_modelo        VARCHAR(50) NOT NULL,   -- Ex: 'BYD Dolphin'
    linha_veiculo      VARCHAR(30) NOT NULL,   -- Ex: 'Ocean', 'Dynasty'
    tipo_propulsao     VARCHAR(30) NOT NULL,   -- Ex: 'BEV', 'PHEV'
    tipo_carroceria    VARCHAR(30) NOT NULL,   -- Ex: 'SUV', 'Hatchback'
    capacidade_bateria_kwh DECIMAL(6,2),
    autonomia_wltp_km   INT
);

CREATE TABLE Dim_Produto(
	sk_produto          INT PRIMARY KEY,
    id_produto_original VARCHAR(20) NOT NULL,
    nome_produto        VARCHAR(100) NOT NULL,   -- Ex: 'Wallbox 22kW'
    categoria_produto   VARCHAR(50) NOT NULL,    -- Ex: 'Carregadores'
    preco_lista_sugerido DECIMAL(12,2) NOT NULL
);

CREATE TABLE Dim_Cliente (
	sk_cliente          INT PRIMARY KEY,
    id_cliente_original VARCHAR(20) NOT NULL,
    nome_cliente        VARCHAR(100) NOT NULL,
    tipo_cliente        VARCHAR(15) NOT NULL,     -- 'Pessoa Física' ou 'Pessoa Jurídica'
    segmento_mercado    VARCHAR(30) NOT NULL,     -- Ex: 'Frotista', 'Varejo'
    data_cadastro       DATE NOT NULL,
	CONSTRAINT CK_cliente_tipo CHECK (tipo_cliente IN ('Pessoa Física', 'Pessoa Jurídica'))
);

CREATE TABLE Dim_Vendedor (
	sk_vendedor          INT PRIMARY KEY,
    id_vendedor_original VARCHAR(20) NOT NULL,
    nome_vendedor        VARCHAR(100) NOT NULL,
	cargo                VARCHAR(50)  NOT NULL,
    data_admissao        DATE NOT NULL,
    status_ativo         CHAR(1) NOT NULL,             -- 'S' ou 'N'
    CONSTRAINT CK_vendedor_status CHECK (status_ativo IN ('S', 'N'))
);

CREATE TABLE Dim_Regiao (
	sk_regiao    INT PRIMARY KEY,
    cidade       VARCHAR(50) NOT NULL,
    estado       VARCHAR(30) NOT NULL,
    sigla_estado CHAR(2) NOT NULL,
    pais         VARCHAR(50) NOT NULL,
    regiao_macro VARCHAR(20) NOT NULL  -- Ex: 'Sudeste', 'Nordeste'
);

CREATE TABLE Dim_Canal_Venda (
	sk_canal INT PRIMARY KEY,
    nome_canal VARCHAR(40) NOT NULL,    -- Ex; 'Concessionária', 'E-commerce'
	modalidade VARCHAR(20) NOT NULL     -- 'Presencial' ou 'Online'
);

-- =========================================================================
-- TABELA FATO CENTRAL
-- =========================================================================
CREATE TABLE Fato_Vendas (
	-- Chaves Estrangeiras (Conexões)
    fk_tempo    INT NOT NULL,
    fk_modelo   INT NOT NULL,
    fk_produto  INT NOT NULL,
    fk_cliente  INT NOT NULL,
    fk_vendedor INT NOT NULL,
    fk_regiao   INT NOT NULL,
    fk_canal    INT NOT NULL,

	-- Atributos de controle (Dimensões Degeneradas)
	numero_nota_fiscal VARCHAR(30) NOT NULL,
    id_item_venda      VARCHAR(20) NOT NULL,
    
    -- Métricas Quantitativas e Financeiras
    quantidade_vendida  INT NOT NULL,
    receita_bruta       DECIMAL(14,2) NOT NULL,
    valor_desconto      DECIMAL(14,2) NOT NULL,
    receita_liquida     DECIMAL(14,2) NOT NULL,
	custo_total_produto DECIMAL(14,2) NOT NULL,
    lucro_operacional   DECIMAL(14,2) NOT NULL,
    
    -- Chave Primária Composta da Fato para garantir unicidade do item da nota
    PRIMARY KEY (numero_nota_fiscal, id_item_venda),
    
    -- Restrições de integridade (Foregin Keys)
    CONSTRAINT FK_vendas_tempo    FOREIGN KEY (fk_tempo)     REFERENCES Dim_Tempo(sk_tempo),
    CONSTRAINT FK_vendas_modelo   FOREIGN KEY (fk_modelo)    REFERENCES Dim_Modelo_Veiculo(sk_modelo),
    CONSTRAINT FK_vendas_produto  FOREIGN KEY (fk_produto)   REFERENCES Dim_Produto(sk_produto),
    CONSTRAINT FK_vendas_cliente  FOREIGN KEY (fk_cliente)   REFERENCES Dim_Cliente(sk_cliente),
    CONSTRAINT FK_vendas_vendedor FOREIGN KEY (fk_vendedor)  REFERENCES Dim_Vendedor(sk_vendedor),
    CONSTRAINT FK_vendas_regiao   FOREIGN KEY (fk_regiao)    REFERENCES Dim_Regiao(sk_regiao),
    CONSTRAINT FK_vendas_canal    FOREIGN KEY (fk_canal)     REFERENCES Dim_Canal_Venda(sk_canal)
);

-- ---------------------------------------------
-- CONFERINDO AS TABELAS CRIADAS
-- ---------------------------------------------
SELECT * FROM Dim_Tempo;
SELECT * FROM Dim_Modelo_Veiculo;
SELECT * FROM Dim_Produto;
SELECT * FROM Dim_Cliente;
SELECT * FROM Dim_Vendedor;
SELECT * FROM Dim_Regiao;
SELECT * FROM Dim_Canal_Venda;
SELECT * FROM Fato_Vendas;