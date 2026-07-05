-- Conecta no banco antes de rodar a estrutura
USE EV_BYD_Motors;

/*****************************************************
5. STAR SCHEMA DE ESTOQUE - SCRIPT REAL DDL
*****************************************************/

-- ======================================================
-- TABELAS DIMENSÃO ADICIONAIS (Novas tabelas de suporte)
-- ======================================================

CREATE TABLE Dim_Armazem (
	sk_armazem              INT PRIMARY KEY,
    id_armazem_original     VARCHAR(20) NOT NULL,
    nome_armazem            VARCHAR(60) NOT NULL,  -- Ex: 'Almoxarifado Central', 'Pátio de Carros prontos', 'Galpão de Baterias'
    tipo_armazenagem        VARCHAR(30) NOT NULL,  -- Ex: 'Climatizado', 'Área Descoberta', 'Rack Vertical'
    temperatura_controlada  CHAR(1) NOT NULL,      -- 'S' (Sim, para baterias) ou 'N' (Não)
    CONSTRAINT CK_armazem_temperatura CHECK (temperatura_controlada IN ('S', 'N'))
);

-- =======================================================
-- TABELA FATO CENTRAL
-- =======================================================

CREATE TABLE Fato_Estoque (
	
    -- Chaves Estrangeiras Existentes (Reaproveitando Dimensões Conformidade)
    fk_tempo     INT NOT NULL,  -- Data do Snapshot (Foto diária do saldo)
    fk_modelo    INT NOT NULL,  -- Carros prontos (se houver no pátio)
    fk_produto   INT NOT NULL,  -- Packs de Lítio e Motores
    fk_peca      INT NOT NULL,  -- Matérias-primas e parafusos
    fk_planta    INT NOT NULL,  -- Fábrica responsável

	-- Chave Estrangeira Nova (Criada logo acima)
    fk_armazem   INT NOT NULL,
    
    -- Atributos de Controle (Dimensões Degeneradas)
    codigo_posicao_pos VARCHAR(30) NOT NULL, -- Identificação da rua / corredor / bloco no estoque (Ex: 'RUA-A-PREDIO-3')
    
    -- Métricas de Inventário e Cobertura (Snapshot Diário)
	quantidade_saldo_final   INT NOT NULL,            -- Quantidade física total na foto do dia
    quantidade_reservada     INT NOT NULL,            -- Itens já bipados / separados para a linha de produção
    quantidade_disponivel    INT NOT NULL,            -- Saldo livre para uso (Saldo Final - Reservada)
    custo_total_estoque      DECIMAL(14,2) NOT NULL,  -- Valor financeiro parado na posição
    consumo_medio_diario     DECIMAL(10,2) NOT NULL,  -- Média de saída diária daquele item
    dias_cobertura_estimado  INT NOT NULL,            -- Quantos dias o estoque atual dura antes de zerar

	-- Chave primária composta da fato (garante um registro único por dia, por item e por local)
	PRIMARY KEY (fk_tempo, fk_armazem, fk_peca, fk_produto, fk_modelo),
    
    -- Restrições de Integridade (Esticando os 6 cabos de conexão via código)
    CONSTRAINT FK_estoque_tempo     FOREIGN KEY (fk_tempo)      REFERENCES Dim_Tempo(sk_tempo),
    CONSTRAINT FK_estoque_modelo    FOREIGN KEY (fk_modelo)     REFERENCES Dim_Modelo_Veiculo(sk_modelo),
    CONSTRAINT FK_estoque_produto   FOREIGN KEY (fk_produto)    REFERENCES Dim_Produto(sk_produto),
    CONSTRAINT FK_estoque_peca      FOREIGN KEY (fk_peca)       REFERENCES Dim_Peca(sk_peca),
    CONSTRAINT FK_estoque_planta    FOREIGN KEY (fk_planta)     REFERENCES Dim_Planta(sk_planta),
    CONSTRAINT FK_estoque_armazem   FOREIGN KEY (fk_armazem)    REFERENCES Dim_Armazem(sk_armazem)
);

-- ------------------------
-- VERIFICANDO TABELAS
-- ------------------------

SELECT * FROM Dim_Armazem;
SELECT * FROM Fato_Estoque;