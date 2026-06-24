-- SELECT *
-- FROM oltp.employees
-- WHERE employeeid = 2;

DROP SCHEMA IF EXISTS oltp CASCADE;
DROP SERVER IF EXISTS zoo_oltp_server CASCADE;

CREATE EXTENSION IF NOT EXISTS postgres_fdw;

CREATE SERVER zoo_oltp_server
FOREIGN DATA WRAPPER postgres_fdw
OPTIONS (
    host 'localhost',
    dbname 'zoo_oltp',
    port '5432'
);

CREATE USER MAPPING FOR CURRENT_USER
SERVER zoo_oltp_server
OPTIONS (
    user 'postgres',
    password 'postgres'
);

CREATE SCHEMA oltp;

IMPORT FOREIGN SCHEMA public
FROM SERVER zoo_oltp_server
INTO oltp;