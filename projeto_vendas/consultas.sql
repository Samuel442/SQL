USE sales_db;

-- ---------------------
-- Conferindo as tabelas
-- ---------------------
SELECT * FROM FTOPED;
SELECT * FROM DIMFIL;
SELECT * FROM DIMPRD;
SELECT * FROM DIMTETVND;
SELECT * FROM DIMCLIENT;
SELECT * FROM DIMPOD;







-- Precisamos da venda bruta total realizada por estado?
SELECT 
    d.UFTETVND AS estado,
    FORMAT(SUM(VLRVNDEFTFAT), 2, 'pt-BR') AS venda_bruta
FROM 
	FTOPED f
INNER JOIN 
	DIMTETVND d
	ON f.IDTETVND = d.IDTETVND
GROUP BY  
	d.UFTETVND;







-- Receita líquida total realizada por estado?
SELECT
	d.UFTETVND AS estado,
    FORMAT(SUM(VLRRCTLIQ), 2, 'pt-BR') AS receita_liquida
FROM 
	FTOPED f
INNER JOIN 
	DIMTETVND d
	ON f.IDTETVND = d.IDTETVND
GROUP BY 
	d.UFTETVND;








-- Margem bruta total realizada por estado?
SELECT
	d.UFTETVND AS estado,
    FORMAT(SUM(VLRMRGBRT), 2, 'pt-BR') AS margem_bruta
FROM 
	FTOPED f
INNER JOIN 
	DIMTETVND d
	ON d.IDTETVND = f.IDTETVND
GROUP BY 
	d.UFTETVND;










-- Margem de contribuição total realizada por estado?
SELECT
	d.UFTETVND AS estado,
    FORMAT(SUM(VLRMRGCRB), 2, 'pt-BR') AS contribuicao_total
FROM 
	FTOPED f
INNER JOIN 
	DIMTETVND d
	ON f.IDTETVND = d.IDTETVND
GROUP BY 
	d.UFTETVND;








-- Agora os mesmo dados apenas para os estados do Sudeste MG, SP, RJ, ES, os valores devem ser apresentados por estado individualmente?
SELECT
	d.UFTETVND AS estado,
    FORMAT(SUM(VLRVNDEFTFAT), 2, 'pt-BR') AS venda_bruta,
    FORMAT(SUM(VLRRCTLIQ), 2, 'pt-BR') AS receita_liquida,
    FORMAT(SUM(VLRMRGBRT), 2, 'pt-BR') AS margem_bruta,
    FORMAT(SUM(VLRMRGCRB), 2, 'pt-BR') AS contribuicao_total
FROM 
	FTOPED f
INNER JOIN 
	DIMTETVND d
	ON d.IDTETVND = f.IDTETVND
WHERE 
	d.UFTETVND IN ('MG', 'SP', 'RJ', 'ES')
GROUP BY 
	d.UFTETVND;








-- Apresente uma query em SQL que realize o ranqueamento dos estados por valor de venda bruta realizada?
SELECT
	d.UFTETVND AS estado,
    FORMAT(SUM(VLRVNDEFTFAT), 2, 'pt-BR') AS venda_bruta
FROM 
	FTOPED f
INNER JOIN 
	DIMTETVND d
	ON f.IDTETVND = d.IDTETVND
GROUP BY 
	d.UFTETVND
ORDER BY 
	venda_bruta DESC;







-- Quantos clientes distintos que adquiriram o produto de código '1234' dentro do estado da MG?
SELECT
	d.UFTETVND AS estado,
    COUNT(DISTINCT f.IDCLIENT) AS distinto
FROM 
	FTOPED f
INNER JOIN 
	DIMTETVND d
	ON f.IDTETVND = d.IDTETVND
INNER JOIN 
	DIMPRD p
	ON f.IDPRD = p.IDPRD
WHERE 
	d.UFTETVND = 'MG' AND p.CODPRD = '1234';








-- Qual o valor total de venda bruta e quantos clientes distintos totais foram atendidos pelo vendedor “José Maria”?
SELECT 
    FORMAT(SUM(f.VLRVNDEFTFAT), 2, 'pt-BR') AS venda_bruta,
    COUNT(DISTINCT f.IDCLIENT) AS clientes,
    v.NOMVND AS nome_vendedor
FROM 
	FTOPED f
INNER JOIN 
	DIMTETVND v
	ON f.IDTETVND = v.IDTETVND
WHERE 
	v.NOMVND = 'José Maria'
GROUP BY 
	v.NOMVND;








-- Qual o valor total de venda bruta e quantos clientes distintos totais foram atendidos pelo vendedor “José Maria” em vendas realizadas a partir da filial de expedição de código “41”.
SELECT
	FORMAT(SUM(f.VLRVNDEFTFAT), 2, 'pt-BR') AS venda_bruta,
    COUNT(DISTINCT f.IDCLIENT) AS clientes,
    v.NOMVND AS nome_vendedor,
    df.CODFIL AS codigo_filial
FROM 
	FTOPED f
INNER JOIN 
	DIMTETVND v
	ON f.IDTETVND = v.IDTETVND
INNER JOIN 
	DIMFIL df
	ON f.IDFILIAL = df.IDFILIAL
WHERE 
	v.NOMVND = 'José Maria' AND df.CODFIL = '41'
GROUP BY 
	v.NOMVND, df.CODFIL;






-- Qual a venda média dos territórios localizados no estado do “MS”? 
SELECT
	d.UFTETVND AS estado,
    d.IDTETVND AS territorio,
	FORMAT(AVG(f.VLRVNDEFTFAT), 2, 'pt-BR') AS valor_venda_media
FROM
	FTOPED f
INNER JOIN 
	DIMTETVND d
	ON f.IDTETVND = d.IDTETVND
WHERE 
	d.UFTETVND  = 'MS'
GROUP BY 
	d.IDTETVND, d.UFTETVND;







-- Qual o valor de venda total, por cliente, de produtos do fornecedor código “1200” realizada entre os meses de “202501” e “202503”?
SELECT
	FORMAT(SUM(f.VLRVNDEFTFAT), 2, 'pt-BR') AS venda_total,
    f.IDCLIENT AS cliente,
    p.CODFRN AS codigo_fornecedor,
    m.NUMANOMES AS mes
FROM 
	FTOPED f
INNER JOIN 
	DIMPRD p
	ON f.IDPRD = p.IDPRD
INNER JOIN 
	DIMPOD m
	ON f.IDDATA = m.IDDATA
WHERE 
	P.CODFRN = '1200' 
	AND m.NUMANOMES BETWEEN '202501' AND '202503'
GROUP BY 
	IDCLIENT, p.CODFRN, m.NUMANOMES;










-- Qual a quantidade distinta de pedidos realizados com valor de venda bruta maior ou igual a R$100,00?
SELECT
	COUNT( DISTINCT f.NUMPED) AS num_pedidos_distintos
FROM 
	FTOPED f
WHERE 
	VLRVNDEFTFAT >= 100;