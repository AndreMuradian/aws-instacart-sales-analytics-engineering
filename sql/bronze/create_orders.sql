CREATE EXTERNAL TABLE IF NOT EXISTS vendas.orders (
    order_id BIGINT,
    user_id BIGINT,
    eval_set STRING,
    order_number INT,
    order_dow INT,
    order_hour_of_day INT,
    days_since_prior_order DOUBLE
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
    'separatorChar' = ',',
    'quoteChar' = '"'
)
STORED AS TEXTFILE
LOCATION 's3://SEU-BUCKET-us-east-2-an/instacard_bruto/orders/'
TBLPROPERTIES (
    'skip.header.line.count' = '1',
    'classification' = 'csv'
);
