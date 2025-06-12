CREATE DATABASE DB_Transacoes_Bancarias;

USE DB_Transacoes_Bancarias;

SELECT *
FROM base_transacoes_banco;

CREATE VIEW vw_total_por_cliente AS
SELECT 
    ClienteID,
    Nome,
    SUM(Valor) AS TOTAL_GASTO
FROM base_transacoes_banco
WHERE STATUS = 'Efetivada'
GROUP BY ClienteID, Nome;


-- TESTE ANTES DO UPDATE PARA VER AS CIDADES
SELECT * 
FROM base_transacoes_banco
WHERE TipoTransacao = 'TED'
  AND Valor > 40000;


-- QUERY EM SI
BEGIN TRAN
UPDATE base_transacoes_banco
SET Cidade = 'Uberlandia'
WHERE TipoTransacao = 'TED'
AND Valor > 40000

ROLLBACK; -- VOLTA
COMMIT;   -- EFETIVA

SELECT *
FROM vw_total_por_cliente;