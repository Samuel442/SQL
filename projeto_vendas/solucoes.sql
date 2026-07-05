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

/*
O pessoal do estoque está perdido com o catálogo novo. 
Preciso de uma lista simples na minha mesa contendo o 
código e o nome de todos os produtos que a gente 
comercializa. Consegue puxar isso rápido?
*/
SELECT 
	CODPRD AS codigo_produto,
    DESPRD AS descricao_produto
FROM 
	DIMPRD;




/*
Cara, a nossa equipe de marketing vai disparar uma campanha pesada 
focada no estado de São Paulo no mês que vem. Mas antes de aprovar 
a verba, eu preciso entender como está dividida a nossa cobertura 
por lá. Puxa para mim uma lista com tudo o que a gente tem cadastrado 
no sistema sobre as nossas áreas e regiões de vendas que ficam 
especificamente em 'SP'.
*/
SELECT
	d.UFTETVND AS estado,
    d.DESTETVND AS descricao_territorio,
    d.NOMVND AS nome_vendedor
FROM 
	DIMTETVND d
WHERE 
	d.UFTETVND = 'SP';



/*
Cara, a Ana Julia está fazendo um trabalho incrível em São Paulo, 
mas eu quero descobrir quem são os outros tubarões da nossa equipe. 
Estou montando uma premiação de destaque para quem fecha contratos de peso. 
Puxa para mim uma lista com o número de identificação de cada venda e o 
valor total que entrou nela. Mas atenção: para não poluir a lista com venda 
pequena, só me mostra aquelas vendas realmente gigantes, que sozinhas 
bateram ou passaram de R$ 5.000,00.
*/
SELECT
	f.NUMPED AS identificacao_venda,
    FORMAT(SUM(f.VLRVNDEFTFAT), 2, 'pt-BR') AS valor_venda
FROM 
	FTOPED f
GROUP BY 
	f.NUMPED
HAVING 
	SUM(f.VLRVNDEFTFAT) >= 5000;



/*
Cara, estou revisando os nossos relatórios e notei que algumas vendas 
saíram com valor zerado ou negativo por erro de digitação do sistema 
antigo. Eu preciso que você me traga uma lista com o número de todos 
os pedidos e o valor deles, mas ignore completamente qualquer linha 
de venda que seja menor ou igual a zero. Não quero ponta de erro no 
meu relatório, só o que for valor positivo real!"
*/
SELECT
	f.NUMPED AS numero_pedido,
    f.VLRVNDEFTFAT AS valor_pedido
FROM 
	FTOPED f
WHERE 
	f.VLRVNDEFTFAT > 0;




/*
Perfeito, os erros sumiram! Agora eu preciso de um dado consolidado 
para o fechamento de metas. Eu quero ver o faturamento total acumulado 
de cada um dos nossos pedidos. Mas atenção: para eu focar minha atenção 
apenas no que realmente move o ponteiro da empresa, só me mostra na 
lista aqueles pedidos cujo valor final somado tenha passado de R$ 5.000,00.
*/
SELECT
	FORMAT(SUM(f.VLRVNDEFTFAT), 2, 'pt-BR') AS faturamento_total,
    f.NUMPED AS numero_pedido
FROM
	FTOPED f
GROUP BY 
	f.NUMPED
HAVING 
	SUM(f.VLRVNDEFTFAT) > 5000;
    
    



/*
Espetacular! Com essa lista de pedidos acima de 5 mil eu já consigo falar 
com a contabilidade. Para fechar esse levantamento com chave de ouro, 
preciso cruzar duas regras. Quero ver o faturamento total acumulado por 
pedido, mas apenas para as vendas que aconteceram no estado de 'SP'. 
E tem o mesmo detalhe de antes: no resultado final, só me mostra os 
pedidos que, somados, passaram de R$ 5.000,00.
*/
SELECT
	FORMAT(SUM(f.VLRVNDEFTFAT), 2, 'pt-BR') AS faturamento_total,
    f.NUMPED AS numero_pedido,
    d.UFTETVND AS estado
FROM
	FTOPED f
INNER JOIN 
	DIMTETVND d
	ON f.IDTETVND = d.IDTETVND
WHERE 
	d.UFTETVND = 'SP'
GROUP BY 
	f.NUMPED
HAVING 
	SUM(f.VLRVNDEFTFAT) > 5000;
    
    
    
    
    
    
    
/*
Cara, que orgulho ver esses relatórios saindo redondos! Agora eu preciso 
de uma análise extremamente estratégica para apresentar na reunião de amanhã com os diretores.
Eu quero ver o total faturado por pedido, mas a nossa auditoria impôs uma série de travas:
Só me importam as vendas que aconteceram especificamente no estado de 'SP' (São Paulo).
Quero analisar apenas uma categoria específica de produto: precisamos olhar exclusivamente 
para os produtos fornecidos pelo código de fornecedor '1200'.
Para fechar, no resultado na minha tela, só quero ver os pedidos cujo faturamento final somado 
tenha passado de R$ 2.000,00 para essa combinação.
Me traz uma lista mostrando o número do pedido, o nome do fornecedor (ou código), o estado e o valor total somado deles?
*/
SELECT
	FORMAT(SUM(f.VLRVNDEFTFAT), 2, 'pt-BR') AS total_faturado,
    f.NUMPED AS numero_pedido,
    e.UFTETVND AS estado,
    p.CODFRN AS codigo_fornecedor
FROM 
	FTOPED f
INNER JOIN 
	DIMTETVND e
	ON f.IDTETVND = e.IDTETVND
INNER JOIN 
	DIMPRD p
	ON p.IDPRD = f.IDPRD
WHERE 
	e.UFTETVND = 'SP' AND
    p.CODFRN = '1200'
GROUP BY
	f.NUMPED,
    e.UFTETVND,
    p.CODFRN
HAVING 	
	SUM(f.VLRVNDEFTFAT) > 2000;
    
    




/*
Puxa para mim no banco: quantos clientes únicos e diferentes
nós temos cadastrados no sistema que já realizaram 
pelo menos uma compra com a gente?
*/
SELECT
	COUNT(DISTINCT f.IDCLIENT) AS clientes_distintos
FROM 
	FTOPED f;








/*
Quero ver o valor total que cada um daqueles clientes compradores 
gastou acumulado na nossa empresa. Me traz uma lista com a identificação 
do cliente ordenado do menor identificador até o maior, com a razão social
e o valor total acumulado dele?
*/
SELECT
	f.IDCLIENT AS cliente,
    FORMAT(SUM(f.VLRVNDEFTFAT),2, 'pt-BR') AS venda_total,
    c.NOMRAZSOC AS razao_social
FROM 
	FTOPED f
INNER JOIN 
	DIMCLIENT c
ON f.IDCLIENT = c.IDCLIENT
GROUP BY
	f.IDCLIENT, 
    c.NOMRAZSOC
ORDER BY f.IDCLIENT ASC;



/*
Incrível! Olhar para os nomes das empresas em vez de números mudou completamente 
o cenário. Agora sim eu sei quem é quem.Para fechar o meu planejamento estratégico 
da campanha de marketing regional direcionada, preciso do último filtro: 
qual é o valor total acumulado que cada um desses mesmos clientes gastou 
comprando apenas no estado de 'SP'? > Me traz essa mesma lista com o ID, 
o Nome da Razão Social e a soma dos valores, mantendo a ordenação por ID, 
mas considerando exclusivamente as vendas do mercado paulista!
*/
SELECT
	f.IDCLIENT AS id_cliente,
    FORMAT(SUM(f.VLRVNDEFTFAT), 2, 'pt-BR') AS venda_total,
    c.NOMRAZSOC AS razao_social,
    e.UFTETVND AS estado
FROM
	FTOPED f
INNER JOIN 
	DIMCLIENT c
ON f.IDCLIENT = c.IDCLIENT
INNER JOIN 
	DIMTETVND e
ON f.IDTETVND = e.IDTETVND
WHERE 
	e.UFTETVND = 'SP'
GROUP BY 
	f.IDCLIENT, 
    c.NOMRAZSOC, 
    e.UFTETVND
ORDER BY 
	f.IDCLIENT ASC;
	
    
    
    



/*
Sensacional! Esse dado de que só a Mercearia do Bairro compra em SP
 vai mudar completamente o direcionamento da nossa verba de marketing.
Agora, saindo um pouco do foco de clientes e olhando para a performance
 do nosso time de vendas... Eu preciso avaliar a nossa equipe de campo. 
 Puxa para mim no sistema: qual é o valor do MAIOR pedido de venda 
 (o recorde) e qual é o valor do MENOR pedido de venda já registrado 
 em toda a história da nossa empresa?
*/
SELECT
	FORMAT(MAX(f.VLRVNDEFTFAT), 2, 'pt-BR') AS maior_valor,
    FORMAT(MIN(f.VLRVNDEFTFAT), 2, 'pt-BR') AS menor_valor
FROM 
	FTOPED f;
    
    
    
    
    
    
    
/*
Sensacional ver esses limites! Saber que nosso maior pedido bateu 
a casa dos 5 mil ajuda a entender nosso teto atual. Agora, preciso 
de uma informação de média para calibrar o faturamento esperado do próximo mês.
Faz o seguinte para mim: qual é o valor MÉDIO dos pedidos de venda que nós 
faturamos na história da empresa? Mas atenção, para não distorcer a nossa 
realidade para baixo, calcula essa média apenas para os pedidos 
que aconteceram no estado de 'SP'
*/
SELECT
	FORMAT(AVG(f.VLRVNDEFTFAT), 2, 'pt-BR') AS media_vendas,
    e.UFTETVND AS estado
FROM 
	FTOPED f
INNER JOIN 
	DIMTETVND e
ON f.IDTETVND = e.IDTETVND
WHERE 
	e.UFTETVND = 'SP'
GROUP BY 
	e.UFTETVND;
    
    
    
    
    


/*
Espetacular! Com essa média de 2,5k em SP eu consigo desenhar 
a projeção do mês que vem com os pés no chão.Agora, saindo de 
territórios e entrando no nosso catálogo de mercadorias... Eu 
preciso entender quais são os produtos mais populares e que 
mais geram volume de transações para o nosso estoque.
Faz um levantamento para mim: quantas vezes cada produto foi vendido 
na história da empresa? Eu quero ver uma lista contendo o código de 
identificação do produto e a quantidade total de vezes (o volume de pedidos) 
que ele apareceu nas nossas vendas. Ah, e organiza a lista mostrando do 
produto mais vendido (com maior número de saídas) até o menos vendido, 
por favor!
*/
SELECT
	COUNT(f.NUMPED) AS quantidade_vendas,
    p.CODPRD AS codigo_produto
FROM
	FTOPED f
INNER JOIN 
	DIMPRD p
ON f.IDPRD = p.IDPRD
GROUP BY
	p.CODPRD
ORDER BY
	 COUNT(f.NUMPED) DESC;
    
    
    
    
    
    
    
    
    

/*
Excelente ver que nosso estoque roda de forma tão equilibrada com 25 
mil saídas para cada produto! Agora, para fechar a análise do nosso 
catálogo de mercadorias, eu preciso cruzar duas informações financeiras 
cruciais. Faz um relatório para mim: qual é o valor total faturado 
acumulado e qual é a média de valor por pedido para cada um dos 
produtos da nossa empresa? Quero ver uma lista contendo o código 
do produto, a soma total das vendas dele e a média das vendas dele. 
Ah, e coloca esses dois valores monetários formatados lindamente no 
padrão do Brasil (pt-BR) com o cifrão (R$) integrado no 
texto para eu apresentar direto na reunião de amanhã!
*/
SELECT 
	CONCAT('R$',FORMAT(SUM(f.VLRVNDEFTFAT), 2, 'pt-BR')) AS total_vendas,
    CONCAT('R$',FORMAT(AVG(f.VLRVNDEFTFAT), 2, 'pt-BR')) AS media_vendas,
    p.CODPRD AS codigo_produto
FROM 
	FTOPED f
INNER JOIN 
	DIMPRD p
ON f.IDPRD = p.IDPRD
GROUP BY
    p.CODPRD;
    
    
    
    




/*
Vamos olhar para a nossa estrutura de distribuição física 
que faz muito mais sentido para a logística agora.
Faz o levantamento para mim: qual é o valor total acumulado que 
nós faturamos por Filial de Expedição na história da nossa empresa? >
Eu quero ver uma lista contendo o Nome/Descrição da Filial 
e a respectiva soma das vendas. Ah, e organiza essa lista 
mostrando da filial que mais faturou  até a que menos 
faturou, mantendo aquele padrão visual em reais (R$) que ficou sensacional!
*/
SELECT
	CONCAT('R$ ', FORMAT(SUM(f.VLRVNDEFTFAT), 2, 'pt-BR')) AS faturamento_total,
    d.DESFIL AS nome_filial,
    d.CODFIL AS codigo_filial
FROM
	FTOPED f
INNER JOIN 
	DIMFIL d
ON f.IDFILIAL = d.IDFILIAL
GROUP BY
	d.DESFIL,
	d.CODFIL
ORDER BY
	faturamento_total DESC;
    
    
    
    
    
    
    
    
/*
Espetacular! Ver a Matriz de Uberlândia no topo do faturamento bruto me dá 
uma visão clara de volume. Mas agora eu preciso de uma resposta mais 
profunda para a reunião de diretoria. Faturamento bruto é ótimo, mas o que 
põe dinheiro no bolso da empresa de verdade é a Margem Bruta. Às vezes, uma 
filial vende muito volume, mas dá descontos agressivos e entrega pouca margem.
Faz um novo levantamento para mim baseado no mesmo relatório anterior: qual é o 
valor total de MARGEM BRUTA acumulada por cada uma das nossas Filiais de Expedição?
Quero a mesma estrutura de lista (Nome da Filial, Código e a Margem formatada em reais), 
mas dessa vez, em vez de somar o faturamento, some a coluna de margem bruta (VLRMRGBRT). 
Ah, e ordene o ranking mostrando da filial que trouxe a MAIOR margem para a menor!
*/
SELECT
	CONCAT('R$ ', FORMAT(SUM(f.VLRMRGBRT), 2, 'pt-BR')) AS margem_bruta,
    d.DESFIL AS nome_filial,
    d.CODFIL AS codigo_filial
FROM
	FTOPED f
INNER JOIN 
	DIMFIL d
ON f.IDFILIAL = d.IDFILIAL
GROUP BY
	d.DESFIL,
    d.CODFIL
ORDER BY
	margem_bruta DESC;
    
    
    
    
    
    
    
    
    
    
/*
Cair para trás aqui com esse dado da Bahia! Que paulada na Matriz! 
O pessoal de Uberlândia está dando desconto demais, vou ter que intervir 
nessa equipe urgentemente. Obrigado por me abrir os olhos!
Agora que mapeamos as filiais, quero olhar para o desempenho individual dos 
nossos vendedores de campo. Puxa para mim: qual é o valor total de 
Receita Líquida acumulada que cada vendedor trouxe para a empresa?
Eu quero ver o Nome do Vendedor e a soma da receita líquida (coluna VLRRCTLIQ na tabela fato). 
Mostra para mim em ordem alfabética pelo nome do vendedor, mantendo a nossa formatação 
padrão em reais (R$). Quero ver a lista organizada de 'A' a 'Z'!
*/
SELECT
	CONCAT('R$ ', FORMAT(SUM(f.VLRRCTLIQ),2 , 'pt-BR')) AS receita_liquida,
    v.NOMVND AS vendedor
FROM 
	FTOPED f
INNER JOIN
	DIMTETVND v
ON v.IDTETVND = f.IDTETVND
GROUP BY
	v.NOMVND
ORDER BY
	vendedor ASC;
    
    
    
    
    
    
    
    
/*
Espetacular! Ver a receita líquida dos nossos quatro vendedores tão equilibrada 
na casa dos 53 milhões é uma surpresa e tanto. Que time consistente!
Mas, para eu fechar a avaliação de desempenho anual da equipe de campo para a diretoria, 
preciso da mesma virada de chave que fizemos com as filiais. Receita é vaidade, o que 
importa é a margem que sobra. Faz um levantamento para mim: qual é o valor total de Margem 
de Contribuição acumulada que cada vendedor trouxe para o negócio?
Quero ver uma lista contendo o Nome do Vendedor e a respectiva soma da margem de 
contribuição. Ah, e para essa visão de performance, 
organiza o ranking mostrando do vendedor que trouxe a MAIOR margem
até o que trouxe a menor, mantendo a nossa formatação de reais (R$).
*/
SELECT
	CONCAT('R$ ', FORMAT(SUM(f.VLRMRGCRB), 2, 'pt-BR')) AS margem_contribuicao_total,
    v.NOMVND AS vendedor
FROM
	FTOPED f
INNER JOIN
	DIMTETVND v
ON v.IDTETVND = f.IDTETVND
GROUP BY
	v.NOMVND
ORDER BY
	margem_contribuicao_total DESC;
    
    
    
    
    
    
    
    
    
    
    


/*
Espetacular! Que disputa acirrada entre a Ana Julia e o Carlos Eduardo, 
separados por apenas cinco mil reais de margem! Esse relatório coroou o 
desempenho da nossa equipe. Para fecharmos esse pacote de análises 
históricas com chave de ouro e eu ir para a reunião de diretoria 
completamente municiado, falta apenas olharmos para o fator Tempo no formato macro.
Dá uma olhada na nossa tabela DIMPOD. Ela armazena os nossos períodos comerciais 
na coluna NUMANOMES (que junta o Ano e o Mês no formato AAAAMM).
Faz o último levantamento para mim: qual foi o valor total bruto 
faturado (VLRVNDEFTFAT) pela empresa em cada Ano-Mês da nossa história?
Quero ver uma lista contendo o período (NUMANOMES) e a respectiva soma 
do faturamento formatada em reais (R$). Ah, e organiza a lista de forma 
cronológica, mostrando do mês mais antigo para o mês mais recente!
*/
SELECT
	CONCAT('R$ ', FORMAT(SUM(f.VLRVNDEFTFAT), 2, 'pt-BR')) AS total_faturado,
    p.NUMANOMES AS ano_mes
FROM 
	FTOPED f
INNER JOIN 
	DIMPOD p
ON f.IDDATA = p.IDDATA
GROUP BY
	p.NUMANOMES
ORDER BY
	ano_mes ASC;