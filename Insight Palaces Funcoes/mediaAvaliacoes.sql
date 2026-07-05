-- Criação de função
DELIMITER $$
CREATE FUNCTION RetornoConstante()
RETURNS VARCHAR(50) DETERMINISTIC
BEGIN

RETURN 'Seja bem vindo(a)';

END $$
DELIMITER ;

SELECT RetornoConstante();

-- Função
DELIMITER $$
CREATE FUNCTION MediaAvaliacoes()
RETURNS FLOAT DETERMINISTIC
BEGIN

DECLARE media FLOAT; 
SELECT ROUND(AVG(nota),2) MediaNotas 
INTO media
FROM avaliacoes;
RETURN media;

END$$

DELIMITER ;

SELECT MediaAvaliacoes();


