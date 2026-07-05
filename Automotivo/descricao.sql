/*******************************************************************************
                     ARQUITETURA DO DATA WAREHOUSE (FÁBRICA EV-BYD MOTORS)
                             DOCUMENTAÇÃO DOS STAR SCHEMAS
*******************************************************************************/

-- =============================================================================
-- 1. STAR SCHEMA DE VENDAS (Comercial, Faturamento e Margem)
-- =============================================================================
-- Fato Central:
--   - Fato_Vendas
-- Dimensões Conectadas:
--   - Dim_Tempo          (Data da venda)
--   - Dim_Modelo_Veiculo (Carros elétricos/híbridos vendidos)
--   - Dim_Produto        (Carregadores, acessórios ou kits extras)
--   - Dim_Cliente        (Consumidor final ou CNPJ da concessionária)
--   - Dim_Vendedor       (Consultor de vendas responsável)
--   - Dim_Regiao         (Localização geográfica/Concessionária)
--   - Dim_Canal_Venda    (Venda Direta, Concessionária, E-commerce)


-- =============================================================================
-- 2. STAR SCHEMA DE PRODUÇÃO (Chão de Fábrica e Indicadores de OEE)
-- =============================================================================
-- Fato Central:
--   - Fato_Producao
-- Dimensões Conectadas:
--   - Dim_Tempo          (Data de finalização do lote/veículo)
--   - Dim_Modelo_Veiculo (Modelo do veículo montado)
--   - Dim_Produto        (Módulos de bateria ou motores fabricados isoladamente)
--   - Dim_Planta         (Unidade fabril - ex: Camaçari, Shenzhen)
--   - Dim_Linha_Producao (Estamparia, Pintura, Montagem de Baterias, Montagem Final)
--   - Dim_Maquina        (Robôs de solda, injetoras de alumínio, prensas)
--   - Dim_Turno          (Turno da produção: Manhã, Tarde, Noite)
--   - Dim_Operador       (Operador ou líder de linha responsável)


-- =============================================================================
-- 3. STAR SCHEMA DE QUALIDADE (Auditoria, Garantia e Retrabalho)
-- =============================================================================
-- Fato Central:
--   - Fato_Qualidade
-- Dimensões Conectadas:
--   - Dim_Tempo          (Data da inspeção/detecção da falha)
--   - Dim_Modelo_Veiculo (Modelo do carro com a não-conformidade)
--   - Dim_Produto        (Componente eletrônico/bateria afetado)
--   - Dim_Peca           (Item de estoque específico/Insumo com problema)
--   - Dim_Planta         (Fábrica onde ocorreu o desvio)
--   - Dim_Linha_Producao (Linha onde o defeito foi gerado)
--   - Dim_Turno          (Turno em que o erro foi detectado)
--   - Dim_Operador       (Inspetor de qualidade que laudou o defeito)
--   - Dim_Defeito        (Tipo/Código do defeito - ex: Célula de bateria fora de especificação)
--   - Dim_Fornecedor     (Se a peça com falha veio de um parceiro externo)


-- =============================================================================
-- 4. STAR SCHEMA DE MANUTENÇÃO (Confiabilidade, Ativos e MTTR/MTBF)
-- =============================================================================
-- Fato Central:
--   - Fato_Manutencao
-- Dimensões Conectadas:
--   - Dim_Tempo          (Data e hora da quebra ou parada planejada)
--   - Dim_Planta         (Unidade industrial afetada)
--   - Dim_Linha_Producao (Linha que parou de produzir devido à falha)
--   - Dim_Maquina        (Equipamento/Robô que sofreu a intervenção)
--   - Dim_Turno          (Turno do evento)
--   - Dim_Peca           (Componente de reposição utilizado - ex: Placa de circuito, sensor)
--   - Dim_Motivo_Parada  (Classificação: Corretiva, Preventiva, Preditiva)
--   - Dim_Tecnico        (Engenheiro ou técnico de manutenção que realizou o reparo)


-- =============================================================================
-- 5. STAR SCHEMA DE ESTOQUE (Inventário, Giro e Cobertura)
-- =============================================================================
-- Fato Central:
--   - Fato_Estoque
-- Dimensões Conectadas:
--   - Dim_Tempo          (Data do snapshot diário da posição de estoque)
--   - Dim_Modelo_Veiculo (Estoque de carros prontos nos pátios)
--   - Dim_Produto        (Subconjuntos armazenados - ex: Motores Elétricos, Packs de Lítio)
--   - Dim_Peca           (Insumos menores e matérias-primas no almoxarifado)
--   - Dim_Planta         (Fábrica dona daquele estoque)
--   - Dim_Armazem        (Galpão Logístico, Almoxarifado Central, Pátio de Exportação)


-- =============================================================================
-- 6. STAR SCHEMA DE LOGÍSTICA (Inbound, Outbound e Fretes)
-- =============================================================================
-- Fato Central:
--   - Fato_Logistica
-- Dimensões Conectadas:
--   - Dim_Tempo          (Data de envio e data estimada/real de entrega)
--   - Dim_Modelo_Veiculo (Carros transportados para as concessionárias)
--   - Dim_Produto        (Insumos pesados em trânsito)
--   - Dim_Cliente        (Destinatário - Concessionária ou cliente corporativo)
--   - Dim_Regiao         (Estado/País de destino)
--   - Dim_Transportadora (Empresa logística - Cegonha, Navio Ro-Ro, Operador Multimodal)
--   - Dim_Armazem        (Centro de Distribuição ou Pátio de Origem)


-- =============================================================================
-- 7. STAR SCHEMA DE COMPRAS (Procurement e Suprimentos)
-- =============================================================================
-- Fato Central:
--   - Fato_Compras
-- Dimensões Conectadas:
--   - Dim_Tempo          (Data de emissão do pedido de compra)
--   - Dim_Produto        (Grandes itens comprados - ex: Lotes de Baterias Blade)
--   - Dim_Peca           (Matérias-primas e componentes em geral - ex: Lítio, Cobre, Chips)
--   - Dim_Fornecedor     (Empresa fornecedora dos materiais)
--   - Dim_Planta         (Fábrica de destino que receberá os insumos)