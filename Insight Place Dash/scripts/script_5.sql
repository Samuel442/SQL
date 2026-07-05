USE insightplaces;

CREATE VIEW view_metricas_proprietario AS
SELECT
	p.nome AS Proprietario,
    COUNT(DISTINCT h.hospedagem_id) AS total_hospedagem,
    MIN(primeira_data) AS primeira_data,
    SUM(total_dias) AS total_dias,
    SUM(dias_ocupados) AS dias_ocupados,
    ROUND((SUM(dias_ocupados) / SUM(total_dias)) * 100) AS taxa_ocupacao
FROM(
	SELECT
		hospedagem_id,
        MIN(data_inicio) AS primeira_data,
        SUM(DATEDIFF(data_fim, data_inicio)) AS dias_ocupados,
        DATEDIFF(MAX(data_fim), MIN(data_inicio)) AS total_dias
	FROM
		alugueis
	GROUP BY
		hospedagem_id
	) tabela_taxa_ocupacao
JOIN
	hospedagens h ON tabela_taxa_ocupacao.hospedagem_id = h.hospedagem_id
JOIN
	proprietarios p ON h.proprietario_id = p.proprietario_id
GROUP BY
	p.proprietario_id;


SELECT * FROM view_metricas_proprietario;