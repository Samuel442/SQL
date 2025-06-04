USE TESTE;

-- Criando a tabela virtual
CREATE TABLE CLIENTESS
(
	 ClienteID INT                   
	, NOME     VARCHAR(255)
	, IDADE    INT
	, CIDADE   VARCHAR(255)
	, ATIVO    VARCHAR(255)
);

INSERT INTO CLIENTESS (ClienteID, NOME, IDADE, CIDADE, ATIVO)
SELECT 
  ClienteID, 
  Nome, 
  Idade, 
  Cidade, 
  Ativo
FROM Clientes_Base_Exercicio;

SELECT *

FROM CLIENTESS

SELECT *

FROM Clientes_Base_Exercicio



CREATE VIEW vw_total_vendas_por_filial AS
SELECT
  FILIAL,
  CONVERT(VARCHAR(10), DATA, 103) AS DATA_FORMATADA, -- formata data para dd/mm/yyyy
  SUM(VENDA) AS TOTAL_VENDA
FROM RELATORIO_NOVO
WHERE DATA BETWEEN '2025-01-01' AND '2025-12-31' -- intervalo de datas
GROUP BY
  FILIAL,
  CONVERT(VARCHAR(10), DATA, 103);

  SELECT * FROM vw_total_vendas_por_filial;
