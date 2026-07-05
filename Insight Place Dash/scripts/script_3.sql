DELIMITER //
DROP PROCEDURE IF EXISTS get_dados_por_regiao;
CREATE PROCEDURE get_dados_por_regiao(regiao_nome VARCHAR(255))
BEGIN
	SELECT 
		YEAR(data_inicio) AS ano,
        MONTH(dat_inicio) AS mes,
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
	r.regiao = regiao_nome
GROUP BY
	ano, mes;
END //
DELIMITER ;

CALL get_dados_por_regiao("Sul");
CALL get_dados_por_regiao("Norte");