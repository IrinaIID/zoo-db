# Title
Zoo Management Data Warehouse and Analytics System

## Goal of analytics
To analyze zoo operations by evaluating ticket sales, visitor behavior, and animal feeding patterns to support data-driven management decisions.

## Short description
The project is based on a relational OLTP database and a dimensional OLAP model. Data is loaded from CSV files into the OLTP system, then transferred via ETL (postgres_fdw) into a data warehouse. Power BI is used to visualize key metrics such as revenue, visitor types, and resource consumption.
