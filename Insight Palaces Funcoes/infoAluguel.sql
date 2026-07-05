SELECT * FROM alugueis;

DELIMITER $$
CREATE FUNCTION InfoAluguel(IdAluguel INT)
RETURNS VARCHAR(255) DETERMINISTIC
BEGIN

DECLARE NomeCliente VARCHAR(100);
DECLARE PrecoTotal DECIMAL(10,2);
DECLARE DIAS INT;
DECLARE ValorDiaria DECIMAL(10,2);
DECLARE Resultado VARCHAR(255);

SELECT c.nome, a.preco_total, DATEDIFF(data_fim, data_inicio)
INTO NomeCliente, PrecoTotal, Dias
FROM alugueis a 
JOIN clientes c
ON a.cliente_id = c.cliente_id
WHERE a.aluguel_id = IdAluguel;

SET ValorDiaria = PrecoTotal / Dias;
SET Resultado = CONCAT('Nome: ', NomeCliente, ', Valor Diário: R$', FORMAT(ValorDiaria,2));
RETURN Resultado;

END $$

DELIMITER ;

SELECT InfoAluguel(1);










