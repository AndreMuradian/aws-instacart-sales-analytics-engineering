# Etapa 01 — Ingestão e catalogação (Bronze)

**Projeto:** AWS Instacart Analytics Engineering  
**Data do registro:** 23/11/2026  
**Status:** Catálogo inicial criado; verificações completas ainda pendentes.

## Objetivo

Armazenar os arquivos CSV originais do Instacart no Amazon S3 e registrar seus schemas no AWS Glue Data Catalog para consulta pelo Amazon Athena, preservando os arquivos brutos.

## Serviços utilizados

| Serviço | Utilização |
|---|---|
| Amazon S3 | Upload e armazenamento dos seis arquivos CSV |
| AWS Glue Data Catalog | Database `vendas` e catálogo de tabelas |
| Amazon Athena | Execução de SQL para registrar as demais tabelas e consultar os dados |
| AWS IAM | Criação e configuração de função para tentativa de Crawler |
| AWS CloudTrail | Diagnóstico do erro de criação de Crawler |

## Arquivos do dataset

| Tabela | Linhas esperadas no conjunto original |
|---|---:|
| `aisles` | 134 |
| `departments` | 21 |
| `products` | 49.688 |
| `orders` | 3.421.083 |
| `order_products_prior` | 32.434.489 |
| `order_products_train` | 1.384.617 |

Fonte: [Instacart Market Basket Analysis — Kaggle](https://www.kaggle.com/competitions/instacart-market-basket-analysis/data). As contagens são referências do conjunto original, **não resultados de validação já executada**.

## Atividades realizadas em 23/11/2026

### 1. Upload no S3

Os arquivos CSV do Instacart foram carregados no S3, sob o prefixo `instacard_bruto/`. Foram organizados caminhos específicos por tabela para que cada definição do catálogo aponte apenas aos arquivos com o schema correspondente.

Exemplo genérico (substituir `SEU-BUCKET` pela localização do ambiente):

```text
s3://SEU-BUCKET/instacard_bruto/
├── aisles/aisles.csv
├── departments/departments.csv
├── products/products.csv
├── orders/orders.csv
├── order_products_prior/order_products__prior.csv
└── order_products_train/order_products__train.csv
```

> A estrutura acima representa a organização prevista para os caminhos de tabela; confirme no console S3 o conteúdo de cada pasta antes de reproduzir.

### 2. Criação **manual** da tabela `aisles` no Glue Data Catalog

A tabela **`vendas.aisles` foi criada manualmente pelo console AWS Glue Data Catalog**, na opção de adicionar tabela e definir o schema. **Não foi criada pelo Crawler nem pelo comando `CREATE TABLE` do Athena.**

Configurações utilizadas:

| Campo | Valor |
|---|---|
| Database | `vendas` |
| Tabela | `aisles` |
| Fonte | Amazon S3 |
| Classificação | CSV |
| Location | `s3://SEU-BUCKET/instacard_bruto/aisles/` |
| Coluna 1 | `aisle_id` — `int` |
| Coluna 2 | `aisle` — `string` |
| Partições / índices | Nenhum |

### 3. Criação das outras tabelas pelo Athena

As tabelas `departments`, `products`, `orders`, `order_products_prior` e `order_products_train` foram registradas por instruções SQL no Amazon Athena, usando o database `vendas`, o formato CSV e os caminhos correspondentes no S3. O Athena utiliza o Glue Data Catalog para armazenar seus metadados.

### 4. Tratamento do cabeçalho CSV

Durante a consulta à `aisles`, o Athena retornou `BAD_DATA` porque tentou converter o valor textual do cabeçalho `aisle_id` para `int`. A correção indicada foi configurar o descarte da primeira linha:

```sql
ALTER TABLE vendas.aisles
SET TBLPROPERTIES (
    'skip.header.line.count' = '1'
);
```

A mesma propriedade foi considerada nos scripts das demais tabelas. **A leitura bem-sucedida após esse ajuste ainda deve ser verificada e registrada com os resultados das consultas.**

### 5. Tentativa de uso do Glue Crawler

A criação do Crawler `crawler-instacart-bronze` falhou com `AccessDenied` e a mensagem de que a conta não tinha acesso. O evento `CreateCrawler` foi localizado no CloudTrail. Mesmo após uma tentativa de configuração de IAM Role, a criação permaneceu bloqueada. A causa raiz não foi confirmada; optou-se por catalogar manualmente os dados para continuar o exercício.

## Modelo de dados registrado

| Tabela | Campos e tipos |
|---|---|
| `aisles` | `aisle_id int`, `aisle string` |
| `departments` | `department_id int`, `department string` |
| `products` | `product_id int`, `product_name string`, `aisle_id int`, `department_id int` |
| `orders` | `order_id bigint`, `user_id bigint`, `eval_set string`, `order_number int`, `order_dow int`, `order_hour_of_day int`, `days_since_prior_order double` |
| `order_products_prior` | `order_id bigint`, `product_id int`, `add_to_cart_order int`, `reordered int` |
| `order_products_train` | `order_id bigint`, `product_id int`, `add_to_cart_order int`, `reordered int` |



