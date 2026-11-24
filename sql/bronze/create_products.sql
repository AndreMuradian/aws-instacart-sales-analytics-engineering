CREATE EXTERNAL TABLE IF NOT EXISTS vendas.products (
    product_id INT,
    product_name STRING,
    aisle_id INT,
    department_id INT
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
    'separatorChar' = ',',
    'quoteChar' = '"'
)
STORED AS TEXTFILE
LOCATION 's3://SEU-BUCKET-us-east-2-an/instacard_bruto/products/'
TBLPROPERTIES (
    'skip.header.line.count' = '1',
    'classification' = 'csv'
);
