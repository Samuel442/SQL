


-- Criação da tabela Calendario com colunas essenciais
CREATE TABLE Calendario (
    Data DATE PRIMARY KEY,       -- Coluna para armazenar a data, que será única (chave primária)
    Ano INT,                     -- Coluna para armazenar o ano da data
    Mes INT,                     -- Coluna para armazenar o número do mês (1 a 12)
    Dia INT,                     -- Coluna para armazenar o número do dia (1 a 31)
    DiaSemana VARCHAR(50)        -- Coluna para armazenar o nome do dia da semana (por exemplo, "Monday")
);

-- Passo 2: Definir o intervalo de datas
DECLARE @DataInicial DATE = '2017-01-02'; -- Define a data inicial do intervalo (ajustável)
DECLARE @DataFinal DATE = '2017-05-16';   -- Define a data final do intervalo (ajustável)

-- Passo 3: Preencher a tabela calendário
DECLARE @DataAtual DATE = @DataInicial;   -- Inicializa a variável com a data inicial

-- Loop para preencher a tabela com todas as datas no intervalo definido
WHILE @DataAtual <= @DataFinal            -- Continua enquanto a data atual estiver no intervalo
BEGIN
    -- Insere uma nova linha na tabela Calendario com os valores calculados
    INSERT INTO Calendario (Data, Ano, Mes, Dia, DiaSemana)
    VALUES (
        @DataAtual,                       -- Data atual
        YEAR(@DataAtual),                 -- Ano da data atual
        MONTH(@DataAtual),                -- Mês da data atual
        DAY(@DataAtual),                  -- Dia da data atual
        DATENAME(WEEKDAY, @DataAtual)     -- Nome do dia da semana da data atual (ex.: "Monday")
    );
    
    -- Incrementa a data atual em 1 dia
    SET @DataAtual = DATEADD(DAY, 1, @DataAtual);
END;

