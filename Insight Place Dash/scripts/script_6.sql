SELECT * FROM view_metricas_proprietario;
CREATE VIEW view_dados_regiao AS
SELECT
	r.regiao,
    AVG(a.preco_total / DATEDIFF(a.data_fim, a.data_inicio)) AS media_preco_aluguel,
    MAX(a.preco_total / DATEDIFF(a.data_fim, a.data_inicio)) AS max_preco_dia,
    MIN(a.preco_total / DATEDIFF(a.data_fim, a.data_inicio)) AS min_preco_dia,
    AVG(DATEDIFF(a.data_fim, a.data_inicio)) AS media_dias_aluguel
FROM
	alugueis a
JOIN
	hospedagens h ON a.hospedagem_id = h.hospedagem_id
JOIN
	enderecos e ON h.endereco_id = e.endereco_id
JOIN
	regioes_geograficas r ON r.estado = e.estado
GROUP BY
	r.regiao;
    
SELECT * FROM view_dados_regiao;




CREATE VIEW ocupacao_por_regiao_tempo AS
SELECT
	YEAR(data_inicio) AS ano,
    MONTH(data_inicio) AS mes,
    COUNT(*) AS total_alugueis
FROM 
	alugueis a
JOIN 
	hospedagens h ON a.hospedagem_id = h.hospedagem_id
JOIN 
	enderecos e ON h.endereco_id = e.endereco_id
JOIN
	regioes_geograficas r ON e.estado = r.estado
WHERE
	r.regiao = "Sudeste"
GROUP BY
	r.regiao, ano, mes;
    
SELECT * FROM ocupacao_por_regiao_tempo;
SELECT * FROM ocupacao_por_regiao_tempo
WHERE r.regiao = 'Sudeste' AND ano = 2023;