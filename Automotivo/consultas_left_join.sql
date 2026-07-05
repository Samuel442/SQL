-- Conecta no banco antes de rodar a estrutura
USE EV_BYD_Motors;

/*
A nossa equipe de marketing cadastrou novos modelos de veículos importados 
no sistema há alguns meses. Eu preciso avaliar o desempenho comercial de 
toda a nossa lista cadastrada de carros, sem exceção.
Você poderia gerar um relatório simples que liste o Nome do Modelo do 
veículo (da tabela de modelos) e o Número da Nota Fiscal (da tabela de vendas)? 
Quero ver todos os modelos que temos cadastrados na base, mesmo aqueles que nunca 
tiveram nenhuma venda realizada. Isso vai me ajudar a puxar a orelha do time de marketing!
*/
SELECT
	d.nome_modelo AS nome_modelo,
    f.numero_nota_fiscal AS numero_nota_fiscal
FROM
	dim_modelo_veiculo d
LEFT JOIN
	fato_vendas f
ON f.fk_modelo = d.sk_modelo;







/*
O RH acabou de me passar a lista de novos consultores comerciais 
que foram contratados e integrados ao sistema há algumas semanas. No entanto, 
estou com uma forte suspeita de que alguns deles ainda estão zerados, sem 
conseguir fechar nenhum contrato.
Você consegue gerar um relatório para mim contendo o Nome do Vendedor e o 
Número da Nota Fiscal das vendas? Mas ó, preciso ver todos os vendedores cadastrados 
na nossa base, sem exceção, para eu identificar visualmente quem são os novos contratados 
que ainda estão sem nenhuma produção registrada."
*/
SELECT
	v.nome_vendedor AS nome_vendedor,
    f.numero_nota_fiscal AS numero_nota_fiscal
FROM 
	dim_vendedor v
LEFT JOIN
	fato_vendas f
ON v.sk_vendedor = f.fk_vendedor;







/*
"Crucial esse relatório! Agora eu tenho os nomes de quem está zerado. Para eu 
passar essa lista direto para o setor de treinamento cobrar a produtividade deles, 
preciso que você limpe o relatório anterior.
Gere uma consulta que me traga o Nome do Vendedor, mas que filtre a saída para exibir 
apenas e exclusivamente os funcionários que não venderam nada (ou seja, esconda quem 
tem venda e me mostre só quem está zerado). Não quero ver nenhuma nota fiscal na tela, 
apenas a lista limpa de quem precisa de atenção!"
*/
SELECT
	v.nome_vendedor AS nome_vendedor,
    f.numero_nota_fiscal AS numero_nota_fiscal
FROM
	dim_vendedor v
LEFT JOIN
	fato_vendas f
ON v.sk_vendedor = f.fk_vendedor
WHERE
	f.numero_nota_fiscal IS NULL;
    
    
    
    




/*
"O nosso plano de expansão nacional cadastrou diversos estados e regiões do Brasil 
no sistema para preparar a chegada das concessionárias. No entanto, a diretoria 
quer saber onde nossa operação comercial ainda está totalmente zerada.
Você consegue gerar um relatório que mostre apenas os nomes dos Estados que foram 
cadastrados na nossa base de dados, mas que ainda não possuem nenhuma nota fiscal 
emitida? Preciso dessa lista limpa para cobrar a equipe de expansão territorial!"
*/
SELECT
	e.estado AS estado,
    f.numero_nota_fiscal AS numero_nota_fiscal
FROM
	dim_regiao e
LEFT JOIN
	fato_vendas f
ON e.sk_regiao = f.fk_regiao
WHERE 
	f.numero_nota_fiscal IS NULL;
    
    
    
    
    
    
    
    
    
    
/*
"Para o nosso planejamento de CRM e fidelidade, preciso de uma lista 
que traga o Nome do Cliente (de todos os clientes da nossa base, 
sem exceção) e a Quantidade Total de Compras que cada um realizou até hoje.
Atenção: Eu sei que temos muitos clientes novos na base que nunca compraram 
nada. Quero que eles apareçam no relatório também, mas marcando a quantidade 
de compras como 0 (zero), e não como aquela palavra feia 'NULL' ou em branco. 
Consiga isso para mim!"
*/
SELECT
	n.nome_cliente AS nome_cliente,
    COALESCE(COUNT(f.quantidade_vendida), 0) AS quantidade_vendida
FROM
	dim_cliente n
LEFT JOIN
	fato_vendas f
ON n.sk_cliente = f.fk_cliente
GROUP BY
	n.nome_cliente;
    
    
    
    
    
    
    
    
    
    
    

/*
"Estou revisando as margens de lucro de cada consultor. Preciso de um 
relatório que liste o Nome do Vendedor (todos os vendedores cadastrados, 
sem exceção) e a Média de Desconto que cada um aplicou em suas vendas.
Quero o valor bonitinho no formato de dinheiro (R$ 0,00). E fique atento: 
como temos novos vendedores que nunca realizaram vendas, eu não quero ver 
a palavra 'NULL' ou o campo em branco na média deles. Quem não vendeu nada 
precisa aparecer obrigatoriamente com a média de desconto zerada: R$ 0,00!"
*/
SELECT
	v.nome_vendedor AS nome_vendedor,
    CONCAT('R$ ', FORMAT(IFNULL(AVG(f.valor_desconto), 0), 2, 'pt-BR')) AS media_valor_desconto
FROM
	dim_vendedor v
LEFT JOIN
	fato_vendas f
ON v.sk_vendedor = f.fk_vendedor
GROUP BY
	v.nome_vendedor;
    
    
    
    
    
    
    
    
    
    
    
    

/*
"Estamos planejando um evento exclusivo de test-drive e queremos 
cruzar a nossa base de dados. Preciso de um relatório simples que 
liste o Nome do Cliente e o Nome do Vendedor que está associado a ele 
como responsável pelo atendimento.
Regra de ouro: quero ver todos os clientes cadastrados na nossa base, mesmo 
aqueles que foram inseridos recentemente no sistema e ainda não possuem nenhum 
vendedor vinculado a eles (esses devem aparecer com o nome do vendedor em branco 
ou NULL). Traga essa lista aberta para mim!"
*/
SELECT
	c.nome_cliente AS nome_cliente,
    v.nome_vendedor AS nome_vendedor
FROM
	dim_cliente c
LEFT JOIN
	fato_vendas f
ON c.sk_cliente = f.fk_cliente
LEFT JOIN
	dim_vendedor v
ON v.sk_vendedor = f.fk_vendedor;








/*
"Eu sei que analisamos os modelos lá atrás e parecia tudo certo. 
Mas agora eu quero uma auditoria reversa estrita para a equipe de estoque.
Gere um relatório contendo apenas o Nome do Modelo do Veículo (tabela de dimensão) 
de todos aqueles que estão cadastrados no sistema, mas que nunca tiveram sequer 
uma única unidade vendida na tabela fato. Quero apenas os nomes desses modelos 
fantasma para avaliar se vamos descontinuar o cadastro deles!"
*/
SELECT
	m.nome_modelo AS nome_modelo,
    COALESCE(COUNT(f.quantidade_vendida),0) AS quantidade_vendida
FROM
	dim_modelo_veiculo m
LEFT JOIN
	fato_vendas f
ON m.sk_modelo = f.fk_modelo
GROUP BY
	m.nome_modelo
HAVING
	COUNT(f.quantidade_vendida) = 0;
    
    
    
    
    
    
    
    
    
    
    
    
    
/*
"Estamos planejando um evento exclusivo de test-drive e queremos cruzar a nossa base 
de dados. Preciso de um relatório simples que liste o Nome do Cliente e o Nome do 
Vendedor que está associado a ele como responsável pelo atendimento.
Regra de ouro: quero ver todos os clientes cadastrados na nossa base, mesmo aqueles 
que foram inseridos recentemente no sistema e ainda não possuem nenhum vendedor vinculado 
a eles (esses devem aparecer com o nome do vendedor em branco ou NULL). 
Traga essa lista aberta para mim!"
*/
SELECT
	c.nome_cliente AS nome_cliente,
    v.nome_vendedor AS nome_vendedor
FROM
	dim_cliente c
LEFT JOIN
	fato_vendas f
ON c.sk_cliente = f.fk_cliente
LEFT JOIN
	dim_vendedor v
ON v.sk_vendedor = f.fk_vendedor;












/*
"Excelente cruzamento de dados! Agora, preciso isolar o problema. O time de 
marketing precisa fazer um disparo regional estruturado, mas descobrimos que 
existem clientes na base sem classificação.
Utilize a query que você acabou de construir e filtre o relatório para exibir 
apenas os clientes que não possuem o segmento de mercado preenchido (ou seja, onde 
a coluna segmento_mercado na tabela de clientes seja NULL). Quero essa lista limpa 
para cobrar a equipe de cadastro!"
*/
SELECT
	c.nome_cliente AS nome_cliente,
    v.nome_vendedor AS nome_vendedor
FROM
	dim_cliente c
LEFT JOIN
	fato_vendas f
ON c.sk_cliente = f.fk_cliente
LEFT JOIN
	dim_vendedor v
ON v.sk_vendedor = f.fk_vendedor
WHERE
	v.nome_vendedor IS NULL;

	
    
    
    
    
    
    
    
    
    
    
    

/*
"Para fechar o nosso relatório mensal de estoque, preciso de uma lista contendo 
o Nome do Modelo do Veículo (todos os modelos cadastrados no banco, sem exceção) 
e a Soma Total de Valor de Venda que cada modelo gerou.
Atenção aos detalhes corporativos:
O valor de venda deve vir formatado como dinheiro brasileiro (R$ 0,00).
Os modelos novos que estão cadastrados mas que ainda não possuem nenhuma venda 
registrada na tabela fato não podem aparecer com a palavra NULL ou campo vazio. 
Eles devem exibir obrigatoriamente R$ 0,00!"
*/
SELECT
	m.nome_modelo AS nome_modelo,
    CONCAT('R$ ', FORMAT(SUM(f.receita_bruta), 2, 'pt-BR')) AS receita_bruta
FROM
	dim_modelo_veiculo m
LEFT JOIN 
	fato_vendas f
ON m.sk_modelo = f.fk_modelo
GROUP BY
	m.nome_modelo;