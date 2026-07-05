-- Conecta no banco antes de rodar a estrutura
USE EV_BYD_Motors;

/*
Fantástico! Que números expressivos: R$ 1,34 bilhão em receita líquida e mais 
de R$ 472 milhões de lucro puro colocado no bolso. A diretoria ficou 
impressionada com a margem. Agora, eu preciso refinar essa análise. Nós temos 
dois tipos de canais de venda principais (aqueles identificados pelos códigos 1 
e 2 no nosso sistema). Quero comparar a performance deles: qual é o valor total de 
lucro operacional gerado exclusivamente pelas nossas vendas feitas via canal código 2? 
Me passa esse valor isolado para eu entender se esse canal está valendo a pena.
*/
SELECT
	CONCAT('R$ ', FORMAT(SUM(f.lucro_operacional), 2, 'pt-BR')) AS lucro_opercacional,
    d.sk_canal AS codigo_canal
FROM
	fato_vendas f
INNER JOIN
	dim_canal_venda d
ON f.fk_canal = d.sk_canal
WHERE
	d.sk_canal = 2
GROUP BY
	d.sk_canal;
    
    
    
    
    
    
    
/*
Excelente, esse canal 2 representa quase metade do nosso lucro total! 
Agora o bicho pegou aqui na reunião. O Diretor de Marketing quer ver a 
nossa performance de vendas aberta por estado/região de atuação. Ele me 
pediu um relatório comparativo completo: eu preciso saber qual foi o 
valor total de lucro operacional que cada uma das nossas regiões gerou 
individualmente, trazendo também o nome legível da região ao lado do valor 
para eu saber quem é quem. Mostre todas as regiões em uma única resposta 
para eu comparar qual delas é a nossa campeã de lucratividade e qual 
está vendendo menos!
*/
SELECT
	CONCAT('R$ ', FORMAT(SUM(f.lucro_operacional), 2, 'pt-BR')) AS lucro_operacional,
    d.estado AS estado,
    d.regiao_macro AS regiao_macro
FROM 
	fato_vendas f
INNER JOIN
	dim_regiao d
ON f.fk_regiao = d.sk_regiao
GROUP BY
	d.estado,
    d.regiao_macro;
    
    
    
    
    
    
    
    
/*
"Uau, excelente! Consigo ver claramente que o estado de São Paulo lidera 
com mais de R$ 190 milhões em lucro, seguido bem de perto por Minas Gerais. 
Esse relatório ficou ótimo para a nossa tomada de decisão.
Agora o Diretor de Marketing gostou do seu trabalho e me fez um pedido bem específico. 
Ele quer olhar para a nossa equipe de vendas, mas apenas para aqueles que trazem mais 
resultado. Você consegue listar para mim o Nome do Vendedor e o Valor Total de Lucro 
Operacional que ele trouxe, mas mostrando apenas os vendedores que geraram mais de 
R$ 50 milhões de lucro puro no total? Ele quer esse filtro específico para montar uma 
campanha de premiação para o topo da tabela!"
*/
SELECT
	d.nome_vendedor AS nome_vendedor,
	CONCAT('R$ ', FORMAT(SUM(f.lucro_operacional), 2, 'pt-BR')) AS lucro_operacional
FROM
	fato_vendas f
INNER JOIN
	dim_vendedor d
ON f.fk_vendedor = d.sk_vendedor
GROUP BY
	d.nome_vendedor
HAVING
	SUM(f.lucro_operacional) > 50000000;










/*
"Olá! Estou organizando os pátios de distribuição e preciso de um relatório rápido. 
Você poderia listar para mim o Número da Nota Fiscal, a Quantidade Vendida e o Nome 
do Modelo (ex: Dolphin, Seal, etc.) de todos os veículos que saíram do nosso estoque? 
Só preciso acoplar o nome comercial do carro ao lado do registro de venda."
*/
SELECT
	d.nome_modelo AS nome_modelo,
    f.quantidade_vendida AS quantidade_vendida,
    f.numero_nota_fiscal AS numero_nota_fiscal
FROM
	fato_vendas f
INNER JOIN
	dim_modelo_veiculo d
ON f.fk_modelo = d.sk_modelo;








/*
"Olá! Quero entender a distribuição geográfica das nossas vendas. 
Você consegue gerar uma lista rápida para mim mostrando a Nota Fiscal, 
a Receita Líquida de cada registro e o Nome do Estado para onde esse carro foi vendido? 
Quero ver para quais estados nossos faturamentos individuais estão indo."
*/
SELECT
	f.numero_nota_fiscal AS numero_nota_fiscal,
    f.receita_liquida AS soma_receita_liquida,
    d.estado AS estado
FROM
	fato_vendas f
INNER JOIN 
	dim_regiao d
ON f.fk_regiao = d.sk_regiao;






/*
"Excelente! A lista de estados ficou ótima e roda super rápido. 
Agora, meu foco mudou para os nossos compradores. Você conseguiria 
listar para mim o Número da Nota Fiscal, o Valor do Desconto aplicado 
e o Nome Completo do Cliente que realizou a compra? Quero entender 
quem são as pessoas ou empresas que estão ganhando as maiores 
colheres de chá da nossa equipe comercial!"
*/
SELECT
	f.numero_nota_fiscal AS numero_nota_fiscal,
    f.valor_desconto AS desconto_aplicado,
    d.nome_cliente AS nome_cliente
FROM
	fato_vendas f
INNER JOIN
	dim_cliente d
ON f.fk_cliente = d.sk_cliente;








/*
"Excelente trabalho com os descontos! Conseguimos identificar alguns 
compradores particulares que ganharam margens ótimas. Agora, eu preciso de 
um dado específico para a equipe de pós-vendas.
Eu gostaria de uma listagem contendo o Número da Nota Fiscal, a Receita 
Líquida e o Nome do Modelo do carro, mas mostrando apenas os carros que são 
do modelo 'BYD Dolphin'. Preciso isolar esse modelo específico da nossa lista 
de vendas para cruzar com uma pesquisa de satisfação dos proprietários."
*/
SELECT
	f.numero_nota_fiscal AS numero_nota_fical,
    CONCAT('R$ ', FORMAT(f.receita_liquida, 2, 'pt-BR')) AS receita_liquida,
    d.nome_modelo AS nome_modelo
FROM
	fato_vendas f
INNER JOIN
	dim_modelo_veiculo d
ON f.fk_modelo = d.sk_modelo
WHERE 
	d.nome_modelo = 'BYD Dolphin';
    
    
    
    
    
    
    
    
/*
"Incrível! Esse relatório com o filtro exato do Dolphin salvou o dia do pós-venda. 
Agora, estou avaliando a nossa força de vendas interna para entender quem está emitindo cada pedido.
Você conseguiria extrair uma listagem contendo o Número da Nota Fiscal, a Receita Bruta daquela 
venda e o Nome do Vendedor responsável? Quero cruzar essas notas com o nosso sistema de comissões 
para auditar os lançamentos deste mês."
*/
SELECT
	f.numero_nota_fiscal AS numero_nota_fiscal,
    CONCAT('R$ ', FORMAT(f.receita_bruta, 2, 'pt-BR')) AS receita_bruta,
    d.nome_vendedor AS nome_vendedor
FROM
	fato_vendas f
INNER JOIN
	dim_vendedor d
ON f.fk_vendedor = d.sk_vendedor;








/*
"Obrigado pelo relatório anterior, a auditoria de comissões foi um sucesso! 
Agora, preciso de um slide para a nossa reunião de fechamento mensal.
Você poderia gerar uma consulta que me mostre o Nome do Vendedor e o Valor 
Total de Receita Líquida acumulada (a soma de tudo o que ele vendeu)? Quero 
ordenar esse relatório do maior faturamento para o menor, para que a diretoria 
veja claramente quem é o nosso vendedor número um do mês!"
*/
SELECT
	d.nome_vendedor AS nome_vendedor,
    CONCAT('R$ ', FORMAT(SUM(f.receita_liquida), 2, 'pt-BR')) AS receita_liquida
FROM
	fato_vendas f
INNER JOIN
	dim_vendedor d
ON f.fk_vendedor = d.sk_vendedor
GROUP BY
	d.nome_vendedor
ORDER BY
	SUM(f.receita_liquida) DESC;
    
    
    
    
    
    
    
    
    
/*
"Fantástico! O slide com o ranking dos vendedores ficou incrível para a nossa 
apresentação. Agora, a diretoria me pediu um indicador focado em eficiência de margem por produto.
Você poderia gerar um relatório agregando os dados por carro? Eu preciso ver 
o Nome do Modelo do veículo e o Valor Médio do Lucro Operacional que cada unidade 
daquele modelo deixa na empresa. Quero ordenar o relatório do modelo mais lucrativo 
(em média) para o menos lucrativo, para decidirmos onde aplicar nossos incentivos de marketing!"
*/
SELECT
	d.nome_modelo AS nome_modelo,
    CONCAT('R$ ', FORMAT(AVG(f.lucro_operacional), 2, 'pt-BR')) AS lucro_opercaional
FROM
	fato_vendas f
INNER JOIN 
		dim_modelo_veiculo d
ON f.fk_modelo = d.sk_modelo
GROUP BY
	d.nome_modelo
ORDER BY
	AVG(f.lucro_operacional) DESC;
    
    
    
    
    
    
    
    
    
    
/*
"A diretoria me pediu um relatório de auditoria cruzada bem específico. 
Eles querem monitorar as vendas detalhadamente combinando os dados de 
quem comprou e do produto.
Você conseguiria gerar uma listagem contendo o Número da Nota Fiscal, o 
Nome do Cliente que comprou o veículo e o Nome do Modelo do carro? Preciso 
juntar a informação do comprador e do veículo na mesma linha do relatório, 
tudo baseado nas nossas notas fiscais."
*/
SELECT
	f.numero_nota_fiscal AS numero_nota_fiscal,
    c.nome_cliente AS nome_cliente,
    m.nome_modelo AS nome_modelo
FROM
	fato_vendas f
INNER JOIN
	dim_cliente c
ON f.fk_cliente = c.sk_cliente
INNER JOIN
	dim_modelo_veiculo m
ON f.fk_modelo = m.sk_modelo;








/*
"Que show de relatório! Ver o nome do cliente ao lado do modelo ajuda 
demais nas nossas análises de CRM. Agora, preciso de um mapeamento 
ainda mais completo para a nossa auditoria de compliance.
Você conseguiria gerar uma listagem contendo o Número da Nota Fiscal, 
o Nome do Cliente que comprou o carro, o Nome do Vendedor que realizou 
a venda e o Nome do Estado (Região) para onde o veículo foi faturado? 
Quero ver esses quatro dados conectados linha por linha para identificar 
o fluxo completo de cada venda de forma rápida."
*/
SELECT
	f.numero_nota_fiscal AS numero_nota_fiscal,
    c.nome_cliente AS nome_cliente,
    v.nome_vendedor AS nome_vendedor,
    e.estado AS estado
FROM 
	fato_vendas f
INNER JOIN
	dim_cliente c
ON f.fk_cliente = c.sk_cliente
INNER JOIN
	dim_vendedor v
ON f.fk_vendedor = v.sk_vendedor
INNER JOIN
	dim_regiao e
ON f.fk_regiao = e.sk_regiao;







/*
"Estou impressionado com a velocidade das suas entregas! Para fechar esse 
pacote de relatórios internos antes de analisarmos os dados sob outra 
perspectiva, preciso de um resumo gerencial de alto nível.
Eu gostaria de ver o Nome do Estado (Região), o Nome do Modelo do carro 
e o Valor Total de Receita Líquida acumulada (a soma de tudo). Porém, preciso 
que esse relatório traga apenas as vendas realizadas pelo 'Consultor BYD 4'. 
Por fim, ordene o resultado do maior faturamento acumulado para o menor, para 
eu entender qual carro e estado dão mais retorno nas mãos dele."
*/
SELECT
	e.estado AS estado,
    m.nome_modelo AS modelo_veiculo,
    CONCAT('R$ ', FORMAT(SUM(f.receita_liquida), 2, 'pt-BR')) AS total_receita_liquida,
    v.nome_vendedor AS nome_consultor
FROM
	fato_vendas f
INNER JOIN
	dim_regiao e
ON f.fk_regiao = e.sk_regiao
INNER JOIN
	dim_modelo_veiculo m
ON f.fk_modelo = m.sk_modelo
INNER JOIN
	dim_vendedor v
ON f.fk_vendedor = v.sk_vendedor
WHERE
	v.nome_vendedor = 'Consultor BYD 4'
GROUP BY
	e.estado,
    m.nome_modelo,
    v.nome_vendedor
ORDER BY
	SUM(f.receita_liquida) DESC;