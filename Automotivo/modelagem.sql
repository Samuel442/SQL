-- Conecta no banco antes de rodar a estrutura
USE EV_BYD_Motors;

/*
"Escuta, a nossa dim_tempo está com um problema de visualização. Eu preciso 
de um relatório simples. Pegue a nossa tabela dim_tempo e me mostre apenas três 
coisas: o ID da data, a data completa, e uma coluna extra que eu quero ver se 
o sistema está calculando certo: o número do dia da semana (de 1 a 7). E por 
favor, nada de colunas com valor NULL — se algo estiver faltando, quero ver um '0' no lugar."
*/
SELECT
	d.sk_tempo AS id_data,
    COALESCE(d.data_completa, 0) AS data_completa,
    COALESCE(DAYOFWEEK(d.data_completa), 0) AS dia_semana
FROM
	dim_tempo d;
    
    
    
    
    
    
/*
"Time, preciso conferir todas as nossas vendas. Tem nota fiscal que não está 
aparecendo com a data correta no sistema. Me traz uma lista de todas as notas
 fiscais e a data de emissão de cada uma. Se a data estiver faltando, marca 
 como 'DATA PENDENTE'. Além disso, coloque o mês da venda ao lado; se não 
 tiver data, o mês tem que aparecer como 0."
*/
SELECT
	f.numero_nota_fiscal AS numero_nota_fiscal,
    COALESCE(d.data_completa, 'DATA PENDENTE') AS data_emissao,
    COALESCE(MONTH(d.data_completa), 0) AS mes_da_data
FROM
	fato_vendas f
LEFT JOIN
	dim_tempo d
ON f.fk_tempo = d.sk_tempo;









/*
"Aquele relatório anterior foi bom, mas me trouxe muita nota certa. 
Agora, eu quero que você me mostre apenas as notas fiscais que estão
 com a data faltando ('DATA PENDENTE'). Filtre o relatório para eu 
 saber exatamente quais notas preciso pedir para a equipe de TI corrigir."
*/
SELECT 
    f.numero_nota_fiscal,
    'DATA PENDENTE' AS data_emissao, -- Texto fixo, pois sabemos que a data é nula
    0 AS mes_da_data                -- Número fixo, pois sabemos que não há mês
FROM 
    fato_vendas f
LEFT JOIN 
    dim_tempo d ON f.fk_tempo = d.sk_tempo
WHERE 
    f.fk_tempo IS NULL;
    
    
    
    
    
    
    
    
/*
"Comandante, preciso saber qual foi a receita_liquida total por cada 
fk_produto. Mas não quero uma lista bagunçada; quero que o resultado 
venha ordenado daquele que vendeu mais para o que vendeu menos. Ah, 
e se algum produto ainda não tiver vendas (ou estiver sem identificação), 
pode ignorar, só quero os produtos que tiveram movimentação."
*/
SELECT
	d.nome_produto AS nome_produto,
	CONCAT('R$ ', FORMAT(SUM(f.receita_liquida), 2)) AS receita_liquida_total
FROM
	fato_vendas f
INNER JOIN
	dim_produto d
ON f.fk_produto = d.sk_produto
GROUP BY
	d.nome_produto
ORDER BY
	SUM(f.receita_liquida) DESC;









/*
"Comandante, preciso de um relatório que mostre o total de receita_liquida 
por cada mês de referência. Mas atenção: quero que você extraia o nome do 
mês (ex: 'Janeiro', 'Fevereiro') da nossa dim_tempo. Ordene pelo número do 
mês, mas exiba o nome dele."
*/    
SELECT
	CONCAT('R$ ',FORMAT(SUM(f.receita_liquida), 2)) AS receita_liquida,
    d.nome_mes AS nome_mes
FROM
	fato_vendas f
INNER JOIN
	dim_tempo d
ON f.fk_tempo = d.sk_tempo
GROUP BY
	d.nome_mes,
    MONTH(d.data_completa)
ORDER BY
	MONTH(d.data_completa) ASC;
    
    
    
    
    
    
    
    
    
    
/*
"Comandante, preciso saber a média de dias de idade das vendas que nós 
temos na base, agrupadas pelo nome do mês em que elas aconteceram. 
Quero ver qual mês tem as vendas mais 'antigas' em relação ao dia de hoje."
*/
SELECT
	COUNT(f.numero_nota_fiscal) AS numero_nota_fiscal,
    d.nome_mes AS nome_mes,
    ROUND(AVG(DATEDIFF(NOW(), d.data_completa)),0) AS idade_venda,
    MONTH(d.data_completa) AS numero_mes
FROM
	fato_vendas f
INNER JOIN
	dim_tempo d
ON f.fk_tempo = d.sk_tempo
GROUP BY
	d.nome_mes,
    numero_mes
ORDER BY
	numero_mes ASC;
    
    
    
    
    
    
    
    
/*
"Preciso que identifique agora quais vendas não possuem um cliente correspondente 
no cadastro. Verifique se o sistema está íntegro ou se temos falhas graves de 
cadastro e me entregue esse diagnóstico urgente."
*/
SELECT
	f.numero_nota_fiscal AS numero_nota_fiscal,
    d.nome_cliente AS nome_cliente
FROM
	fato_vendas f
LEFT JOIN
	dim_cliente d
ON f.fk_cliente = sk_cliente
WHERE
	d.nome_cliente IS NULL;
    
    
    
    
    
    
    
    
    
/*
"Comandante, preciso saber se o nosso calendário está completo. 
Temos vendas que não estão sendo processadas corretamente no BI 
porque a data não encontra correspondência na dim_tempo. 
Identifique agora qualquer venda que esteja 'fora do calendário'."
*/
SELECT
	f.numero_nota_fiscal AS numero_nota_fiscal,
    d.data_completa AS data_completa
FROM
	fato_vendas f
LEFT JOIN
	dim_tempo d
ON f.fk_tempo = d.sk_tempo
WHERE 
	d.data_completa IS NULL;
    
    
    
    
    
    
/*    
"Comandante, preciso ranquear os vendedores. Quero o nome de cada um, 
o total de notas emitidas e o valor total faturado por eles. Ordene 
pelos que faturaram mais para identificar quem são nossos melhores ativos agora."
*/
SELECT
	v.nome_vendedor AS nome_vendedor,
    COUNT(*) AS quantidade_nota_fiscal,
    RANK() OVER(
			ORDER BY(
				COUNT(*)
             ) DESC
    ) AS ranking
FROM
	fato_vendas f
INNER JOIN 
	dim_vendedor v
ON f.fk_vendedor = v.sk_vendedor
GROUP BY
	v.nome_vendedor;
    
    
    
    
    
    
    
    
    
/*
"Comandante, preciso do relatório de performance dos consultores na minha mesa.
Esqueça o número de notas emitidas; isso é métrica de vaidade. Quero o ranking 
dos top vendedores baseado no faturamento total acumulado. Preciso que você aplique 
uma função de ranqueamento que me entregue a posição de cada um, ordenando do maior para o menor.
Não quero saber quem emite mais papel, quero saber quem traz mais receita para o caixa. 
Ajuste o código e me entregue a lista consolidada imediatamente."
*/
SELECT
	d.nome_vendedor AS nome_vendedor,
    CONCAT('R$ ', FORMAT(SUM(f.receita_bruta),2)) AS receita_bruta,
    RANK() OVER(
			ORDER BY(
				SUM(f.receita_bruta)
            ) DESC
    ) AS ranking
FROM
	fato_vendas f
INNER JOIN
	dim_vendedor d
ON f.fk_vendedor = d.sk_vendedor
GROUP BY
	d.nome_vendedor;