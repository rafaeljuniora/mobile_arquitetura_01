# Atividade 2 - Arquitetura em Camadas

Aplicação Flutter que consome a Fake Store API com arquitetura em camadas:

- presentation: interface e estado visual
- domain: entidades e contratos
- data: repositório e data sources
- core: cliente HTTP

## Melhorias implementadas

1. **Estado da interface**
	- Estado de carregamento
	- Estado de erro
	- Estado de sucesso

2. **Tratamento de erros**
	- Falhas de API são capturadas no Repository e propagadas ao ViewModel
	- A UI exibe mensagem de erro ao usuário

3. **Cache local simples**
	- Cache de produtos com SharedPreferences
	- Em caso de falha na API, o Repository usa os dados em cache

## Regras arquiteturais aplicadas

- A UI não realiza chamadas HTTP diretamente
- O ViewModel coordena o estado da aplicação
- O Repository decide a fonte dos dados
- Os DataSources executam apenas operações de I/O

## Questionário de Reflexão (Atividade 2)

### 1) Em qual camada foi implementado o mecanismo de cache? Por que essa decisão é adequada?

O cache foi implementado na camada data, no ProductLocalDatasource, e orquestrado pelo ProductRepositoryImpl. Isso é adequado porque cache é detalhe de infraestrutura, não regra de negócio e nem responsabilidade da interface.

### 2) Por que o ViewModel não deve realizar chamadas HTTP diretamente?

Porque o ViewModel deve coordenar estado e fluxo da tela, não detalhes de comunicação. Se ele chamasse HTTP diretamente, haveria alto acoplamento com infraestrutura, menor testabilidade e quebra da separação de responsabilidades.

### 3) O que poderia acontecer se a interface acessasse diretamente o DataSource?

A UI ficaria acoplada aos detalhes de dados e transporte, dificultando manutenção, testes e evolução da aplicação. Mudanças na API impactariam diretamente widgets/telas, aumentando risco de regressão.

### 4) Como essa arquitetura facilitaria a substituição da API por um banco de dados local?

Basta trocar as implementações na camada data, por exemplo, novo datasource local e lógica do repositório, mantendo o contrato em domain. Como ViewModel e UI dependem do contrato, a troca não exige refatoração grande nas camadas superiores.