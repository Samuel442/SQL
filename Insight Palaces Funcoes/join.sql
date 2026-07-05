SELECT * FROM alugueis;
SELECT * FROM avaliacoes;
SELECT * FROM hospedagens;

-- média de notas por tipo de hospedagens
SELECT AVG(nota) media, tipo
FROM avaliacoes a
JOIN hospedagens h
ON h.hospedagem_id = a.hospedagem_id
GROUP BY tipo;

-- Agrupando por tipo exibindo maiores e menores preços e total
SELECT tipo, SUM(preco_total) ValorTotal, 
MAX(preco_total) MaiorValor,
MIN(preco_total) MenorValor
FROM alugueis a
JOIN hospedagens h
ON h.hospedagem_id = a.hospedagem_id
GROUP BY tipo; 