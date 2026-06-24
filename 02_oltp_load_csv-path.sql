DROP TABLE IF EXISTS stg_species;

CREATE TEMP TABLE stg_species (
    SpeciesName VARCHAR(100),
    HabitatType VARCHAR(50),
    DietType VARCHAR(50)
);

COPY stg_species
FROM '<path-to-file>\species.csv'
DELIMITER ','
CSV HEADER;

INSERT INTO Species (
    SpeciesName,
    HabitatType,
    DietType
)
SELECT
    SpeciesName,
    HabitatType,
    DietType
FROM stg_species s
WHERE NOT EXISTS (
    SELECT 1
    FROM Species p
    WHERE p.SpeciesName = s.SpeciesName
);





DROP TABLE IF EXISTS stg_enclosures;

CREATE TEMP TABLE stg_enclosures (
    EnclosureName VARCHAR(100),
    Zone CHAR(1),
    Capacity INT
);

COPY stg_enclosures
FROM '<path-to-file>\enclosures.csv'
DELIMITER ','
CSV HEADER;

INSERT INTO Enclosures (
    EnclosureName,
    Zone,
    Capacity
)
SELECT
    EnclosureName,
    Zone,
    Capacity
FROM stg_enclosures s
WHERE NOT EXISTS (
    SELECT 1
    FROM Enclosures e
    WHERE e.EnclosureName = s.EnclosureName
);

DROP TABLE stg_enclosures;





DROP TABLE IF EXISTS stg_employees;

CREATE TEMP TABLE stg_employees (
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Position VARCHAR(50),
    HireDate DATE
);

COPY stg_employees
FROM '<path-to-file>\employees.csv'
DELIMITER ','
CSV HEADER;

INSERT INTO Employees (
    FirstName,
    LastName,
    Position,
    HireDate
)
SELECT
    FirstName,
    LastName,
    Position,
    HireDate
FROM stg_employees s
WHERE NOT EXISTS (
    SELECT 1
    FROM Employees e
    WHERE e.FirstName = s.FirstName
      AND e.LastName = s.LastName
      AND e.HireDate = s.HireDate
);

DROP TABLE stg_employees;




DROP TABLE IF EXISTS stg_visitors;

CREATE TEMP TABLE stg_visitors (
    VisitorCode VARCHAR(20),
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    City VARCHAR(100),
    VisitorType VARCHAR(20)
);

COPY stg_visitors
FROM '<path-to-file>\visitors.csv'
DELIMITER ','
CSV HEADER;

INSERT INTO Visitors (
    VisitorCode,
    FirstName,
    LastName,
    City,
    VisitorType
)
SELECT
    VisitorCode,
    FirstName,
    LastName,
    City,
    VisitorType
FROM stg_visitors s
WHERE NOT EXISTS (
    SELECT 1
    FROM Visitors v
    WHERE v.VisitorCode = s.VisitorCode
);

DROP TABLE stg_visitors;




DROP TABLE IF EXISTS stg_ticket_types;

CREATE TEMP TABLE stg_ticket_types (
    TicketType VARCHAR(50),
    Price NUMERIC(10,2)
);

COPY stg_ticket_types
FROM '<path-to-file>\ticket_types.csv'
DELIMITER ','
CSV HEADER;

INSERT INTO TicketTypes (
    TicketType,
    Price
)
SELECT
    TicketType,
    Price
FROM stg_ticket_types s
WHERE NOT EXISTS (
    SELECT 1
    FROM TicketTypes t
    WHERE t.TicketType = s.TicketType
);

DROP TABLE stg_ticket_types;





DROP TABLE IF EXISTS stg_animals;

CREATE TEMP TABLE stg_animals (
    AnimalName VARCHAR(100),
    BirthDate DATE,
    Gender CHAR(1),
    SpeciesName VARCHAR(100),
    EnclosureName VARCHAR(100)
);

COPY stg_animals
FROM '<path-to-file>\animals.csv'
DELIMITER ','
CSV HEADER;

INSERT INTO Animals (
    AnimalName,
    BirthDate,
    Gender,
    SpeciesID,
    EnclosureID
)
SELECT
    a.AnimalName,
    a.BirthDate,
    a.Gender,
    s.SpeciesID,
    e.EnclosureID
FROM stg_animals a
JOIN Species s
    ON a.SpeciesName = s.SpeciesName
JOIN Enclosures e
    ON a.EnclosureName = e.EnclosureName
WHERE NOT EXISTS (
    SELECT 1
    FROM Animals an
    WHERE an.AnimalName = a.AnimalName
);

DROP TABLE stg_animals;




DROP TABLE IF EXISTS stg_ticket_sales;

CREATE TEMP TABLE stg_ticket_sales (
    VisitorCode VARCHAR(20),
    TicketType VARCHAR(50),
    SaleDate DATE,
    Quantity INT
);

COPY stg_ticket_sales
FROM '<path-to-file>\ticket_sales.csv'
DELIMITER ','
CSV HEADER;

INSERT INTO TicketSales
(
    VisitorID,
    TicketTypeID,
    SaleDate,
    Quantity
)
SELECT
    v.VisitorID,
    t.TicketTypeID,
    s.SaleDate,
    s.Quantity
FROM stg_ticket_sales s
JOIN Visitors v
    ON v.VisitorCode = s.VisitorCode
JOIN TicketTypes t
    ON t.TicketType = s.TicketType
WHERE NOT EXISTS
(
    SELECT 1
    FROM TicketSales ts
    WHERE ts.VisitorID = v.VisitorID
      AND ts.TicketTypeID = t.TicketTypeID
      AND ts.SaleDate = s.SaleDate
      AND ts.Quantity = s.Quantity
);

DROP TABLE stg_ticket_sales;




DROP TABLE IF EXISTS stg_feedings;

CREATE TEMP TABLE stg_feedings (
    AnimalName VARCHAR(100),
    EmployeeFirstName VARCHAR(50),
    EmployeeLastName VARCHAR(50),
    FeedingDate DATE,
    FoodAmountKg NUMERIC(6,2)
);

COPY stg_feedings
FROM '<path-to-file>\feedings.csv'
DELIMITER ','
CSV HEADER;

INSERT INTO Feedings
(
    AnimalID,
    EmployeeID,
    FeedingDate,
    FoodAmountKg
)
SELECT
    a.AnimalID,
    e.EmployeeID,
    f.FeedingDate,
    f.FoodAmountKg
FROM stg_feedings f
JOIN Animals a
    ON a.AnimalName = f.AnimalName
JOIN Employees e
    ON e.FirstName = f.EmployeeFirstName
   AND e.LastName = f.EmployeeLastName
WHERE NOT EXISTS
(
    SELECT 1
    FROM Feedings ff
    WHERE ff.AnimalID = a.AnimalID
      AND ff.EmployeeID = e.EmployeeID
      AND ff.FeedingDate = f.FeedingDate
      AND ff.FoodAmountKg = f.FoodAmountKg
);

DROP TABLE stg_feedings;




DROP TABLE IF EXISTS stg_vet_visits;

CREATE TEMP TABLE stg_vet_visits (
    AnimalName VARCHAR(100),
    VetFirstName VARCHAR(50),
    VetLastName VARCHAR(50),
    VisitDate DATE,
    Diagnosis VARCHAR(100)
);

COPY stg_vet_visits
FROM '<path-to-file>\vet_visits.csv'
DELIMITER ','
CSV HEADER;

INSERT INTO VetVisits
(
    AnimalID,
    EmployeeID,
    VisitDate,
    Diagnosis
)
SELECT
    a.AnimalID,
    e.EmployeeID,
    v.VisitDate,
    v.Diagnosis
FROM stg_vet_visits v
JOIN Animals a
    ON a.AnimalName = v.AnimalName
JOIN Employees e
    ON e.FirstName = v.VetFirstName
   AND e.LastName = v.VetLastName
WHERE NOT EXISTS
(
    SELECT 1
    FROM VetVisits vv
    WHERE vv.AnimalID = a.AnimalID
      AND vv.EmployeeID = e.EmployeeID
      AND vv.VisitDate = v.VisitDate
      AND vv.Diagnosis = v.Diagnosis
);

DROP TABLE stg_vet_visits;