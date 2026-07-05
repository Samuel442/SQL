DELIMITER $$

CREATE FUNCTION FormatandoCPF(ClienteID INT)
RETURNS VARCHAR(50) DETERMINISTIC
BEGIN
    DECLARE NovoCPF VARCHAR(50);

    SELECT CONCAT(
        SUBSTRING(cpf, 1, 3), '.', 
        SUBSTRING(cpf, 4, 3), '.',
        SUBSTRING(cpf, 7, 3), '-',
        SUBSTRING(cpf, 10, 2)
    )
    INTO NovoCPF
    FROM clientes
    WHERE cliente_id = ClienteID;

    RETURN NovoCPF;
END$$

DELIMITER ;

SELECT FormatandoCPF(1) AS CPF;

SELECT TRIM(nome) Nome, FormatandoCPF(1) AS CPF FROM clientes WHERE cliente_id = 1;