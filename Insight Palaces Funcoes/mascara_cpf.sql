-- retorna nome e contato
SELECT CONCAT(nome, ', O e-mail é: ' ,contato) FROM clientes;

-- remover espaços indesejados
SELECT CONCAT(TRIM(nome), ', O e-mail é: ' ,contato) FROM clientes;

-- mascarando cpf
SELECT
	TRIM(nome) Nome,
    CONCAT(SUBSTRING(cpf, 1, 3), '.', 
		   SUBSTRING(cpf, 4, 3), '.',
           SUBSTRING(cpf, 7, 3), '-',
           SUBSTRING(cpf, 10, 2)) AS CPF_Mascarado
FROM
 clientes;
    

    
    
    
    
    
    
    
    
