-- Conecta no banco antes de rodar a estrutura
USE EV_BYD_Motors;


/*
"Preciso de uma auditoria de sincronia entre os nossos Vendedores e os nossos Clientes.
*Quero um relatório que liste o Nome do Vendedor e o Nome do Cliente.
Atenção ao critério: O relatório deve trazer absolutamente tudo, sem perder nenhum dado:
Todos os Vendedores (mesmo os que ainda não registraram vendas para nenhum cliente).
Todos os Clientes (mesmo os que ainda não foram atendidos por nenhum vendedor).
Onde houver vínculo, mostre a relação; onde não houver, deixe o campo nulo do lado correspondente."
*/
SELECT
	v.nome_vendedor AS nome_vendedor,
    c.nome_cliente AS nome_cliente
FROM
	dim_vendedor v
LEFT JOIN
	fato_vendas f
ON f.fk_vendedor = v.sk_vendedor
LEFT JOIN
	dim_cliente c
ON f.fk_cliente = c.sk_cliente

UNION

SELECT
	v.nome_vendedor AS nome_vendedor,
    c.nome_cliente AS nome_cliente
FROM
	dim_vendedor v
RIGHT JOIN
	fato_vendas f
ON f.fk_vendedor = v.sk_vendedor
RIGHT JOIN
	dim_cliente c
ON f.fk_cliente = c.sk_cliente;










/*
"Preciso de uma auditoria de sincronia entre os nossos Vendedores e os nossos 
Clientes através da nossa tabela de movimentação. Quero uma listagem consolidada 
que traga todos os vendedores (mesmo os sem vendas) e todos os clientes 
(mesmo os que ainda não compraram), unindo essas duas visões em um único 
relatório para identificar órfãos de ambos os lados."
*/
SELECT
	v.nome_vendedor AS nome_vendedor,
    c.nome_cliente AS nome_cliente
FROM
	dim_vendedor v
LEFT JOIN
	fato_vendas f
ON f.fk_vendedor = v.sk_vendedor
LEFT JOIN
	dim_cliente c
ON f.fk_cliente = c.sk_cliente

UNION

SELECT
	v.nome_vendedor AS nome_vendedor,
    c.nome_cliente AS nome_cliente
FROM
	dim_cliente c
LEFT JOIN	
	fato_vendas f
ON f.fk_cliente = c.sk_cliente
LEFT JOIN
	dim_vendedor v
ON f.fk_vendedor = v.sk_vendedor;















/*
"Preciso saber quantas combinações possíveis temos hoje entre a nossa 
equipe de vendas e o portfólio de veículos.
Quero uma listagem com todos os vendedores e todos os modelos de veículos 
(tabela dim_modelo_veiculo), gerando todas as combinações possíveis. 
Não quero filtros de 'quem já vendeu o quê', quero o universo total 
de possibilidades para eu definir metas de especialização."
*/
SELECT
	v.nome_vendedor AS nome_vendedor,
    m.nome_modelo AS nome_modelo
FROM
	dim_vendedor v
CROSS JOIN
	dim_modelo_veiculo m;
    
    
    
    
    
    
    
    
    
    
/*
"Preciso de um planejamento de capacidade. Quero uma tabela que cruze todos 
os nossos Pátios de Estoque com todos os Modelos de Veículos que a BYD produz.
Isso vai me permitir criar uma 'tabela mestre' de alocação, onde eu poderei 
inserir manualmente o limite de estoque para cada modelo em cada pátio."
*/
SELECT
	p.cidade_planta AS cidade_planta,
    m.nome_modelo AS nome_modelo
FROM
	dim_planta p
CROSS JOIN
	dim_modelo_veiculo m;
    
    
    
    
    
    
    
    
    
    
/*
"Preciso de uma visão clara da nossa cadeia de comando. Gere um relatório onde 
cada vendedor apareça ao lado do seu respectivo gestor. Se o vendedor for o 
'Topo da Hierarquia' (não tiver gestor), tudo bem, ele deve aparecer mesmo assim."
*/
SELECT
	v.nome_vendedor AS nome_vendedor,
    g.nome_vendedor AS nome_gestor
FROM
	dim_vendedor v
LEFT JOIN
	dim_vendedor g
ON g.cargo LIKE '%Gerente%';







/*
"Preciso de um ranking dos nossos vendedores baseado no 
total de vendas. Quem são os nossos TOP 3 vendedores?"
*/
SELECT
	v.nome_vendedor AS nome_vendedor,
    CONCAT('R$ ',FORMAT(SUM(f.receita_bruta), 2, 'pt-BR')) AS receita_bruta,
    RANK() OVER(
			ORDER BY(
				SUM(f.receita_bruta)
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
"Preciso identificar quais são as linhas de produção que estão gerando mais defeitos. 
Quero um ranking das 5 linhas que possuem o maior número de defeitos registrados na qualidade."
*/
SELECT
	d.nome_defeito AS nome_defeito,
    SUM(f.quantidade_defeitos) AS quantidade_defeitos,
    RANK() OVER(
			ORDER BY(
				SUM(f.quantidade_defeitos)
            ) DESC
    ) AS ranking
FROM
	fato_qualidade f
INNER JOIN
	dim_defeito d
ON f.fk_defeito = d.sk_defeito
GROUP BY
	d.nome_defeito;
    
    
    
    
    
    
    
    
    
    
/*
"Esqueça o volume total por um momento. Quero saber quais defeitos estão 
parando a nossa linha de produção com mais frequência. Faça um ranking 
baseado na quantidade de vezes que cada tipo de defeito apareceu na tabela qualidade."
*/
SELECT
	d.nome_defeito AS nome_defeito,
    COUNT(*) AS quantidade_defeitos,
    RANK() OVER(
			ORDER BY(
				COUNT(f.quantidade_defeitos)
            )
    ) AS ranking
FROM
	fato_qualidade f
INNER JOIN
		dim_defeito d
ON f.fk_defeito = d.sk_defeito
GROUP BY
		d.nome_defeito;












/*
Estou vendo furos no nosso relatório. O pessoal da TI me disse que os 
vendedores que ainda não bateram metas nem aparecem na lista. Preciso 
de um ranking completo: quero todos os nomes da dim_vendedor, mesmo 
os que não venderam nada. Se não tem venda, quero o valor zerado no ranking
*/
SELECT
	d.nome_vendedor AS nome_vendedor,
    COUNT(fk_vendedor) AS quantidade_vendida,
    RANK() OVER(
			ORDER BY(
				COUNT(fk_vendedor)
            ) DESC
    ) AS ranking
FROM
	dim_vendedor d
LEFT JOIN
	fato_vendas f
ON f.fk_vendedor = d.sk_vendedor
GROUP BY
	d.nome_vendedor;
    
    
    
    
    
    
    
    
    
    
    
/*
"Precisamos saber a saúde do nosso estoque. Quero um ranking dos produtos com 
maior quantidade armazenada. Se um produto não tiver nenhum registro de estoque, 
ele precisa aparecer na lista com zero para a gente identificar o que está parado ou sem gestão."
*/    
SELECT
	d.nome_produto AS nome_produto,
    COALESCE(SUM(quantidade_disponivel),0) AS quantidade_disponivel,
    RANK() OVER(
			ORDER BY(
				SUM(quantidade_disponivel)
            ) DESC
	) AS ranking
FROM
	dim_produto d
LEFT JOIN
	fato_estoque f
ON f.fk_produto = d.sk_produto
GROUP BY
	d.nome_produto;