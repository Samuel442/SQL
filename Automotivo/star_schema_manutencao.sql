-- Conecta no banco antes de rodar a estrutura
USE EV_BYD_Motors;

/*****************************************************
4. STAR SCHEMA DE MANUTENÇÃO - SCRIPT REAL DDL
*****************************************************/

-- =======================================================
-- TABELAS DIMENSÃO ADICIONAIS (Novas tabelas de suporte)
-- =======================================================

CREATE TABLE Dim_Motivo_Parada (
	sk_motivo             INT PRIMARY KEY,
    id_motivo_original    VARCHAR(20) NOT NULL,    
    tipo_manutencao       VARCHAR(30) NOT NULL,  -- Ex: 'Corretiva' (Quebrou), 'Preventiva' (Planejada), 'Preditiva' 
    descricao_motivo      VARCHAR(100) NOT NULL, -- Ex: 'Superaquecimento do Motor Servo', 'Troca do Óleo Programada'
    parada_planejada      CHAR(1) NOT NULL,      -- 'S' (Sim, sabíamos antes) ou 'N' (Não, quebrou do nada)
	CONSTRAINT CK_parada_planejada CHECK (parada_planejada IN ('S', 'N'))
);

CREATE TABLE Dim_Tecnico (
	sk_tecnico           INT PRIMARY KEY,
    id_tecnico_original  VARCHAR(20) NOT NULL,
    nome_tecnico         VARCHAR(100) NOT NULL,
    especialidade        VARCHAR(40) NOT NULL,  -- Ex: 'Mecatrônica', 'Elétrica', 'Robótica', 'Hidráulica'
    custo_hora_tecnico   DECIMAL(10,2) NOT NULL
);

-- ===============================================================
-- TABELA FATO CENTRAL
-- ===============================================================

CREATE TABLE Fato_Manutencao (
	-- Chaves Estrangeiras Existentes (Reaproveitando Dimensões Conformadas)
    fk_tempo     INT NOT NULL,
    fk_planta    INT NOT NULL,
    fk_linha     INT NOT NULL,
    fk_maquina   INT NOT NULL,
    fk_turno     INT NOT NULL,
    fk_peca      INT NOT NULL, -- Peça de reposição gasta (se houver)
    
    -- Chaves Estrangeiras Novas (Criadas logo acima)
	fk_motivo   INT NOT NULL,
    fk_tecnico  INT NOT NULL,
    
    -- Atributos de Controle (Dimensões Degeneradas)
    numero_ordem_servico VARCHAR(30) NOT NULL,  -- Código da OS no software de manutenção (CMMS)
    gravidade_evento     VARCHAR(20) NOT NULL,  -- Ex: 'Crítica' (Linha Parada), 'Baixa' (Maquinário reserva assumiu)
    
    -- Métricas de Engenharia de Confiabilidade (MTBF / MTTR)
    tempo_parado_minutos    DECIMAL(10,2) NOT NULL, -- Tempo que a máquina ficou indisponível (Down time)
    tempo_reparo_minutos    DECIMAL(10,2) NOT NULL, -- Tempo que o técnico passou mexendo nela (Repair time)
    quantidade_pecas_subst  INT NOT NULL,           -- Volume de peças gastas do estoque
    custo_total_pecas       DECIMAL(12,2) NOT NULL, -- Valor financeiro dos componentes trocados
    custo_indisponibilidade DECIMAL(14,2) NOT NULL, -- Prejuízo estimado da fábrica com a máquina parada

	-- Chave primária composta da fato
    PRIMARY KEY (numero_ordem_servico, fk_maquina, fk_tecnico, fk_tempo),
    
    -- Restrições de integridade (conectando os 8 cabos via código)
    CONSTRAINT FK_manutencao_tempo    FOREIGN KEY (fk_tempo)     REFERENCES Dim_Tempo(sk_tempo),
    CONSTRAINT FK_manutencao_planta   FOREIGN KEY (fk_planta)    REFERENCES Dim_Planta(sk_planta),
    CONSTRAINT FK_manutencao_linha    FOREIGN KEY (fk_linha)     REFERENCES Dim_Linha_Producao(sk_linha),
    CONSTRAINT FK_manutencao_maquina  FOREIGN KEY (fk_maquina)   REFERENCES Dim_Maquina(sk_maquina),
    CONSTRAINT FK_manutencao_turno    FOREIGN KEY (fk_turno)     REFERENCES Dim_Turno(sk_turno),
    CONSTRAINT FK_manutencao_peca     FOREIGN KEY (fk_peca)      REFERENCES Dim_Peca(sk_peca),
    CONSTRAINT FK_manutencao_motivo   FOREIGN KEY (fk_motivo)    REFERENCES Dim_Motivo_Parada(sk_motivo),
    CONSTRAINT FK_manutencao_tecnico  FOREIGN KEY (fk_tecnico)   REFERENCES Dim_Tecnico(sk_tecnico)

);


-- -----------------------------
-- TESTE DE TABELAS
-- -----------------------------

SELECT * FROM Dim_Motivo_Parada;
SELECT * FROM Dim_Tecnico;
SELECT * FROM Fato_Manutencao;