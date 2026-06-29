# Title
Zoo Management Data Warehouse and Analytics System

## Goal of analytics
To analyze zoo operations by evaluating ticket sales, visitor behavior, and animal feeding patterns to support data-driven management decisions.

## Short description
The project is based on a relational OLTP database and a dimensional OLAP model. Data is loaded from CSV files into the OLTP system, then transferred via ETL (postgres_fdw) into a data warehouse. Power BI is used to visualize key metrics such as revenue, visitor types, and resource consumption.


## NOTE
For DimEmployee to use the correct start and end dates in the DWH (instead of the CURRENT_DATE), script 05_etl.sql needs to be updated with:

```
-- 6. DIM EMPLOYEE (SCD TYPE 2)

-- STEP 1: закрыть старую запись
UPDATE dimemployee de
SET enddate = e.hiredate - 1,
    iscurrent = FALSE
FROM oltp.employees e
WHERE de.employeeid = e.employeeid
  AND de.iscurrent = TRUE
  AND de.position <> e.position;


-- STEP 2: вставить новую запись
INSERT INTO dimemployee
(
    employeeid,
    firstname,
    lastname,
    position,
    startdate,
    enddate,
    iscurrent
)
SELECT
    e.employeeid,
    e.firstname,
    e.lastname,
    e.position,
    e.hiredate,
    NULL,
    TRUE
FROM oltp.employees e
LEFT JOIN dimemployee de
       ON de.employeeid = e.employeeid
      AND de.iscurrent = TRUE
WHERE de.employeeid IS NULL
   OR de.position <> e.position;
```
