CREATE SCHEMA IF NOT EXISTS iceberg.test WITH (location = 's3://warehouse/test');

CREATE TABLE IF NOT EXISTS iceberg.test.employees_test (name varchar, salary decimal(10,2)) WITH ( format = 'PARQUET' );

INSERT INTO example.example_s3_schema.employees_test (name, salary) VALUES ('Sam Evans', 55000);