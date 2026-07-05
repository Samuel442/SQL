-- Conecta no banco antes de rodar a estreutura
USE EV_BYD_Motors;

/*****************************************************
6. STAR SCHEMA DE LOGÍSTICA - SCRIPT REAL DDL
*****************************************************/

-- ======================================================
-- TABELAS DIMENSÃO ADICIONAIS (Novas tabelas de suporte)
-- ======================================================

CREATE TABLE Dim_Transportadora (
	sk_transportadora   INT PRIMARY KEY,
    id_transp_original  VARCHAR(20) NOT NULL,
    razao_social        VARCHAR(100) NOT NULL,
    modal_transporte    VARCHAR(40) NOT NULL,  -- Ex: 'Rodoviário (Cegonha)', 'Marítimo (Nvio Ro-Ro)', 'Multimodal'
    status_contrato     VARCHAR(20) NOT NULL   -- Ex: 'Ativo', 'Vencido', 'Suspenso'
);

-- =================================================
-- TABELA FATO CENTRAL
-- =================================================

CREATE TABLE Fato_Logistica (
	-- Chaves Estrangeiras Existentes (Reaproveitando Dimensões Conformadas)
    fk_tempo     INT NOT NULL,   -- Data de Emissão / Despacho da carga
    fk_modelo    INT NOT NULL,   -- Veículos embarcados
    fk_produto   INT NOT NULL,   -- Componentes ou baterias em trânsito
    fk_armazem   INT NOT NULL,   -- Pátio ou CD de Origem do despacho
    
    -- Chaves Estrangeiras Novas (Criadas Logo acima)
    fk_cliente          INT NOT NULL,  -- Destinatário final
    fk_regiao           INT NOT NULL,  -- Localização geográfica de entrega
    fk_transportadora   INT NOT NULL,  -- Parceiro logístico responsável
    
    -- Atributos de controle (Dimensões Degeneradas)
    numero_conhecimento_cte VARCHAR(30) NOT NULL, -- Conhecimento de Transporte Eletônico (CT-e)
    numero_nota_fiscal      VARCHAR(30) NOT NULL, -- NF-e atrelada á carga
    status_entrega          VARCHAR(30) NOT NULL, -- Ex: 'Em Trânsito', 'Entregue no Prazo', 'Entregue com Atrazo'

	-- Métricas de Perfórmance Logística e Custos de Frete
	quantidade_transportada INT NOT NULL,           -- Volume de itens ou carros despachados
	custo_frete_total       DECIMAL(12,2) NOT NULL, -- Valor pago á transportadora pelo envio 
	custo_seguro_carga      DECIMAL(12,2) NOT NULL, -- Custo de cobertura contra sinistro / roubos
    peso_bruto_total_kg     DECIMAL(12,2) NOT NULL, -- Peso total para cálculo de cubagem / capacidade
    distancia_percorrida_km INT NOT NULL,           -- Distância rodada ou navegada estimada
    dias_lead_time_real     INT,                    -- Quantidade de dias que levou desde o enviao até o destino

	-- Chave Primária Composta da Fato
	PRIMARY KEY (numero_conhecimento_cte, fk_transportadora, fk_tempo),

	-- Restrições de Integridade (Esticando os 7 cabos de conexão via código)
    CONSTRAINT FK_logistica_tempo              FOREIGN KEY (fk_tempo)            REFERENCES Dim_Tempo(sk_tempo),
    CONSTRAINT FK_logistica_modelo             FOREIGN KEY (fk_modelo)           REFERENCES Dim_Modelo_Veiculo(sk_modelo),
    CONSTRAINT FK_logistica_produto            FOREIGN KEY (fk_produto)          REFERENCES Dim_Produto(sk_produto),
    CONSTRAINT FK_logistica_armazem            FOREIGN KEY (fk_armazem)          REFERENCES Dim_Armazem(sk_armazem),
    CONSTRAINT FK_logistica_cliente            FOREIGN KEY (fk_cliente)          REFERENCES Dim_Cliente(sk_cliente),
    CONSTRAINT FK_logistica_regiao             FOREIGN KEY (fk_regiao)           REFERENCES Dim_Regiao(sk_regiao),
    CONSTRAINT FK_logistica_transportadora     FOREIGN KEY (fk_transportadora)   REFERENCES Dim_Transportadora(sk_transportadora)
);


-- =============================================
-- TESTANDO TABELAS CRIADAS
-- =============================================

SELECT * FROM Dim_Transportadora;
SELECT * FROM Fato_Logistica;