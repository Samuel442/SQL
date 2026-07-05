-- Conecta no banco antes de rodar a estrutura
USE EV_BYD_Motors;

/**********************************************************
3. STAR SCHEMA DE QUALIDADE - SCRIPT REAL DDL
**********************************************************/

-- ========================================================
-- TABELAS  DIMENSÃO ADICIONAIS (Novas tabelas de suporte)
-- ========================================================

CREATE TABLE Dim_Defeito (
	sk_defeito           INT PRIMARY KEY,
    id_defeito_original  VARCHAR(20) NOT NULL,
    nome_defeito         VARCHAR(100) NOT NULL,  -- Ex: 'Fuga de Corrente na Célula', 'Desalinhamento de Porta' 
    categoria_defeito    VARCHAR(50) NOT NULL,   -- Ex: 'Elétrico', 'Mecânico', 'Pintura', 'Software'
    gravidade_defeito    VARCHAR(20) NOT NULL    -- Ex: 'Crítico', 'Maior', 'Menor'
);

CREATE TABLE Dim_Fornecedor (
	sk_fornecedor          INT PRIMARY KEY,
    id_fornecedor_original VARCHAR(20) NOT NULL,
    nome_fornecedor        VARCHAR(100) NOT NULL, -- Ex: 'CATL Battery Tech', 'Brembo S.p.A'
    cnpj_fornecedor        VARCHAR(20) NOT NULL,  
    pais_origem            VARCHAR(50) NOT NULL,  
    status_homologacao     VARCHAR(20) NOT NULL   -- Ex: 'Ativo', 'Em Auditoria', 'Suspenso'
);

CREATE TABLE Dim_Peca (
	sk_peca               INT PRIMARY KEY,
    id_peca_original      VARCHAR(20) NOT NULL,
    nome_peca             VARCHAR(100) NOT NULL, -- Ex: 'Célula LFP 3.2V', 'Inversor de corrente IGBT'
    codigo_part_number    VARCHAR(40) NOT NULL,  -- Código de engenharia global da peça
    categoria_peca        VARCHAR(50) NOT NULL,  -- Ex: 'Powertrain', 'Chassis', 'Acabamento Interno'
    custo_unitario_padrao DECIMAL(12,2) NOT NULL
);

-- =================================================================
-- TABELA FATO CENTRAL
-- =================================================================

CREATE TABLE Fato_Qualidade (
	-- Chaves estrangeiras existentes (blocos 1 e 2)
    fk_tempo     INT NOT NULL,
    fk_modelo    INT NOT NULL,
    fk_produto   INT NOT NULL,
    fk_planta    INT NOT NULL,
    fk_linha     INT NOT NULL,
    fk_turno     INT NOT NULL,
    fk_operador  INT NOT NULL,   -- Atua como o Inspetor da Qualidade aqui
    
    -- Chaves Estrangeiras Novas (Criadas logo Acima)
    fk_defeito    INT NOT NULL,
    fk_fornecedor INT NOT NULL,
    fk_peca       INT NOT NULL,
    
    -- Atributos de Controle (Dimensões Degeneradas)
    numero_chassi_vin    VARCHAR(30) NOT NULL, -- Identificador exclusivo do veículo afetado
    numero_relatorio_nc VARCHAR(30) NOT NULL, -- Código do relatório de Não-Conformidade (RNC)

	-- Métricas de Qualidade e Custos de Retrabalho
    quantidade_defeitos      INT NOT NULL,            -- Quantidade de falhas idênticas achadas no lote / carro
    tempo_inspecao_minutos   DECIMAL(8,2) NOT NULL,   -- Tempo gasto pelo inspetor na análise
    tempo_retrabalho_minutos DECIMAL(8,2) NOT NULL,   -- Tempo gasto na oficina corrigindo o erro
    custo_material_reparo    DECIMAL(12,2) NOT NULL,  -- Custo de peças gastas no conserto
    custo_mao_obra_reparo    DECIMAL(12,2) NOT NULL,  -- Custo calculado do tempo dos mecânicos
    status_final_inspecao    VARCHAR(20) NOT NULL,    -- Ex: 'Aprovado após Retrabalho', 'Scrap (Sucateado)'

	-- Chave primária composta da fato
    PRIMARY KEY (numero_relatorio_nc, numero_chassi_vin, fk_defeito, fk_peca),
    
    -- Restrições de Integridade (Esticando as 10 conexões via código)
    CONSTRAINT FK_qualidade_tempo           FOREIGN KEY (fk_tempo)           REFERENCES Dim_Tempo(sk_tempo),
    CONSTRAINT FK_qualidade_modelo          FOREIGN KEY (fk_modelo)          REFERENCES Dim_Modelo_Veiculo(sk_modelo),
    CONSTRAINT FK_qualidade_produto         FOREIGN KEY (fk_produto)         REFERENCES Dim_Produto(sk_produto),
    CONSTRAINT FK_qualidade_planta          FOREIGN KEY (fk_planta)          REFERENCES Dim_Planta(sk_planta),
    CONSTRAINT FK_qualidade_linha           FOREIGN KEY (fk_linha)           REFERENCES Dim_Linha_Producao(sk_linha),
    CONSTRAINT FK_qualidade_turno           FOREIGN KEY (fk_turno)           REFERENCES Dim_Turno(sk_turno),
    CONSTRAINT FK_qualidade_operador        FOREIGN KEY (fk_operador)        REFERENCES Dim_Operador(sk_operador),
    CONSTRAINT FK_qualidade_defeito         FOREIGN KEY (fk_defeito)         REFERENCES Dim_Defeito(sk_defeito),
    CONSTRAINT FK_qualidade_fornecedor      FOREIGN KEY (fk_fornecedor)      REFERENCES Dim_Fornecedor(sk_fornecedor),
    CONSTRAINT FK_qualidade_peca            FOREIGN KEY (fk_peca)            REFERENCES Dim_Peca(sk_peca)
);


-- ------------------------------
-- TESTE DAS TABELAS
-- ------------------------------
SELECT * FROM Dim_Defeito;
SELECT * FROM Dim_Fornecedor;
SELECT * FROM Dim_Peca;
SELECT * FROM Fato_Qualidade;