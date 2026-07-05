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



/*Perfeito, agora sim estamos falando a mesma língua! Vamos direto para o relatório de relevância dos nossos clientes.
Eu quero cruzar a nossa tabela fato de pedidos com a tabela de clientes. Preciso de uma lista final que traga:
O código do cliente. A Razão Social do cliente.
O valor total faturado acumulado por ele, formatado no nosso padrão de reais (R$).
Uma coluna totalmente nova chamada classificacao_cliente, que vai rotular o parceiro comercial 
seguindo esta regra estrita de negócio baseada na performance total dele:
- Se a soma do faturamento acumulado for maior ou igual a R$ 63.000.000,00, o banco deve escrever: 'Cliente Diamante'.
- Se a soma do faturamento acumulado estiver entre R$ 62.900.000,00 e R$ 62.999.999,99, o banco deve escrever: 'Cliente Ouro'.
- Para qualquer valor abaixo disso, o rótulo deve ser: 'Cliente Prata'.
Ah, e organiza esse relatório mostrando os maiores faturamentos no topo 
da lista (ordem decrescente) para eu bater o olho nos campeões de compra!
*/
SELECT
	CONCAT('R$ ', FORMAT(SUM(f.VLRVNDEFTFAT), 2, 'pt-BR')) AS total_faturado,
	c.CODCLIENT AS codigo_cliente,
    c.NOMRAZSOC AS razao_social,
    CASE
		WHEN SUM(f.VLRVNDEFTFAT) >= 63000000 THEN 'Cliente Diamante'
        WHEN SUM(f.VLRVNDEFTFAT) >= 62900000 AND SUM(f.VLRVNDEFTFAT) <= 6299999999 THEN 'Cliente Ouro'
        WHEN SUM(f.VLRVNDEFTFAT) >  63000000 THEN 'Cliente Diamante'
        ELSE 'Cliente Prata'
	END AS opcoes_performance
FROM 
	FTOPED f
INNER JOIN
	DIMCLIENT c
ON f.IDCLIENT = c.IDCLIENT
GROUP BY
	c.CODCLIENT, 
    c.NOMRAZSOC;
    
    
    
    
    
    
    
    
 /*   
Ficou perfeito esse mapeamento de clientes! Agora que eu sei quem joga no grupo Ouro, 
vamos olhar para as nossas regionais. Para o meu fechamento de planejamento tributário 
e de investimentos das unidades, eu preciso cruzar a nossa tabela fato com a dimensão de filiais.
Monta uma consulta para mim trazendo:
- O código da filial.
- O nome/descrição da filial.
- O valor total de Margem Bruta acumulada acumulado por ela, formatado em reais (R$).
Uma coluna nova chamada status_lucratividade avaliando a saúde financeira da operação:
- Unidades com Margem Bruta acumulada maior ou igual a R$ 21.400.000,00 recebem o rótulo: 'Performance Excelente'.
- Unidades com Margem Bruta acumulada entre R$ 21.300.000,00 e R$ 21.399.999,99 recebem o rótulo: 'Performance Alinhada'.
- Qualquer valor abaixo disso recebe o rótulo: 'Performance Média'.
Organiza a lista colocando a filial com a MAIOR margem no topo (ordem decrescente)
*/
SELECT
	CONCAT('R$ ', FORMAT(SUM(f.VLRMRGBRT), 2, 'pt-BR')) AS margem_bruta_acumulada,
	d.CODFIL AS codigo_filial,
    d.DESFIL AS descricao_filial,
    CASE
		WHEN SUM(f.VLRMRGBRT) >= 21400000 THEN 'Performance Excelente'
        WHEN SUM(f.VLRMRGBRT) >= 21300000 AND SUM(f.VLRMRGBRT) <= 21399999 THEN 'Performance Alinhada'
        WHEN SUM(f.VLRMRGBRT) < 21300000 THEN 'Performance Média'
    END AS status_lucratividade
FROM
	 FTOPED f
INNER JOIN
	DIMFIL d
ON f.IDFILIAL = d.IDFILIAL
GROUP BY
	d.CODFIL,
    d.DESFIL
ORDER BY
	margem_bruta_acumulada DESC;
    
    
    
    
    
    
    
    
    


/*
Espetacular! Que inteligência de dados fantástica estamos construindo aqui.
Agora eu preciso de uma análise de perfil de vendas por vendedor. No nosso mercado, 
um pedido acima de R$ 4.000,00 é considerado um 'Grande Pedido' corporativo, 
enquanto valores iguais ou menores que isso são 'Pequenos Pedidos' de varejo.
Para eu reestruturar as comissões e as metas do time, preciso cruzar a tabela 
fato com a dimensão de vendedores em um relatório consolidado.
Quero que você monte uma consulta que traga uma única linha para cada vendedor contendo:
- O nome do vendedor. Uma coluna nova chamada faturamento_grandes_pedidos: que 
vai somar o faturamento bruto apenas das vendas individuais que foram 
- estritamente maiores que R$ 4.000,00, formatada em reais (R$).
- Uma coluna nova chamada faturamento_pequenos_pedidos: que vai somar o faturamento bruto 
apenas das vendas individuais que foram menores ou iguais a R$ 4.000,00, também formatada em reais (R$).
Para a ordenação, coloque em ordem alfabética pelo nome do vendedor (crescente).
*/
SELECT
	v.NOMVND AS nome_vendedor,
    CONCAT('R$ ', FORMAT(SUM(CASE WHEN f.VLRVNDEFTFAT > 4000 THEN f.VLRVNDEFTFAT ELSE 0 END),2, 'pt-br')) AS faturamento_grandes_pedidos,
    CONCAT('R$ ', FORMAT(SUM(CASE WHEN f.VLRVNDEFTFAT <= 4000 THEN f.VLRVNDEFTFAT ELSE 0 END), 2, 'pt-BR')) AS faturamento_pequenos_pedidos
FROM 
	FTOPED f
INNER JOIN
	DIMTETVND v
ON f.IDTETVND = v.IDTETVND
GROUP BY
	v.NOMVND
ORDER BY
	nome_vendedor ASC;
    
    
    
    
    
    
    
/*
Isso aqui está ficando incrivelmente profissional! Olhar o perfil de 
vendas da equipe aberto em colunas facilitou demais a minha visão estratégica.
Para fechar esse ciclo com chave de ouro e me ajudar a planejar a nossa política 
de preços, eu preciso de um relatório analítico sobre os nossos produtos 
cruzando a tabela fato com a dimensão de produtos.
Nós consideramos um item com preço unitário acima de R$ 30,00 como 
'Produto Premium', e itens com valores iguais ou abaixo disso como 'Produto Standard'.
Quero uma consulta que retorne uma lista contendo:
O código do produto. O nome/descrição do produto.
Uma coluna nova chamada faturamento_premium: que vai somar o faturamento líquido 
acumulado apenas quando o preço unitário do item for maior que R$ 30,00, formatado em reais (R$).
Uma coluna nova chamada faturamento_standard: que vai somar o faturamento líquido acumulado
 apenas quando o preço unitário do item for menor ou igual a R$ 30,00, também formatado em reais (R$).
Organiza essa lista colocando o produto com o MAIOR faturamento premium no topo (ordem decrescente).
*/
SELECT
	p.CODPRD AS codigo_produto,
    p.DESPRD AS descricao_produto,
    CONCAT('R$ ', FORMAT(SUM(CASE WHEN f.VLRRCTLIQ > 30000 THEN f.VLRRCTLIQ ELSE 0 END), 2, 'pt-BR')) AS faturamento_premiun,
    CONCAT('R$ ', FORMAT(SUM(CASE WHEN f.VLRRCTLIQ <= 30000 THEN f.VLRRCTLIQ ELSE 0 END), 2, 'pt-BR')) AS faturamento_standart
FROM 
	FTOPED f
INNER JOIN
	DIMPRD p
ON f.IDPRD = p.IDPRD
GROUP BY
	p.CODPRD,
    p.DESPRD
ORDER BY
	faturamento_premiun DESC;
    
	
    
    
    
    
    
    
    
    
    

/*
O time de auditoria me pediu uma análise urgente de controle de qualidade das nossas 
vendas. Eles querem identificar quais foram as vendas individuais (linhas da tabela fato) 
que saíram totalmente fora da curva média da empresa.
Eu preciso que você puxe da nossa tabela fato de pedidos uma lista contendo:
O número do pedido.
O valor de venda bruta, formatado em reais (R$).
Mas atenção ao filtro: eu não quero ver todas as vendas. Eu só quero que apareçam no relatório 
as linhas cujo valor de venda bruta seja estritamente maior do que a média 
geral de venda bruta de todos os pedidos registrados na nossa história.
Organiza o resultado colocando os maiores valores de pedido no topo (ordem decrescente).
*/
SELECT
	f.NUMPED AS numero_pedido,
    SUM(f.VLRVNDEFTFAT) AS venda_bruta
FROM 
	FTOPED f
WHERE 
	f.VLRVNDEFTFAT > (SELECT AVG(fx.VLRVNDEFTFAT) FROM FTOPED fx)
GROUP BY
	f.NUMPED
ORDER BY
	venda_bruta DESC;
    
    
    
    
    
    
    
    
    
    
/*
Fala, desenvolvedor! Beleza? Cara, nossa reunião com a diretoria é amanhã cedo e eu
preciso desse relatório de representatividade na minha mesa.
Eu quero que você junte a informação de pedidos com a de filiais . O relatório final 
precisa ter as seguintes colunas, com os nomes exatos que eu uso nos meus slides:
codigo_filial.
nome_filial.
faturamento_por_filial, formatado em reais (R$).
faturamento_total_empresa: O faturamento bruto acumulado de todas as filiais juntas na história da empresa, 
também formatado em reais (R$).
Não esquece de trazer esse total geral repetido ao lado de cada filial, e organiza o relatório colocando o maior 
faturamento por filial no topo da lista (ordem decrescente). Manda bala
*/
SELECT
	d.CODFIL AS codigo_filial,
    d.DESFIL AS nome_filial,
    CONCAT('R$ ', FORMAT(SUM(f.VLRVNDEFTFAT),2, 'pt-BR')) AS faturamento_total,
    (SELECT CONCAT('R$ ', FORMAT(SUM(f.VLRVNDEFTFAT), 2, 'pt-BR')) FROM FTOPED f) AS faturamento_total_empresa
FROM 
	FTOPED f
INNER JOIN
		DIMFIL d
	ON f.IDFILIAL = d.IDFILIAL
GROUP BY
	d.CODFIL,
    d.DESFIL
ORDER BY
	SUM(f.VLRVNDEFTFAT) DESC;
    
    
    
    
    
    
    

/*
Excelente! O relatório de representatividade das filiais ficou impecável 
para apresentar à diretoria. Agora eu preciso de uma análise de performance 
focada exclusivamente nos nossos clientes da curva de destaque. Eu quero identificar 
quais clientes compraram um volume muito expressivo na nossa história para traçar uma campanha de fidelidade.
Só que, para não sobrecarregar o relatório, eu preciso de um filtro duplo. Quero que você monte uma consulta 
estruturada onde a origem dos dados (FROM) seja uma tabela virtual que já traga os clientes pré-agrupados 
com seus faturamentos brutos acumulados. Em cima dessa tabela virtual, filtre apenas quem comprou acima de R$ 63.000.000,00.
O relatório final que vai para a minha tela deve conter:
O nome/razão social do cliente.
O faturamento bruto acumulado dele, formatado em reais (R$).
Organiza a lista colocando o maior faturamento no topo (ordem decrescente).
*/
SELECT
	sub_clientes.nome_cliente,
    CONCAT('R$ ', FORMAT(sub_clientes.faturamento_bruto, 2, 'pt-BR')) AS faturamento_formatado
FROM(
	SELECT
		SUM(f.VLRVNDEFTFAT) AS faturamento_bruto,
		c.NOMRAZSOC AS nome_cliente
	FROM
		FTOPED f
	INNER JOIN 
		DIMCLIENT c
	ON f.IDCLIENT = c.IDCLIENT
	GROUP BY
		c.NOMRAZSOC
	) AS sub_clientes
WHERE 
	sub_clientes.faturamento_bruto > 62000000
ORDER BY
	sub_clientes.faturamento_bruto DESC;
    
    
    
    
    
    
    
    
    
    
/*
Sensacional esse relatório dos clientes VIPs! Com 62 milhões como corte, 
pegamos exatamente o nosso 'Top 4' de compradores.
Para fechar as análises desse trimestre, eu preciso mapear a nossa equipe de vendas. 
Eu quero um relatório que liste o faturamento consolidado dos nossos vendedores, 
mas quero comparar cada um deles contra uma meta interna muito específica.
Monte uma consulta que traga:
O nome do vendedor (v.NOMVND) vindo da dimensão DIMTETVND.
O faturamento total acumulado dele, formatado em reais (R$).
Uma coluna calculada chamada meta_vendas_geral: que deve exibir, ao lado de cada vendedor, 
o valor correspondente a 10% de todo o faturamento histórico da empresa, formatado em reais (R$).
Filtro de Elite: No relatório final, use uma subquery para garantir que apareçam apenas os 
vendedores cujo faturamento próprio superou essa meta de 10% global. Organiza do maior faturamento para o menor
*/
SELECT
	v.NOMVND AS nome_vendedor,
    CONCAT('R$ ', FORMAT(SUM(f.VLRVNDEFTFAT), 2, 'pt-BR')) AS faturamento_bruto,
    CONCAT('R$ ', FORMAT((SELECT SUM(f.VLRVNDEFTFAT) * 0.10 FROM FTOPED f), 2, 'pt-BR')) AS meta_vendas_geral
FROM 
	FTOPED f
INNER JOIN
	DIMTETVND v
ON v.IDTETVND = f.IDTETVND
GROUP BY
	v.NOMVND
HAVING 
	SUM(f.VLRVNDEFTFAT) > (SELECT SUM(f.VLRVNDEFTFAT) * 0.10 FROM FTOPED f)
ORDER BY
	SUM(f.VLRVNDEFTFAT) DESC;
    
    
    
    
    
    
    
    
    
    
    
    
/*
Perfeito! Já que a nossa dimensão de tempo DIMPOD guarda o período no formato NUMANOMES 
(ex: 202501), monte a consulta fazendo o INNER JOIN entre a fato FTOPED f e a DIMPOD p através do IDDATA.
Quero no relatório:
O número do pedido (f.NUMPED).
O código do período original (p.NUMANOMES).
Uma coluna chamada ano_faturamento: extraindo apenas os 4 primeiros dígitos de p.NUMANOMES.
Uma coluna chamada mes_faturamento: extraindo apenas os 2 últimos dígitos de p.NUMANOMES.
Filtro: Traga apenas as vendas onde os 4 primeiros dígitos do período indiquem o ano de 2025. Limite a 10 linhas.
*/
SELECT
	f.NUMPED AS numero_pedido,
    d.NUMANOMES AS periodo,
    LEFT(d.NUMANOMES, 4) AS ano_faturamento,
    RIGHT(d.NUMANOMES, 2) AS mes_faturamento
FROM
	FTOPED f
INNER JOIN 
	DIMPOD d
ON f.IDDATA = d.IDDATA
WHERE
	LEFT(d.NUMANOMES, 4) = 2025
GROUP BY
	f.NUMPED,
    d.NUMANOMES
LIMIT 10;










/*
Ficou ótimo o relatório de períodos! Agora, a nossa equipe de expedição precisa organizar 
as rotas de entrega com base no cadastro de clientes (DIMCLIENT) e territórios (DIMTETVND).
O problema é que o sistema legado salvou os nomes das razões sociais dos clientes em caixa 
alta misturada, e precisamos padronizar essa exibição, além de criar uma classificação regional rápida para os motoristas.
Eu preciso de um relatório contendo:
O nome do vendedor responsável (v.NOMVND).
O estado (UF) do território (v.UFTETVND).
Uma coluna chamada cliente_padronizado: exibindo a razão social do cliente (c.NOMRAZSOC) 
convertida totalmente para letras minúsculas (caixa baixa), para facilitar um processo posterior de higienização de dados.
Uma coluna chamada regiao_entrega: usando uma regra condicional baseada na sigla do estado (v.UFTETVND). A regra deve ser:
Se a UF for 'SP', exiba 'Estado Sede'.
Se a UF for 'RJ' ou 'MG', exiba 'Sudeste Satélite'.
Para qualquer outro estado (UF) que aparecer, exiba 'Demais Regiões'.
Filtros e Ordenação: Traga apenas as linhas onde o faturamento bruto (f.VLRVNDEFTFAT) tenha sido maior 
do que zero. Ordene o relatório pelo nome do vendedor de forma alfabética (A-Z) e limite o resultado final em 15 linhas
*/
SELECT
	v.NOMVND AS nome_vendedor,
    v.UFTETVND AS estado_territorio,
    LOWER(d.NOMRAZSOC) AS cliente_padronizado,
    CASE 
		WHEN v.UFTETVND = 'SP' THEN 'Estado Sede'
        WHEN v.UFTETVND = 'RJ' OR v.UFTETVND = 'MG' THEN 'Sudeste Satélite' 
        ELSE 'Demais Regiões'
	END AS regiao_entrega
FROM 
	FTOPED f
INNER JOIN
	DIMTETVND v
ON f.IDTETVND = v.IDTETVND
INNER JOIN 
	DIMCLIENT d
ON f.IDCLIENT = d.IDCLIENT
WHERE 
	f.VLRVNDEFTFAT > 0
ORDER BY
	nome_vendedor ASC
LIMIT 10;












/*
Excelente! A equipe de rotas adorou a padronização regional. 
Agora temos um problema crítico no fechamento financeiro de margens.
Algumas linhas da tabela fato FTOPED foram integradas sem o cálculo da Margem de 
Contribuição (f.VLRMRGCRB). Quando o campo está vazio (NULL), o relatório do nosso 
diretor financeiro quebra, pois ele não consegue somar valores nulos.
Eu preciso de um relatório de auditoria que traga:
O número do pedido (f.NUMPED).
O valor da receita líquida (f.VLRRCTLIQ).
O valor original da margem de contribuição (f.VLRMRGCRB).
Uma coluna calculada chamada margem_corrigida: se o valor original for nulo (NULL), 
exiba o número 0.00. Se ele não for nulo, exiba o próprio valor original.
Filtro de Exceções: Para o relatório ser útil, traga apenas os pedidos onde o valor 
original da margem de contribuição (f.VLRMRGCRB) seja de fato nulo (NULL). Limite o resultado em 10 linhas.
*/
SELECT
	f.NUMPED AS numero_pedido,
    f.VLRRCTLIQ AS receita_liquida,
    f.VLRMRGCRB AS margem_contribuicao,
    IFNULL(f.VLRMRGCRB, 0.00) AS margem_corrigida
FROM 
	FTOPED f
WHERE f.VLRMRGCRB IS NULL
LIMIT 10;











/*
Temos um problema operacional gravíssimo acontecendo no galpão. 
Alguns produtos estão sendo vendidos na tabela fato (FTOPED), 
mas o time de separação não consegue localizá-los porque eles 
parecem não existir ou perderam o vínculo com a tabela de produtos (DIMPRD).
Eu preciso de um relatório de auditoria de cadastro para mapear esse gargalo imediatamente.
Quero que você liste:
O ID do produto registrado no pedido (f.IDPRD).
O número do pedido (f.NUMPED).
A descrição do produto vinda do cadastro (p.DESPRD).
O código do fornecedor (p.CODFRN).
A Regra de Ouro: Eu quero ver todos os registros de vendas da tabela fato, 
independentemente de o produto estar cadastrado ou não na DIMPRD. 
Se houver alguma venda com um IDPRD fantasma (que não existe na dimensão), 
a descrição do produto deverá aparecer vazia (NULL). Ordene pelo número do pedido e limite a 15 linhas.
*/
SELECT
	f.IDPRD AS id_produto,
    f.NUMPED AS numero_pedido,
    p.DESPRD AS descricao_produto,
    p.CODFRN AS codigo_fornecedor
FROM
	FTOPED f
LEFT JOIN    
    DIMPRD p
ON f.IDPRD = p.IDPRD
ORDER BY
	f.NUMPED ASC
LIMIT 15;











/*
Excelente relatório, fico aliviado em ver que esses primeiros pedidos estão com 
o cadastro em dia! Agora eu preciso de uma visão macro de inteligência de mercado sobre os nossos produtos.
O time de compras quer analisar os extremos e a média de desempenho das vendas de mercadorias na tabela fato FTOPED.
Eu preciso de uma consulta que me devolva uma única linha contendo:
Uma coluna chamada maior_venda: exibindo o maior valor de venda unitária registrado na coluna f.VLRVNDEFTFAT.
Uma coluna chamada menor_venda: exibindo o menor valor de venda unitária registrado na coluna f.VLRVNDEFTFAT.
Uma coluna chamada media_faturamento: exibindo a média aritmética de faturamento de todos os nossos pedidos.
Filtro Operacional: Como valores zerados distorcem a média real, traga essa análise considerando apenas os 
registros onde o valor de venda (f.VLRVNDEFTFAT) seja maior do que R$ 100,00.
*/
SELECT
	CONCAT('R$ ', FORMAT(MAX(f.VLRVNDEFTFAT), 2, 'pt-BR')) AS maior_venda,
    CONCAT('R$', FORMAT(MIN(f.VLRVNDEFTFAT), 2, 'pt-BR')) AS menor_venda,
    CONCAT('R$' , FORMAT(AVG(f.VLRVNDEFTFAT), 2, 'pt-BR')) AS media_venda
FROM 
	FTOPED f
WHERE
	f.VLRVNDEFTFAT > 100;
    
    
    
    
    
    
    
    
    
    
    
    
    
/*
Excelente painel estatístico! Agora, o pessoal do setor de compras precisa de 
uma listagem específica de fornecedores para renegociar contratos de uma categoria de produtos.
Nós temos uma linha de produtos focada em vestuário e itens infantis na tabela DIMPRD, 
e eu preciso mapear quais fornecedores atendem a essa demanda.
Eu preciso de um relatório que liste:
O código do fornecedor (p.CODFRN).
A descrição/nome do fornecedor (p.DESFRN).
A descrição do produto (p.DESPRD).
O Filtro por Padrão de Texto: Não quero olhar a tabela inteira. O relatório deve 
trazer apenas os registros onde a descrição do produto (p.DESPRD) contenha a palavra 
'FRALDA' em qualquer parte do texto. Ordene o resultado pela descrição do produto de forma alfabética (A-Z)
*/
SELECT
	p.CODFRN AS codigo_fornecedor,
    p.DESFRN AS nome_fornecedor,
    p.DESPRD AS descricao_produto
FROM
	DIMPRD p
WHERE 
	p.DESPRD LIKE '%FRALDA%'
ORDER BY
	p.DESPRD ASC;
    
    
    
    
    
    
    
    
/*
"Que excelente jornada! Chegamos ao último relatório estratégico para fechar a nossa auditoria de força de vendas.
A diretoria precisa de um relatório consolidado que cruze as informações de vendas dos territórios (DIMTETVND) com
 o faturamento da fato (FTOPED), mas com regras de corte combinadas bem rígidas.
Eu preciso de um relatório contendo:
O nome do vendedor (v.NOMVND).
O estado/território (v.UFTETVND).
O faturamento bruto de cada um formatado em reais com duas casas decimais (faturamento_bruto).
Os Critérios de Filtro Combinados (WHERE / HAVING):
Regra 1: Só quero ver no relatório os vendedores cuja sigla do estado (v.UFTETVND) seja 'SP' OU 'MG'.
Regra 2: O faturamento agrupado do vendedor deve ser estritamente maior do que a média de faturamento
 geral de toda a tabela fato (Dica: use uma subquery com AVG(VLRVNDEFTFAT) para calcular essa média global).
Ordenação: Ordene o resultado final de forma mista: primeiro pelo estado (A-Z) e, caso haja empate de estado, 
pelo faturamento bruto de forma decrescente (do maior para o menor).
*/
SELECT
	CONCAT('R$ ', FORMAT(SUM(f.VLRVNDEFTFAT), 2, 'pt-BR')) AS faturamento_bruto,
	v.NOMVND AS nome_vendedor,
    v.UFTETVND AS estado_territorio
FROM 
	FTOPED f
INNER JOIN
	DIMTETVND v
ON f.IDTETVND = v.IDTETVND
WHERE
	v.UFTETVND IN('SP', 'MG')
GROUP BY
	v.NOMVND,
    v.UFTETVND
HAVING
	SUM(f.VLRVNDEFTFAT) > (SELECT AVG(fx.VLRVNDEFTFAT) FROM FTOPED fx)
ORDER BY
	v.UFTETVND ASC,
    SUM(f.VLRVNDEFTFAT) DESC;
