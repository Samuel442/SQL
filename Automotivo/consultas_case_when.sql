-- Conecta no banco antes de rodar a estrutura
USE EV_BYD_Motors;



/*
"Comandante, preciso que você segmente nossa equipe de consultores. Não me 
interessa apenas o volume bruto de faturamento; preciso que você classifique 
cada vendedor em categorias claras.
Identifique quem são os nossos vendedores 'Elite', quem está no 'Standard' 
e quem precisa de 'Atenção'. Quero esse relatório na minha mesa com a 
classificação aplicada a cada um, para que eu possa tomar decisões sobre 
metas e suporte aos times. Prepare o diagnóstico imediatamente."
*/
SELECT
	d.nome_vendedor AS nome_vendedor,
    CONCAT('R$ ', FORMAT(SUM(f.receita_bruta), 2)) AS receita_bruta,
    CASE
		WHEN SUM(f.receita_bruta)> 144000000 THEN 'Elite'
        WHEN SUM(f.receita_bruta) BETWEEN 130000000 AND 144000000 THEN 'Standard'
        ELSE 'Atenção'
    END AS categoria
FROM
	fato_vendas f
INNER JOIN
	dim_vendedor d
ON f.fk_vendedor = d.sk_vendedor
GROUP BY
	d.nome_vendedor
ORDER BY
	receita_bruta DESC;
    
    
    
    
    
    
    
/*
"Comandante, precisamos entender o comportamento de compra dos 
nossos clientes sob a ótica da nossa disponibilidade operacional.
Não quero apenas a data da venda; quero que você segmente nossas 
operações em 'Dia Útil' e 'Fim de Semana'. Preciso desse diagnóstico 
para validarmos se o nosso volume de vendas está concentrado no 
período comercial ou se temos uma demanda resiliente aos sábados 
e domingos. Ajuste o código e classifique essa sazonalidade 
imediatamente. O plano de ação de marketing do próximo trimestre 
depende dessa clareza."
*/
SELECT
	f.numero_nota_fiscal AS numero_nota_fiscal,
    d.data_completa AS data_completa,
    CASE
		WHEN eh_fim_semana = 'S' THEN 'Fim de Semana'
        ELSE 'Dia de Semana'
    END AS dia_da_semana
FROM
	fato_vendas f
INNER JOIN
	dim_tempo d
ON f.fk_tempo = d.sk_tempo;










/*
Missão: Classificar cada item de venda (id_item_venda) pela sua margem de lucro, 
para identificar onde estamos ganhando dinheiro e onde estamos operando no 
prejuízo ou na margem mínima.
*/
SELECT
	f.id_item_venda AS id_item_venda,
    f.receita_liquida AS receita_liquida,
    f.lucro_operacional AS lucro_operacional,
    CASE
		WHEN f.lucro_operacional < 0 THEN 'Ruim'
        WHEN f.lucro_operacional BETWEEN 0 AND 1000 THEN 'Alta Margem'
        ELSE 'Alta Rentabilidade'
    END AS lucro
FROM
	fato_vendas f
ORDER BY
	    CASE
		WHEN f.lucro_operacional < 0 THEN 1
        WHEN f.lucro_operacional BETWEEN 0 AND 1000 THEN 2
        ELSE 3
    END;
    
    
    
    
    
    
    
    
/*
Crie uma query que liste id_item_venda e receita_liquida, 
mas adicione uma coluna chamada status_desconto com a seguinte lógica:
- Se o valor_desconto for igual a 0: "Sem Desconto".
- Se o valor_desconto for maior que 0 e menor ou igual a 10% da receita_bruta: "Desconto Padrão".
- Se o valor_desconto for maior que 10% da receita_bruta: "Desconto Agressivo".
*/
SELECT
	f.id_item_venda AS id_item_venda,
    CONCAT('R$ ', FORMAT(f.receita_liquida, 2)) AS receita_liquida,
    CASE
		WHEN f.valor_desconto = 0 THEN 'Sem Desconto'
        WHEN f.valor_desconto > 0 AND (f.valor_desconto / f.receita_bruta) <= 0.10 THEN 'Desconto Padrão'
		ELSE 'Desconto Agressivo'
    END AS status_desconto
FROM
	fato_vendas f;
    
    
    
    
    
    
    
    
    
    
/*
O gerente quer saber se o desconto aplicado está "comendo" o lucro. 
Se o valor_desconto for maior que o lucro_operacional, a venda é de "Alto Risco".
*/
SELECT
	CONCAT('R$ ', FORMAT(f.valor_desconto, 2)) AS valor_desconto,
    CONCAT('R$ ', FORMAT(f.lucro_operacional, 2)) AS lucro_operacional,
    CASE
		WHEN f.valor_desconto > f.lucro_operacional THEN 'Alto Risco'
        ELSE 'Dentro da Margem'
    END AS status_opcoes
FROM
	fato_vendas f;
    
    
    
    
    
    
    
    
/*
Uma venda é considerada "Estratégica" se cumprir dois critérios simultâneos:
Ter uma receita_liquida acima de R$ 50.000.
Ter um lucro_operacional que represente pelo menos 20% da receita_liquida.
Caso contrário, ela será classificada como "Venda Operacional".
*/
SELECT
	CONCAT('R$ ', FORMAT(f.receita_liquida, 2)) AS receita_liquida,
    CONCAT('R$ ', FORMAT(f.lucro_operacional, 2)) AS lucro_operacional,
    CASE
		WHEN f.receita_liquida > 50000 AND f.lucro_operacional > f.receita_liquida * 0.20 THEN 'Estratégica'
		ELSE 'Venda Operacional' 
    END AS categoria_venda
FROM
	fato_vendas f;
    
    
    
    
    
    
    
    
    
/*
O objetivo é identificar transações onde a agressividade do desconto 
compromete a receita, classificando-as automaticamente para facilitar 
a tomada de decisão da gestão.
Regra de Negócio:
Sem Desconto: Vendas onde valor_desconto é exatamente 0.
Desconto Crítico: Vendas onde valor_desconto supera 15% da receita_bruta.
Desconto Normal: Todas as demais operações.
*/
SELECT
	CONCAT('R$ ', FORMAT(f.receita_liquida, 2)) AS receita_liquida,
    CONCAT('R$ ', FORMAT(f.valor_desconto, 2)) AS valor_desconto,
    CASE
		WHEN f.valor_desconto = 0 THEN 'Sem Desconto'
        WHEN f.valor_desconto > f.receita_bruta * 0.15 THEN  'Desconto Crítico'
        ELSE 'Normal'
    END AS categoria_descontos
FROM
	fato_vendas f;
    
    
    
    
    
    
    
    
    
    
/*
O gerente de fábrica precisa identificar rapidamente quais lotes estão 
gerando muito desperdício. Vamos classificar a qualidade da produção baseada na taxa de refugo.
Regra de Negócio:
Se o refugo for 0: "Produção Excelente".
Se o refugo for menor ou igual a 5% da quantidade_produzida: "Produção Aceitável".
Se o refugo for maior que 5%: "Atenção: Alto Refugo".
*/
SELECT
	f.quantidade_refugo AS taxa_refugo,
    f.quantidade_produzida AS quantidade_produzida,
    CASE
		WHEN f.quantidade_refugo = 0 THEN 'Excelente'
        WHEN f.quantidade_refugo <= f.quantidade_produzida * 0.05 THEN 'Produção Aceitável'
        ELSE 'Atenção: Alto Refugo'
    END AS refugo
FROM
	fato_producao f;
    
    
    
    
    
    
    
    
    
    
    
/*
Vamos classificar o recebimento baseando-nos na comparação 
entre quantidade_comprada e quantidade_recebida.
Regra de Negócio:
Se a quantidade_recebida for igual à quantidade_comprada: "Entrega Completa".
Se a quantidade_recebida for menor que a comprada, mas maior que zero: "Entrega Parcial".
Se a quantidade_recebida for zero: "Pedido Pendente".
*/
SELECT
	f.quantidade_recebida AS quantidade_recebida,
    f.quantidade_comprada AS quantidade_comprada,
    CASE
		WHEN f.quantidade_recebida = f.quantidade_comprada THEN 'Entrega Completa'
        WHEN f.quantidade_recebida = 0 THEN 'Pedido Pendente'
		WHEN f.quantidade_recebida < f.quantidade_comprada THEN 'Entrega Parcial'
        ELSE 'Fora de Categoria'
    END AS categorias
FROM
	fato_compras f;
    
    
    
    
    
    
    
    
    
    
/*
Classifique a severidade das ordens de serviço (numero_ordem_servico):
Regra de Negócio:
Crítico: Se o tempo_parado_minutos for maior que 60 E o custo_indisponibilidade for maior que R$ 5.000.
Atenção: Se apenas um desses dois critérios for verdadeiro.
Normal: Se ambos estiverem abaixo dos limites.
*/
SELECT
	f.tempo_parado_minutos AS tempo_parado_minutos,
    f.custo_indisponibilidade AS custo_indisponibilidade,
    f.numero_ordem_servico AS numero_ordem_servico,
    CASE
		WHEN tempo_parado_minutos > 60 AND custo_indisponibilidade > 5000  THEN 'Crítico'
        WHEN tempo_parado_minutos > 60 OR custo_indisponibilidade > 5000 THEN 'Atenção'
        ELSE 'Normal'
    END AS severidade
FROM
	fato_manutencao f;