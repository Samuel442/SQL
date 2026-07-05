USE insightplaces;

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
	ano, mes;