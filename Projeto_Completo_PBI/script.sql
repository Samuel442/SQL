CREATE DATABASE NetflixAnalise;
GO
USE NetflixAnalise;

SELECT TOP 10 * FROM base_geral;             
SELECT TOP 10 * FROM base_paises;

CREATE VIEW vw_base_geral_tratada AS
SELECT
    CAST(DATA AS DATE) AS data,                                                       -- tipo DATE
    ESTADOS,                                                                          -- tipo original (provavelmente VARCHAR)
    UF,                                                                               -- VARCHAR
    TOTAL_DE_ACESSOS,                                                                 -- INT
    PERIODO_DE_ACESSOS,                                                               -- VARCHAR
    QTDE_SEGMENTOS_ESTADOS,                                                           -- VARCHAR
    TIPO_DE_CONTA,                                                                    -- VARCHAR
    CAST(REPLACE(REPLACE(VALOR, 'R$', ''), ',', '.') AS DECIMAL(10,2)) AS valor_num,  -- tipo DECIMAL
    MONTH(CAST(DATA AS DATE)) AS mes,                                                 -- INT
    YEAR(CAST(DATA AS DATE)) AS ano                                                   -- INT
FROM base_geral;



CREATE VIEW vw_base_paises_tratada AS
SELECT
    CAST(Data AS DATE) AS data,
    País,
    Capital,
    Continente,
    Dispositivos_Conectados,
    Tipo_de_Acesso,
    Tempo_Média_de_Acesso,
    
    -- Tempo em segundos (convertido a partir do texto hh:mm:ss)
    DATEDIFF(SECOND, '00:00:00', Tempo_Média_de_Acesso) AS tempo_segundos,
    
    -- Mês e ano derivados da data
    MONTH(CAST(Data AS DATE)) AS mes,
    YEAR(CAST(Data AS DATE)) AS ano
FROM base_paises;


SELECT TOP 10 * FROM vw_base_geral_tratada;             
SELECT TOP 10 * FROM vw_base_paises_tratada;

-- checando os tipos de dados
EXEC sp_help vw_base_geral_tratada;
EXEC sp_help vw_base_paises_tratada;
