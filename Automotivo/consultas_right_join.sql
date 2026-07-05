-- Conecta no banco antes de rodar a estrutura
USE EV_BYD_Motors;

/*
"Preciso de um relatório para mapear o nosso time de consultores. 
Quero uma lista que traga o Nome do Vendedor e o Número da Nota Fiscal 
de cada venda que ele realizou.
A regra do RH é clara: use obrigatoriamente o RIGHT JOIN nesta query para garantir 
que todos os vendedores cadastrados no sistema apareçam na lista, inclusive os 
recém-contratados que ainda estão em treinamento e nunca fizeram nenhuma 
venda (esses devem aparecer com o número da nota fiscal como NULL)."
*/
SELECT
	v.nome_vendedor AS nome_vendedor,
    f.numero_nota_fiscal AS numero_nota_fiscal
FROM
	fato_vendas f
RIGHT JOIN
	dim_vendedor v
ON f.fk_vendedor = v.sk_vendedor;









/*
"Preciso de um relatório que liste o Nome do Cliente e o Número da Nota Fiscal.
A regra crucial: use obrigatoriamente o RIGHT JOIN para fazer uma auditoria 
reversa de forma que todos os clientes cadastrados na nossa base apareçam, 
mesmo aqueles que foram cadastrados mas nunca realizaram nenhuma compra na concessionária.
Para esses clientes que nunca compraram, o número da nota fiscal deve vir
como NULL para que nossa equipe de CRM possa entrar em contato com uma oferta de boas-vindas!"
*/
SELECT
	c.nome_cliente AS nome_cliente,
    f.numero_nota_fiscal AS numero_nota_fiscal
FROM
	fato_vendas f
RIGHT JOIN
	dim_cliente c
ON c.sk_cliente = f.fk_cliente;










/*
"Nosso plano de expansão para este ano precisa avaliar a atuação das nossas 
filiais regionais. Preciso de um relatório que liste o Nome da Região (estado/região) 
cadastrada no nosso sistema e o Número da Nota Fiscal das vendas que aconteceram nelas.
Atenção: Preciso ver absolutamente todas as regiões cadastradas no nosso banco, mesmo aquelas 
regiões mais distantes onde nossa equipe de vendas ainda não conseguiu fechar nenhum contrato 
(essas devem aparecer na lista com o campo da nota fiscal vazio ou nulo). Quero identificar 
quais estados estão zerados para cobrar a equipe de marketing regional!"
*/
SELECT
	e.estado AS estado,
    f.numero_nota_fiscal AS numero_nota_fiscal
FROM
	fato_vendas f
RIGHT JOIN
	dim_regiao e
ON e.sk_regiao = f.fk_regiao;









/*
"Estamos revisando nossos custos de marketing com canais digitais e físicos 
(aplicativo, site, concessionária física, feiras de eventos e parcerias corporativas). >
Gere um relatório contendo o Nome do Canal de Venda e o Número da Nota Fiscal das 
transações associadas a eles. Quero que a lista traga todos os canais cadastrados 
na nossa tabela de dimensão, sem exceção, para descobrirmos quais canais de divulgação 
estão completamente inativos e sem nenhuma venda registrada na fato (esses devem aparecer com a nota fiscal nula)."
*/
SELECT
	c.nome_canal AS nome_canal,
    f.numero_nota_fiscal AS numero_nota_fiscal
FROM
	fato_vendas f
RIGHT JOIN
	dim_canal_venda c
ON c.sk_canal = f.fk_canal;











/*
"Estamos com suspeitas de que nossa linha de montagem está produzindo 
modelos de veículos ou variações específicas de produtos que estão ficando 
'encalhados' no estoque, sem saída nenhuma para as concessionárias.
Preciso de um relatório que traga o Nome do Produto (da nossa tabela de produtos) 
e o Número da Nota Fiscal.
Atenção: Garanta que o relatório liste absolutamente todos os produtos cadastrados 
no nosso portfólio de fábrica. Quero identificar quais variações específicas de carros 
estão com a nota fiscal totalmente nula. Se o produto não vendeu nenhuma unidade sequer, 
ele precisa aparecer na lista para pararmos a produção imediatamente!"
*/
SELECT
	p.nome_produto AS nome_produto,
    f.numero_nota_fiscal AS numero_nota_fiscal
FROM
	fato_vendas f
RIGHT JOIN
	dim_produto p
ON p.sk_produto = f.fk_produto;









/*
"Preciso de um relatório que liste o Nome do Modelo do veículo e 
o Número da Nota Fiscal das vendas correspondentes.
Atenção ao critério de corte: Quero ver absolutamente todos os modelos de 
veículos que temos cadastrados na nossa tabela de dimensões, mesmo aqueles 
modelos super exclusivos ou lançamentos recentes que ainda não possuem nenhuma 
venda registrada na nossa tabela fato. Esses carros sem saída devem aparecer 
na lista com o número da nota fiscal nulo para que eu possa cobrar o time de vendas!"
*/
SELECT
	m.nome_modelo AS nome_modelo,
    f.numero_nota_fiscal AS numero_nota_fiscal
FROM
	fato_vendas f
RIGHT JOIN
	dim_modelo_veiculo m
ON m.sk_modelo = f.fk_modelo;









/*
"Estamos mapeando a eficiência operacional das nossas linhas de montagem automotiva. 
Preciso de um relatório que liste o Nome do Operador (cadastrado na nossa base) e o 
Número do Lote de Produção (ou identificador operacional) das atividades registradas.
Atenção à regra de auditoria: Preciso ver absolutamente todos os operadores cadastrados 
no nosso sistema, incluindo os funcionários recém-contratados ou aqueles alocados 
temporariamente em posições de suporte que ainda não iniciaram ou registraram nenhuma 
ordem na nossa tabela fato de produção. Quero mapear quem ainda não gerou ordens para 
planejar os treinamentos desta semana!"
*/
SELECT
	o.nome_operador AS nome_operador,
    f.numero_ordem_producao AS numero_ordem_producao
FROM
	fato_producao f
RIGHT JOIN
	dim_operador o
ON o.sk_operador = f.fk_operador;









/*
"Cadastramos e homologamos uma série de fornecedores globais no nosso 
sistema para o fornecimento de autopeças e componentes de montagem.
Gere um relatório que liste o Nome do Fornecedor e o Número da Nota 
Fiscal de Compra (da nossa tabela de movimentação de insumos) para mapear os pedidos.
Atenção: Quero ver absolutamente todos os fornecedores homologados na nossa 
dimensão, sem exceção. Preciso identificar quais fornecedores parceiros estão 
com a nota fiscal de compra completamente nula, indicando que fechamos o contrato 
de parceria mas ainda não realizamos nenhuma compra real com eles!"
*/
SELECT
	d.nome_fornecedor AS nome_fornecedor,
    f.numero_pedido_compra AS numero_pedido_compra
FROM
	fato_compras f
RIGHT JOIN
	dim_fornecedor d
ON d.sk_fornecedor = f.fk_fornecedor;









/*
"Preciso de uma listagem consolidada de todas as nossas Transportadoras 
cadastradas e o Número do Conhecimento de Transporte (ou número da ordem de frete) 
de cada entrega realizada.
Atenção: Quero ver todas as transportadoras da nossa lista de parceiros, sem exceção. 
Se alguma transportadora não tiver nenhum Conhecimento de Transporte (ou ordem de frete) 
vinculado a ela, o campo deve vir nulo. Quero identificar quais transportadoras são apenas 
"figurantes" e nunca moveram um único caminhão para a BYD neste período!"
*/
SELECT
	d.razao_social AS razao_social,
    f.numero_conhecimento_cte AS numero_conhecimento_cte
FROM
	fato_logistica f
RIGHT JOIN 
	dim_transportadora d
ON d.sk_transportadora = f.fk_transportadora;














/*
"Preciso de uma visão total do nosso programa de controle de qualidade. 
Quero um relatório com o Nome do Defeito (cadastrado na dim_defeito) e o 
Código da Peça (ou ID do registro na fato) das ocorrências de qualidade registradas.
Atenção: Quero ver absolutamente todos os tipos de defeitos cadastrados na nossa biblioteca 
de qualidade, mesmo aqueles que nunca foram reportados nas nossas inspeções 
(esses devem aparecer com a peça nula). Isso vai mostrar quais protocolos de
 inspeção estão obsoletos ou sem incidência no chão de fábrica!"
*/
SELECT
	d.nome_defeito AS nome_defeito,
    f.numero_relatorio_nc AS numero_relatorio_nc
FROM
	fato_qualidade f
RIGHT JOIN 
	dim_defeito d
ON d.sk_defeito = f.fk_defeito;