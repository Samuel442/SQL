-- Usa esse banco
USE insightplaces;

-- 10 primeiras linhas por tabela
SELECT * FROM alugueis LIMIT 10;
SELECT * FROM avaliacoes LIMIT 10;
SELECT * FROM clientes LIMIT 10;
SELECT * FROM enderecos LIMIT 10;
SELECT * FROM hospedagens LIMIT 10;
SELECT * FROM proprietarios LIMIT 10;

-- Total de registros
SELECT 
	(SELECT COUNT(*) FROM proprietarios) AS total_proprietarios,
    (SELECT COUNT(*) FROM clientes) AS total_clientes,
    (SELECT COUNT(*) FROM enderecos) AS total_enderecoes,
    (SELECT COUNT(*) FROM hospedagens) AS total_hodpedagens,
    (SELECT COUNT(*) FROM alugueis) AS total_alugueis,
    (SELECT COUNT(*) FROM avaliacoes) AS total_avaliacoes;
    
-- verifica nulos
SELECT
	COUNT(*) AS total_registros,
    COUNT(aluguel_id) AS aluguel_registros_nao_nulos,
    SUM(CASE WHEN preco_total IS NULL THEN 1 ELSE 0 END) AS nulos_nome
FROM alugueis;

SELECT
	COUNT(*) AS total_registros,
    COUNT(avaliacao_id) AS avaliacoes_registros_nao_nulos,
    SUM(CASE WHEN comentario IS NULL THEN 1 ELSE 0 END) AS nulos_nome
FROM avaliacoes;

SELECT
	COUNT(*) AS total_registros,
    COUNT(avaliacao_id) AS avaliacoes_registros_nao_nulos,
    SUM(CASE WHEN comentario IS NULL THEN 1 ELSE 0 END) AS nulos_nome
FROM avaliacoes;

-- taxa de ocupacao
SELECT
	hospedagem_id,
    MIN(data_inicio) AS primeira_data,
    SUM(DATEDIFF(data_fim, data_inicio)) AS dias_ocupados,
    DATEDIFF(MAX(data_fim), MIN(data_inicio)) AS total_dias,
    ROUND((SUM(DATEDIFF(data_fim, data_inicio)) / DATEDIFF(MAX(data_fim), MIN(data_inicio))) * 100) AS taxa_ocupacao
    FROM
		alugueis
	GROUP BY
		hospedagem_id
	ORDER BY taxa_ocupacao ASC ;