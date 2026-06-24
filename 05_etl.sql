-- ETL PROCESS (RERUNNABLE) OLTP -> OLAP

-- 1. DIM DATE
INSERT INTO DimDate (DateID, FullDate, Day, Month, Year, Quarter)
SELECT DISTINCT
    TO_CHAR(d::DATE, 'YYYYMMDD')::INT,
    d::DATE,
    EXTRACT(DAY FROM d)::INT,
    EXTRACT(MONTH FROM d)::INT,
    EXTRACT(YEAR FROM d)::INT,
    EXTRACT(QUARTER FROM d)::INT
FROM (
    SELECT SaleDate AS d FROM oltp.ticketsales
    UNION
    SELECT FeedingDate FROM oltp.feedings
) t
WHERE NOT EXISTS (
    SELECT 1 FROM DimDate dd
    WHERE dd.DateID = TO_CHAR(t.d::DATE, 'YYYYMMDD')::INT
);


-- 2. DIM SPECIES
INSERT INTO DimSpecies (SpeciesID, SpeciesName, HabitatType, DietType)
SELECT
    s.SpeciesID,
    s.SpeciesName,
    s.HabitatType,
    s.DietType
FROM oltp.species s
WHERE NOT EXISTS (
    SELECT 1 FROM DimSpecies d
    WHERE d.SpeciesID = s.SpeciesID
);


-- 3. DIM ANIMAL
INSERT INTO DimAnimal (AnimalID, AnimalName, Gender, BirthDate, SpeciesID)
SELECT
    a.AnimalID,
    a.AnimalName,
    a.Gender,
    a.BirthDate,
    a.SpeciesID
FROM oltp.animals a
WHERE NOT EXISTS (
    SELECT 1 FROM DimAnimal d
    WHERE d.AnimalID = a.AnimalID
);


-- 4. DIM VISITOR
INSERT INTO DimVisitor (VisitorID, City, VisitorType)
SELECT
    v.VisitorID,
    v.City,
    v.VisitorType
FROM oltp.visitors v
WHERE NOT EXISTS (
    SELECT 1 FROM DimVisitor d
    WHERE d.VisitorID = v.VisitorID
);


-- 5. DIM TICKET TYPE
INSERT INTO DimTicketType (TicketTypeID, TicketType, Price)
SELECT
    t.TicketTypeID,
    t.TicketType,
    t.Price
FROM oltp.tickettypes t
WHERE NOT EXISTS (
    SELECT 1 FROM DimTicketType d
    WHERE d.TicketTypeID = t.TicketTypeID
);


-- 6. DIM EMPLOYEE (SCD TYPE 2)
-- STEP 1: закрыть старую запись
UPDATE dimemployee de
SET enddate = CURRENT_DATE - 1,
    iscurrent = FALSE
FROM oltp.employees e
WHERE de.employeeid = e.employeeid
  AND de.iscurrent = TRUE
  AND de.position <> e.position;


-- STEP 2: вставить НОВУЮ ВСЕГДА ТОЛЬКО ЕСЛИ:
-- либо нет записи вообще,
-- либо позиция изменилась

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
    CURRENT_DATE,
    NULL,
    TRUE
FROM oltp.employees e
LEFT JOIN dimemployee de
       ON de.employeeid = e.employeeid
      AND de.iscurrent = TRUE
WHERE de.employeeid IS NULL
   OR de.position <> e.position;


   

-- 7. BRIDGE TABLE
INSERT INTO BridgeAnimalSpecies (AnimalID, SpeciesID)
SELECT DISTINCT
    a.AnimalID,
    a.SpeciesID
FROM oltp.animals a
WHERE NOT EXISTS (
    SELECT 1
    FROM BridgeAnimalSpecies b
    WHERE b.AnimalID = a.AnimalID
      AND b.SpeciesID = a.SpeciesID
);


-- 8. FACT - TICKET SALES
INSERT INTO FactTicketSales
(
    SourceSaleID,
    DateID,
    VisitorID,
    TicketTypeID,
    Quantity,
    TotalAmount
)
SELECT
    ts.SaleID,
    TO_CHAR(ts.SaleDate,'YYYYMMDD')::INT,
    ts.VisitorID,
    ts.TicketTypeID,
    ts.Quantity,
    ts.Quantity * tt.Price
FROM oltp.TicketSales ts
JOIN oltp.TicketTypes tt
    ON tt.TicketTypeID = ts.TicketTypeID
WHERE NOT EXISTS
(
    SELECT 1
    FROM FactTicketSales f
    WHERE f.SourceSaleID = ts.SaleID
);


-- 9. FACT - FEEDINGS
INSERT INTO FactFeedings
(
    SourceFeedingID,
    DateID,
    AnimalID,
    EmployeeSK,
    FoodAmountKg
)
SELECT
    f.FeedingID,
    TO_CHAR(f.FeedingDate,'YYYYMMDD')::INT,
    f.AnimalID,
    de.EmployeeSK,
    f.FoodAmountKg
FROM oltp.Feedings f
JOIN DimEmployee de
    ON de.EmployeeID = f.EmployeeID
   AND de.IsCurrent = TRUE
WHERE NOT EXISTS
(
    SELECT 1
    FROM FactFeedings ff
    WHERE ff.SourceFeedingID = f.FeedingID
);