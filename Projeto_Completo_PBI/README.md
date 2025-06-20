# 📊 Análise de Dados Netflix – Brasil & Internacional

Este projeto de Business Intelligence foi desenvolvido no **Power BI** com o objetivo de analisar e visualizar o consumo de conteúdo da **Netflix**, tanto no contexto nacional (Brasil) quanto internacional, utilizando dados limpos e tratados previamente no **SQL Server (SSMS)** fictícios.

---

## 🧠 Objetivo do Projeto

> Criar um dashboard interativo e visualmente atraente com insights relevantes sobre acessos, planos, dispositivos e comportamento de usuários da Netflix em diferentes regiões e períodos.

---

## 🛠️ Tecnologias Utilizadas

- **Power BI Desktop**
- **SQL Server Management Studio (SSMS)**
- **DAX (Data Analysis Expressions)**
- **Modelagem Estrela**
- **Tabelas Fato e Dimensão (dCalendario)**

---

## 🧱 Estrutura do Projeto

### 🔸 Fontes de Dados

- `vw_base_estados_tratada`  
  ↳ Dados da Netflix no Brasil (estados, planos, gêneros, acessos)

- `vw_base_paises_tratada`  
  ↳ Dados internacionais (país, continente, dispositivo, tempo médio)

- `dCalendario`  
  ↳ Tabela calendário completa (data, ano, mês, etc)

### 🔸 Relacionamentos

- **`dCalendario[Data]`** → relacionado com **`[DATA]`** em ambas as tabelas fato (Brasil e Internacional)  
- Relacionamento do tipo **Um para Muitos** (1:*), ideal para segmentações por tempo

---

## 📈 Métricas Criadas (DAX)

### Brasil

- `TotalAcessos` – Total de acessos por estado, plano ou período
- `FaturamentoTotal` – Soma de acessos × valor do plano
- `AcessosUltimoDia` – Acessos do último dia registrado
- `CrescimentoPercentualAcessos` – Evolução percentual dos acessos
- `AcessosPorGenero`, `AcessosPorPeriodo`, `AcessosPorTipoConta`

### Internacional

- `TotalDispositivos` – Soma de dispositivos conectados por país
- `TempoMedioSegundos` – Tempo médio de acesso em segundos
- `TempoMedioFormatado` – Tempo médio formatado (hh:mm:ss)
- `PaisMaiorTempoAcesso` – País com maior tempo médio
- `DispositivoMaisUsado` – Dispositivo com maior uso total

---

## 🖼️ Layout e Visualizações

O projeto foi dividido em duas páginas:

### 📍 Página 1 – Brasil
- **Cartões com KPIs**:
  - Total de Acessos
  - Faturamento Total
  - Acessos no Último Dia
- **Gráficos**:
  - Coluna: Acessos por Tipo de Conta
  - Tabela: Acessos por Período de Acesso
  - Barras horizontais: Acessos por Gênero
  - Linha do tempo: Evolução de Faturamento

### 🌍 Página 2 – Internacional
- **Cartões com insights**:
  - Dispositivo mais usado
  - País com maior tempo médio de acesso
- **Gráficos**:
  - Mapa: Total de dispositivos por país
  - Coluna: Dispositivos por continente
  - Linha: Tempo médio ao longo do tempo
- **Segmentador de datas** com base em `dCalendario`

---

## 🎨 Tema Visual

- **Paleta Netflix**:
  - Fundo escuro (`#121212`)
  - Destaques em vermelho (`#E50914`)
  - Tipografia em branco e cinza claro
- **Gráficos limpos, responsivos**

---

## 🔍 Insights Extraídos

- Estados com maior número de acessos e faturamento no Brasil
- Planos mais escolhidos por faixa de horário e gênero
- Países com maior engajamento em tempo médio de sessão
- Dispositivos mais populares globalmente
- Comparações temporais por dia, mês ou faixa horária

---

## 🧩 Melhorias Futuras

- Adicionar segmentações por dispositivo na página do Brasil
- Aplicar RLS (Row-Level Security) para perfis regionais
- Exportar relatórios PDF automáticos via Power Automate

---

## 📌 Sobre o Autor

**Samuel Henrique**  
Estudante e profissional de dados. Este projeto foi feito para fins de estudo e portfólio.

📫 [LinkedIn](https://www.linkedin.com/in/samuel-henrique-lima-da-silva/)  

---

## ⭐ Se você gostou do projeto, não esqueça de deixar uma estrela no repositório!

