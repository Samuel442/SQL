-- Conecta no banco antes de rodar a estrutura
USE EV_BYD_Motors;

/*
"Olá! Cara, estou entrando em uma reunião de diretoria agora para apresentar 
os resultados históricos da nossa operação e o presidente me pegou de surpresa. 
Preciso saber, jogo rápido: quanto a BYD já faturou no total em dinheiro bruto 
desde que começamos a registrar nosso histórico e quantos carros nós já vendemos 
no total até hoje? Me passa esses dois números consolidados para eu colocar no 
slide, por favor!"
*/

SELECT
	CONCAT('R$ ', FORMAT(SUM(v.receita_bruta), 2, 'pt-BR')) AS valor_bruto_vendas,
    COUNT(quantidade_vendida)  AS numero_de_carros
FROM
	fato_vendas v;
	
    
    
/*
"Caramba, que velocidade! Espetacular. Coloquei os dados direto no slide: R$ 1,37 
bilhão bruto e 5.000 veículos vendidos. O presidente adorou. Mas agora ele me fez 
outra pergunta que me deixou apertado. Desse montante que faturamos, ele quer saber 
quanto realmente sobrou no nosso bolso de forma líquida após os descontos, e qual foi 
a nossa margem de lucro real acumulada. Você consegue descobrir para mim qual foi 
o valor total de receita líquida da empresa e quanto sobrou de lucro operacional 
puro no total?"
*/
SELECT 
	CONCAT('R$ ', FORMAT(SUM(f.receita_liquida), 2, 'pt-BR')) AS receita_liquida,
    CONCAT('R$ ', FORMAT(SUM(f.lucro_operacional), 2, 'pt-BR')) AS lucro_operacional
FROM 
	fato_vendas f;
