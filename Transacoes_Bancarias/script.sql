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

SELECT *
FROM vw_total_por_cliente;