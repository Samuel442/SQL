-- Conecta no banco antes de rodar a estrutura
USE EV_BYD_Motors;

-- ==================================================
-- 1. MONITORAMENTO DAS TABELAS DIMENSÃO (17 TABLEAS) 
-- ==================================================

SELECT 'dim_canal_venda' AS tabela,
	COUNT(*) AS qtd FROM dim_canal_venda;

SELECT 'dim_cliente' AS tabela,
	COUNT(*) AS qtd FROM dim_cliente;
    
SELECT 'dim_defeito' AS tabela,
	COUNT(*) AS qdt FROM dim_defeito;
    
SELECT 'dim_fornecedor' AS tabela,
	COUNT(*) AS qtd FROM dim_fornecedor;
    
SELECT 'dim_linha_producao' AS tabela,
	COUNT(*) AS qtd FROM dim_linha_producao;

SELECT 'dim_maquina' AS tabela,
	COUNT(*) AS qtd FROM dim_maquina;

SELECT 'dim_modelo_veiculo' AS tabela,
	COUNT(*) AS qtd FROM dim_modelo_veiculo;
    
SELECT 'dim_operador' AS tabela,
	COUNT(*) AS qtd FROM dim_operador;
    
SELECT 'dim_peca' AS tabela,
	COUNT(*) AS qtd FROM dim_peca;
    
SELECT 'dim_planta' AS tabela,
	COUNT(*) AS qtd FROM dim_planta;
    
SELECT 'dim_produto' AS tabela,
	COUNT(*) AS qtd FROM dim_produto;
    
SELECT 'dim_regiao' AS tabela,
	COUNT(*) AS qtd FROM dim_regiao;

SELECT 'dim_tecnico' AS tabela,
	COUNT(*) AS qtd FROM dim_tecnico;
    
SELECT 'dim_tempo' AS tabela,
	COUNT(*) AS qtd FROM dim_tempo;

SELECT 'dim_transportadora' AS tabela,
	COUNT(*) AS qtd FROM dim_transportadora;
    
SELECT 'dim_turno' AS tabela,
	COUNT(*) AS qtd FROM dim_turno;  
    
SELECT 'dim_vendedor' AS tabela,
	COUNT(*) AS qtd FROM dim_vendedor;
    
-- ==================================================
-- 2. TABELAS FATO
-- ==================================================

SELECT 'fato_compras' AS tabelas,
	COUNT(*) AS qtd FROM fato_compras;
    
SELECT 'fato_estoque' AS tabela,
	COUNT(*) AS qtd FROM fato_estoque;
    
SELECT 'fato_logistica' AS tabela,
	COUNT(*) AS qtd FROM fato_logistica;

SELECT 'fato_manutencao' AS tabela,
	COUNT(*) AS qtd FROM fato_manutencao;

SELECT 'fato_producao' AS tabela,
	COUNT(*) AS qtd FROM fato_producao;
    
SELECT 'fato_qualidade' AS tabela,
	COUNT(*) AS qtd FROM fato_qualidade;
    
SELECT 'fato_vendas' AS tabela,
	COUNT(*) AS qtd FROM fato_vendas;
    