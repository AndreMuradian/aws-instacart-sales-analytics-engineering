# Analytics Engineering na AWS | Instacart

> **Dataset:** Instacart Market Basket Analysis  
> **Foco:** Engenharia analítica, modelagem dimensional, qualidade de dados e otimização do Apache Spark.

## Visão geral

Este projeto tem como objetivo simular desafios reais de um **Analytics Engineer** por meio da construção de uma plataforma analítica na **AWS**. A fonte de dados é o *Instacart Market Basket Analysis*, conjunto público que descreve o histórico de pedidos e produtos de um supermercado online.


## Objetivos

- Ingerir e catalogar arquivos brutos no Amazon S3.
- Construir as camadas **Bronze, Silver e Gold** seguindo a arquitetura Medallion.
- Tratar tipos, valores ausentes, duplicidades e integridade referencial usando PySpark.
- Criar um modelo dimensional para consultas analíticas.
- Disponibilizar dados para consulta com Amazon Athena.
- Comparar estratégias de processamento do Spark com medições reproduzíveis.
- Documentar decisões técnicas, qualidade dos dados, custo e resultados.

## Tecnologias previstas

| Tecnologia | Finalidade |
|---|---|
| Amazon S3 | Armazenamento das camadas do data lake |
| AWS Glue / PySpark | Processamento distribuído e pipelines ETL |
| AWS Glue Data Catalog | Metadados e catálogo de tabelas |
| Amazon Athena | Consultas SQL sobre os dados tratados |
| Amazon CloudWatch | Logs e monitoramento das execuções |
| Apache Spark UI | Diagnóstico de stages, tasks, shuffle e spill |
| Parquet | Formato colunar nas camadas tratadas |

**Extensões opcionais:** EventBridge e Step Functions para agendamento/orquestração; ferramenta de BI para dashboards.

## Dataset e volume

**Fonte:** [Instacart Market Basket Analysis (Kaggle)](https://www.kaggle.com/datasets/yasserh/instacart-online-grocery-basket-analysis-dataset).

| Arquivo original | Registros aproximados | Descrição |
|---|---:|---|
| `orders.csv` | 3.421.083 | Pedidos e histórico sequencial de clientes |
| `order_products__prior.csv` | 32.434.489 | Itens de pedidos anteriores |
| `order_products__train.csv` | 1.384.617 | Itens de pedidos de treinamento |
| `products.csv` | 49.688 | Cadastro de produtos |
| `aisles.csv` | 134 | Corredores/categorias operacionais |
| `departments.csv` | 21 | Departamentos |
| **Total** | **37.290.032** | **Contagem aproximada dos seis arquivos** |

### Relacionamentos principais

**Limitações dos dados:** não há preços, receita ou timestamps absolutos de pedidos. Portanto, não serão apresentados indicadores financeiros ou evolução em datas reais sem enriquecimento externo ou simulação explicitamente identificada.

## Arquitetura proposta

```text
Instacart (CSV)
      |
      v
Amazon S3 / Bronze (arquivos originais)
      |
      v
AWS Glue / PySpark + Data Catalog
      |
      v
Amazon S3 / Silver (dados validados em Parquet)
      |
      v
AWS Glue / PySpark (regras de negócio e modelo dimensional)
      |
      v
Amazon S3 / Gold (fatos, dimensões e agregados)
      |
      v
Amazon Athena -> consultas analíticas / dashboards

CloudWatch + Spark UI -> observabilidade e análise de performance
```

### Camadas do data lake

| Camada | Responsabilidade | Saída prevista |
|---|---|---|
| **Bronze** | Preservar arquivos de origem e metadados de carga | CSV bruto |
| **Silver** | Padronizar esquema, corrigir tipos, validar integridade e consolidar itens | Parquet tratado |
| **Gold** | Aplicar regras de negócio e disponibilizar modelo analítico | Fatos, dimensões e agregados |

## Organização prevista do repositório

```text
.
├── README.md
├── architecture/
│   └── README.md
├── src/
│   ├── bronze/
│   ├── silver/
│   └── gold/
├── sql/
├── tests/
├── performance/
│   ├── README.md
│   └── benchmark_results.csv
├── dashboards/
└── docs/
    ├── data_dictionary.md
    └── technical_decisions.md
```


## Como reproduzir (roteiro inicial)

1. Obtenha os seis arquivos CSV na [página oficial do desafio no Kaggle](https://www.kaggle.com/datasets/yasserh/instacart-online-grocery-basket-analysis-dataset) e verifique as condições de acesso e uso.
2. Crie um bucket S3 em sua própria conta, seguindo uma convenção como `s3://SEU-BUCKET/bronze/instacart/`.
3. Envie os CSVs para a Bronze, sem alterar os arquivos de origem.
4. Configure permissões IAM mínimas necessárias para S3, Glue, catálogo e logs.
5. Execute os jobs de tratamento e valide contagens, esquema e chaves antes de gravar a Silver.
6. Gere as tabelas Gold, registre-as no Data Catalog e consulte-as via Athena.
7. Rode os experimentos com configurações controladas e registre os resultados em `performance/`.


## Fonte

- [Instacart Market Basket Analysis — Kaggle](https://www.kaggle.com/datasets/yasserh/instacart-online-grocery-basket-analysis-dataset)

---

**Projeto de estudos e portfólio.** Não é uma implementação oficial nem possui vínculo com o Instacart.
