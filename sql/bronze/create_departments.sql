CREATE EXTERNAL TABLE IF NOT EXISTS vendas.departments (
    department_id INT,
    department STRING
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
    'separatorChar' = ',',
    'quoteChar' = '"'
)
STORED AS TEXTFILE
LOCATION 's3://SEU-BUCKET-us-east-2-an/instacard_bruto/departaments/'
TBLPROPERTIES (
    'skip.header.line.count' = '1',
    'classification' = 'csv'
);
