-- Inserindo em tabela tempor�ria se��o ativa e outra se��o
SELECT *
INTO ##RELATORIO_LTZ
FROM TB_VENDAS
WHERE VENDEDOR = 'LTZ';


SELECT *

FROM TB_VENDAS
