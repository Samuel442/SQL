USE insight_places;

CREATE TABLE proprietarios (
proprietario_id VARCHAR(255) PRIMARY KEY,
nome VARCHAR(255),
cpf_cnpj VARCHAR(20),
contato VARCHAR(255)
);

CREATE TABLE clientes (
    cliente_id VARCHAR(255) PRIMARY KEY,
    nome VARCHAR(255),
    cpf VARCHAR(14),
    contato VARCHAR(255)
);

CREATE TABLE enderecos (
    endereco_id VARCHAR(255) PRIMARY KEY,
    rua VARCHAR(255),
    numero INT,
    bairro VARCHAR(255),
    cidade VARCHAR(255),
    estado VARCHAR(2),
    cep VARCHAR(10)
);

CREATE TABLE hospedagens (
    hospedagem_id VARCHAR(255) PRIMARY KEY,
    tipo VARCHAR(50),
    endereco_id VARCHAR(255),
    proprietario_id VARCHAR(255),
	ativo BOOL,
    FOREIGN KEY (endereco_id) REFERENCES enderecos(endereco_id),
    FOREIGN KEY (proprietario_id) REFERENCES proprietarios(proprietario_id)
);

CREATE TABLE alugueis (
    aluguel_id VARCHAR(255) PRIMARY KEY,
    cliente_id VARCHAR(255),
    hospedagem_id VARCHAR(255),
    data_inicio DATE,
    data_fim DATE,
    preco_total DECIMAL(10, 2),
    FOREIGN KEY (cliente_id) REFERENCES clientes(cliente_id),
    FOREIGN KEY (hospedagem_id) REFERENCES hospedagens(hospedagem_id)
);

CREATE TABLE avaliacoes (
avaliacao_id VARCHAR(255) PRIMARY KEY,
cliente_id VARCHAR(255),
hospedagem_id VARCHAR(255),
nota INT,
comentario TEXT,
FOREIGN KEY (cliente_id) REFERENCES clientes(cliente_id),
FOREIGN KEY (hospedagem_id) REFERENCES hospedagens(hospedagem_id)
);

-------------------------------------
/*Consultas*/
-------------------------------------
SELECT * FROM enderecos;
SELECT * FROM clientes;
SELECT * FROM proprietarios;
SELECT * FROM hospedagens;
SELECT * FROM alugueis;
SELECT * FROM avaliacoes;

-------------------------------------
/*Consultas com filtros*/
-------------------------------------

-- hospedagens mais bem avaliadas
SELECT * FROM avaliacoes
WHERE nota >= 4;

-- hospedagens ativas do tipo hotel
SELECT * FROM hospedagens
WHERE tipo = 'hotel' AND ativo = 1;

-- gasto médio de cada cliente
SELECT cliente_id, AVG(preco_total)  AS ticket_medio
FROM alugueis 
GROUP BY cliente_id;

-- media de dias de estadia de cada cliente
SELECT cliente_id, AVG(DATEDIFF(data_fim,data_inicio)) AS media_dias_estadia
FROM alugueis
GROUP BY cliente_id
ORDER BY media_dias_estadia DESC;

-- top 10 proprietários com mais hospedagens ativo na plataforma
SELECT p.nome AS nome_proprietario, COUNT(h.hospedagem_id)
AS total_hospedagens_ativas
FROM proprietarios p
JOIN hospedagens h ON p.proprietario_id = h.proprietario_id
WHERE h.ativo = 1
GROUP BY p.nome
ORDER BY total_hospedagens_ativas DESC
LIMIT 10; 

-- Número de hospedagens inativas por proprietário
SELECT p.nome AS nome_proprietario, COUNT(*) AS total_hospedagens_inativas
FROM proprietarios p
JOIN hospedagens h ON p.proprietario_id = 
h.proprietario_id
WHERE h.ativo = 0
GROUP BY p.nome;

-- períodos de maior e menor demanda de aluguel na plataforma
SELECT YEAR(data_inicio) AS ano,
MONTH(data_inicio) AS mes,
COUNT(*) AS total_alugueis
FROM alugueis
GROUP BY ano, mes 
ORDER BY total_alugueis DESC;

-- inserir coluna de quantidades de hospedagens
ALTER TABLE proprietarios 
ADD COLUMN qtd_hospedagens INT;

-- renomeando tabela
ALTER TABLE alugueis RENAME TO reservas;

-- renomeando a coluna alugueis
ALTER TABLE reservas RENAME COLUMN aluguel_id TO reserva_id;

-- 
UPDATE hospedagens 
SET ativo = 1
WHERE hospedagem_id IN ('1', '10', '100');

-- 
UPDATE proprietarios
SET contato = 'daniela_120@email.com'
WHERE proprietario_id = '1009';

--
DELETE FROM avaliacoes
WHERE hospedagem_id IN ('10000', '1001');

--
DELETE FROM reservas
WHERE hospedagem_id IN('10000', '1001');

--
DELETE FROM hospedagens
WHERE hospedagem_id IN ('10000','1001');