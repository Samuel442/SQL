SELECT AVG(nota) media, tipo
FROM avaliacoes a
JOIN hospedagens h 
ON h.hospedagem_id = a.hospedagem_id
GROUP BY tipo;

-- corta as casas decimais
SELECT TRUNCATE(AVG(nota), 2) media, tipo
FROM avaliacoes a
JOIN hospedagens h 
ON h.hospedagem_id = a.hospedagem_id
GROUP BY tipo;

-- arredonda
SELECT ROUND(AVG(nota), 2) media, tipo
FROM avaliacoes a
JOIN hospedagens h 
ON h.hospedagem_id = a.hospedagem_id
GROUP BY tipo;

-- Funcoes condicionais
SELECT hospedagem_id, nota, 
CASE nota
	WHEN 5 THEN 'Excelnte'
    WHEN 4 THEN 'Ótimo'
    WHEN 3 THEN 'Muito Bom'
    WHEN 2 THEN 'Bom'
    ELSE 'Ruim'
END AS StatusNota
FROM avaliacoes;


