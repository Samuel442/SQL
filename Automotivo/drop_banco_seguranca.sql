/*******************************************************************************
        EV_BYD_Motors - ARQUITETURA DE DATA WAREHOUSE (AMBIENTE DE DEV)
        SCRIPT DE RESET INTEGRAL E LIMPEZA DE ESTRUTURAS (BLOCOS 1 AO 7)
********************************************************************************

[POR QUE ESTE SCRIPT EXISTE E QUANDO ELE DEVE SER UTILIZADO?]

1. FINALIDADE PRINCIPAL (BOTÃO DE REINICIALIZAÇÃO DO AMBIENTE):
   Este script tem como único objetivo destruir (DROP) de forma segura e limpa 
   todas as tabelas Fato e Dimensão criadas ao longo dos Blocos 1 a 7 do projeto.
   Ele funciona como um "cinto de segurança" para o Engenheiro de Dados durante
   a fase de design, permitindo que a estrutura física seja reconstruída do zero
   em segundos caso o modelo precise de alterações de colunas, tipos ou regras.

2. A REGRA DE OURO DA INTEGRIDADE REFERENCIAL (A ORDEM DOS FATOS):
   Bancos de dados relacionais possuem travas de segurança rígidas. Uma tabela
   Dimensão (tabela-pai) NÃO PODE ser excluída se houver uma tabela Fato 
   (tabela-filha) apontando para ela através de chaves estrangeiras (Foreign Keys).
   Ao tentar rodar um 'DROP TABLE Dim_Planta' isoladamente, o banco bloqueará
   a execução gerando um erro de violação de constraint.

   Por este motivo, o desmonte da arquitetura segue uma ordem cirúrgica em cascata:
     - PASSO 1: Cortamos as amarras deletando primeiro TODAS as tabelas Fato.
     - PASSO 2: Com as fatos eliminadas, as Dimensões ficam livres e isoladas.
     - PASSO 3: Deletamos as Dimensões Específicas e depois as Conformadas (Base).

3. CENÁRIOS DE USO NO DIA A DIA (QUANDO EXECUTAR?):
   - Design Iterativo: Caso mudar de ideia sobre o nome ou tipo de uma coluna.
   - Automação (CI/CD): Para robôs testarem a integridade dos seus scripts DDL.
   - Erros de Carga (DML): Se os dados de teste entrarem duplicados ou corrompidos,
     é mais seguro resetar a estrutura física do que tentar limpar linha por linha.

 AVISO DE SEGURANÇA: Este script é estritamente de uso para o ambiente de 
DESENVOLVIMENTO (Dev) e homologação. Ele NUNCA deve ser executado em ambiente de 
PRODUÇÃO (onde os dados reais da fábrica BYD estão consolidados)!
*******************************************************************************/

-- Conectando ao banco antes de rodar a limpeza
USE EV_BYD_Motors;

/*******************************************************************************
1. SCRIPT DE RESET TOTAL E LIMPEZA (VERSÃO CORRIGIDA E UNIFICADA)
*******************************************************************************/

-- =============================================================================
-- PASSO 1: TABELAS FATO (Deletadas primeiro para eliminar as chaves estrangeiras)
-- =============================================================================
DROP TABLE IF EXISTS Fato_Compras;
DROP TABLE IF EXISTS Fato_Logistica;
DROP TABLE IF EXISTS Fato_Estoque;
DROP TABLE IF EXISTS Fato_Manutencao;
DROP TABLE IF EXISTS Fato_Qualidade;
DROP TABLE IF EXISTS Fato_Producao;
DROP TABLE IF EXISTS Fato_Vendas;

-- =============================================================================
-- PASSO 2: TABELAS DIMENSÃO ESPECÍFICAS 
-- =============================================================================
DROP TABLE IF EXISTS Dim_Transportadora;
DROP TABLE IF EXISTS Dim_Armazem;
DROP TABLE IF EXISTS Dim_Tecnico;
DROP TABLE IF EXISTS Dim_Motivo_Parada;
DROP TABLE IF EXISTS Dim_Peca;
DROP TABLE IF EXISTS Dim_Fornecedor;
DROP TABLE IF EXISTS Dim_Defeito;
DROP TABLE IF EXISTS Dim_Maquina;

-- =============================================================================
-- PASSO 3: TABELAS DIMENSÃO CONFORMADAS (Base compartilhada por todo o DW)
-- =============================================================================
DROP TABLE IF EXISTS Dim_Operador;
DROP TABLE IF EXISTS Dim_Turno;
DROP TABLE IF EXISTS Dim_Linha_Producao;
DROP TABLE IF EXISTS Dim_Planta;
DROP TABLE IF EXISTS Dim_Produto;
DROP TABLE IF EXISTS Dim_Modelo_Veiculo;
DROP TABLE IF EXISTS Dim_Tempo;
DROP TABLE IF EXISTS Dim_Cliente;
DROP TABLE IF EXISTS Dim_Regiao;
DROP TABLE IF EXISTS Dim_Vendedor;
DROP TABLE IF EXISTS Dim_Canal_Venda;