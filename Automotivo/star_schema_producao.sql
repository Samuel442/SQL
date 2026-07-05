-- Conecta no banco antes de rodar a estrutura
USE EV_BYD_Motors;

/*****************************************************************
2. STAR SCHEMA DE PRODUÇÃO - SCRIPT REAL DDL
******************************************************************/

-- ===============================================================
-- TABELAS DIMENSÃO ADICIONAIS (Novos satélites da fábrica)
-- ===============================================================

CREATE TABLE Dim_Planta (
	sk_planta                 INT PRIMARY KEY,
    id_planta_original        VARCHAR(20) NOT NULL,
    nome_planta               VARCHAR(60) NOT NULL,    -- Ex: 'Complexo Camaçari', 'Planta Shenzen'
    cidade_planta             VARCHAR(50) NOT NULL,
    pais_planta               VARCHAR(50) NOT NULL,
    capacidade_nominal_ano    INT NOT NULL             -- Metas de volume anual instaladas
);

CREATE TABLE Dim_Linha_Producao (
	sk_linha              INT PRIMARY KEY,
    id_linha_original     VARCHAR(20) NOT NULL,
    nome_linha            VARCHAR(60) NOT NULL,  -- Ex: 'Linha de Montagem de Baterias', 'Estamparia Pesada'
    tipo_processo         VARCHAR(40) NOT NULL,  -- Ex: 'Automatizado', 'Semiautomatizado', 'Manual'
    sequencia_etapa       INT NOT NULL           -- Ordem lógica do fluxo fabril
);

CREATE TABLE Dim_Maquina (
	sk_maquina           INT PRIMARY KEY,
    id_maquina_original  VARCHAR(20) NOT NULL,
    nome_maquina         VARCHAR(60) NOT NULL,  -- Ex: 'Robô de solda Kuka K1', 'Injetora de Alta Pressão'
    fabricante_maquina   VARCHAR(40) NOT NULL,
    data_instalacao      DATE NOT NULL,
    criticidade          CHAR(1) NOT NULL,      -- 'A' (Alta), 'M' (Média), 'B' (Baixa)
    CONSTRAINT CK_maquina_criticidade CHECK (criticidade IN ('A', 'M', 'B'))
);

CREATE TABLE Dim_Turno (
	sk_turno       INT PRIMARY KEY,
    nome_turno     VARCHAR(20) NOT NULL,  -- Ex: 'Turno Matutino', 'Turno Noturno'
    horario_inicio TIME NOT NULL,
    horario_fim    TIME NOT NULL
);

CREATE TABLE Dim_Operador (
	sk_operador           INT PRIMARY KEY,
    id_operador_original  VARCHAR(20) NOT NULL,
    nome_operador         VARCHAR(100) NOT NULL,
    nivel_experiencia     VARCHAR(20) NOT NULL,   -- Ex: 'Júnior', 'Pleno', 'Sênior', 'Master'
    certificacao_ev       CHAR(1) NOT NULL,       -- 'S' ou 'N' (Habilitado para Alta Tensão Elétrica)
    CONSTRAINT CK_operador_certificacao CHECK (certificacao_ev IN('S', 'N'))
);

-- =================================================================
-- TABELA FATO CENTRAL
-- =================================================================

CREATE TABLE Fato_Producao (
	-- Chaves Estrangeiras Existentes (Conectam nas dimensões criadas no Bloco 1)
    fk_tempo    INT NOT NULL,
    fk_modelo   INT NOT NULL,
    fk_produto  INT NOT NULL,
    
    -- Chaves Estrangeiras Novas (Conectam nas dimensões criadas logo acima)
    fk_planta   INT NOT NULL,
    fk_linha    INT NOT NULL,
    fk_maquina  INT NOT NULL,
    fk_turno    INT NOT NULL,
    fk_operador INT NOT NULL,
    
    -- Atributos de Controle (Dimensões Degeneradas)
    numero_ordem_producao      VARCHAR(30) NOT NULL,  -- Código da OP do ERP industrial
    codigo_lote_rastreabilidade VARCHAR(50),           -- Identificador para recall ou auditoria
	
    -- Métricas Industriais (OEE/ Desempenho)
    quantidade_produzida  INT NOT NULL,                -- Peças boas finalizadas
    quantidade_refugo     INT NOT NULL,                -- Peças perdidas / com defeito irreparável
    tempo_producao_minutos DECIMAL(10,2) NOT NULL,     -- Tempo real com a máquina rodando
	tempo_setup_minutos    DECIMAL(10,2) NOT NULL,     -- Tempo de ajuste / troca de ferramentas
    eficiencia_calculada   DECIMAL(5,2)  NOT NULL,     -- Percentual de produtividade atingido
    
	-- Chave Primária Composta da Fato 
    PRIMARY KEY (numero_ordem_producao, fk_maquina, fk_operador),
    
    -- Restrições de Integridade (Esticando os 8 cabos de conexão do código)
    CONSTRAINT FK_producao_tempo     FOREIGN KEY (fk_tempo)     REFERENCES Dim_Tempo(sk_tempo),
    CONSTRAINT FK_producao_modelo    FOREIGN KEY (fk_modelo)    REFERENCES Dim_Modelo_Veiculo(sk_modelo),
    CONSTRAINT FK_producao_produto   FOREIGN KEY (fk_produto)   REFERENCES Dim_Produto(sk_produto),
    CONSTRAINT FK_producao_planta    FOREIGN KEY (fk_planta)    REFERENCES Dim_Planta(sk_planta),
    CONSTRAINT FK_producao_linha     FOREIGN KEY (fk_linha)     REFERENCES Dim_Linha_Producao(sk_linha),
    CONSTRAINT FK_producao_maquina   FOREIGN KEY (fk_maquina)   REFERENCES Dim_Maquina(sk_maquina),
    CONSTRAINT FK_producao_turno     FOREIGN KEY (fk_turno)     REFERENCES Dim_Turno(sk_turno),
    CONSTRAINT FK_producao_operador  FOREIGN KEY (fk_operador)  REFERENCES Dim_Operador(sk_operador)
);



-- --------------------------------
-- CONFERINDO AS TABELAS
-- --------------------------------

SELECT * FROM Dim_Planta;
SELECT * FROM Dim_Linha_Producao;
SELECT * FROM Dim_Maquina;
SELECT * FROM Dim_Turno;
SELECT * FROM Dim_Operador;
SELECT * FROM Fato_Producao;