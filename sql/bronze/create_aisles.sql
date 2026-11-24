-- OBSERVAÇÃO:
-- A tabela original foi criada manualmente pelo
-- AWS Glue Data Catalog em 23/11/2026.
-- Este SQL documenta uma forma de reproduzir sua estrutura.

CREATE EXTERNAL TABLE IF NOT EXISTS vendas.aisles (
    aisle_id INT,
    aisle STRING
)
ROW FORMAT SERDE
    'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
    'separatorChar' = ',',
    'quoteChar' = '"'
)
STORED AS TEXTFILE
LOCATION 's3://SEU-BUCKET-us-east-2-an/instacard_bruto/aisles/'
TBLPROPERTIES (
    'skip.header.line.count' = '1',
    'classification' = 'csv'
);
