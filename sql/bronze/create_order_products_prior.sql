CREATE EXTERNAL TABLE IF NOT EXISTS vendas.order_products_prior (
    order_id BIGINT,
    product_id INT,
    add_to_cart_order INT,
    reordered INT
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
    'separatorChar' = ',',
    'quoteChar' = '"'
)
STORED AS TEXTFILE
LOCATION 's3://SEU-BUCKET-us-east-2-an/instacard_bruto/order_products__prior/'
TBLPROPERTIES (
    'skip.header.line.count' = '1',
    'classification' = 'csv'
);
