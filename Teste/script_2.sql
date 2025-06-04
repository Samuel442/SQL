-- Inserindo em tabela temporária seção ativa e outra seção
SELECT *
INTO ##RELATORIO_LTZ
FROM TB_VENDAS
WHERE VENDEDOR = 'LTZ';


SELECT *

FROM TB_VENDAS
