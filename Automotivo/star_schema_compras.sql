-- Conecta no banco antes de rodar a estrutura
USE EV_BYD_Motors;

/***********************************************
7. STAR SCHEMA DE COMPRAS - SCRIPTS REAL DDL
***********************************************/

-- =============================================
-- TABELA FATO CENTRAL
-- =============================================

CREATE TABLE Fato_Compras (
	-- Chaves Estrangeiras Existentes (Reaproveitando Dimensões Conformadas dos blocos anteriores)
	fk_tempo        INT NOT NULL, -- Data de Emissão do Pedido de Compra (PO)
    fk_produto      INT NOT NULL, -- Grandes subconjuntos comprados comprados (ex: Motores, Baterias prontas)
    fk_peca         INT NOT NULL, -- Matérias-primas e componentes menores (Lítio, Chips)
    fk_fornecedor   INT NOT NULL, -- Fornecedor parceiro homologado
    fk_planta       INT NOT NULL, -- Fábrica de destino dos insumos

	-- Atributos de Controle (Dimensões Degeneradas)
    numero_pedido_compra VARCHAR(30) NOT NULL,  -- Código de Ordem de Compra (Purchase Order - PO)
    status_pedido        VARCHAR(30) NOT NULL,  -- Ex: 'Aprovado', 'Em Cotação', 'Entregue Parcial', 'Cancelado'
    condicao_pagamento   VARCHAR(40) NOT NULL,  -- Ex: 'Faturamento 30 / 60 Dias', 'Á Vista FOB', 'Carta de Crédito'

	-- Métricas de Procurement e Custos de Suprimentos
    quantidade_comprada       INT NOT NULL,            -- Volume de itens solicitados no pedido
    quantidade_recebida       INT NOT NULL,            -- Volume real que já deu entrada no almoxarifado
    preco_unitario_efetivo    DECIMAL(12,2) NOT NULL,  -- Valor real pago por unidade (pode variar do custo padrão)
    custo_total_pedido        DECIMAL(14,2) NOT NULL,  -- Valor total financeiro da aquisição (Quantidade Comprada x Preço Unitário)
    valor_desconto_obtido     DECIMAL(12,2) NOT NULL,  -- Economia gerada por negociação (Saves de Compras)
    tempo_atendimento_dias    INT,                     -- Dias decorridos entre a emissão do pedido e a entrega do fornecedor

	-- Chave Primária Composta da Fato
    PRIMARY KEY (numero_pedido_compra, fk_peca, fk_produto, fk_fornecedor, fk_tempo),

	-- Restrições de Inteligência (Conectando os 5 cabos diretamente nas tabelas já criadas)
    CONSTRAINT FK_compras_tempo          FOREIGN KEY (fk_tempo)       REFERENCES Dim_Tempo(sk_tempo),
    CONSTRAINT FK_compras_produto        FOREIGN KEY (fk_produto)     REFERENCES Dim_Produto(sk_produto),
    CONSTRAINT FK_compras_peca           FOREIGN KEY (fk_peca)        REFERENCES Dim_Peca(sk_peca),
    CONSTRAINT FK_compras_fornecedor     FOREIGN KEY (fk_fornecedor)  REFERENCES Dim_Fornecedor(sk_fornecedor),
    CONSTRAINT FK_compras_planta         FOREIGN KEY (fk_planta)      REFERENCES Dim_Planta(sk_planta)
);

-- =============================================
-- TESTANDO AS TABELAS CRIADAS
-- =============================================

SELECT * FROM Fato_Compras;