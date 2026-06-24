DROP TABLE IF EXISTS FactFeedings CASCADE;
DROP TABLE IF EXISTS FactTicketSales CASCADE;
DROP TABLE IF EXISTS BridgeAnimalSpecies CASCADE;

DROP TABLE IF EXISTS DimEmployee CASCADE;
DROP TABLE IF EXISTS DimTicketType CASCADE;
DROP TABLE IF EXISTS DimVisitor CASCADE;
DROP TABLE IF EXISTS DimAnimal CASCADE;
DROP TABLE IF EXISTS DimSpecies CASCADE;
DROP TABLE IF EXISTS DimDate CASCADE;

-- DIM DATE

CREATE TABLE DimDate (
    DateID INT PRIMARY KEY,
    FullDate DATE NOT NULL,
    Day INT,
    Month INT,
    Year INT,
    Quarter INT
);

-- DIM SPECIES

CREATE TABLE DimSpecies (
    SpeciesID INT PRIMARY KEY,
    SpeciesName VARCHAR(100),
    HabitatType VARCHAR(50),
    DietType VARCHAR(50)
);

-- DIM ANIMAL

CREATE TABLE DimAnimal (
    AnimalID INT PRIMARY KEY,
    AnimalName VARCHAR(100),
    Gender CHAR(1),
    BirthDate DATE,
    SpeciesID INT
);

ALTER TABLE DimAnimal
ADD CONSTRAINT fk_dimanimal_species
FOREIGN KEY (SpeciesID) REFERENCES DimSpecies(SpeciesID);

-- DIM VISITOR

CREATE TABLE DimVisitor (
    VisitorID INT PRIMARY KEY,
    City VARCHAR(100),
    VisitorType VARCHAR(20)
);

-- DIM TICKET TYPE

CREATE TABLE DimTicketType (
    TicketTypeID INT PRIMARY KEY,
    TicketType VARCHAR(50),
    Price NUMERIC(10,2)
);

-- DIM EMPLOYEE (SCD TYPE 2)

CREATE TABLE DimEmployee (
    EmployeeSK INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    EmployeeID INT,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Position VARCHAR(50),
    StartDate DATE,
    EndDate DATE,
    IsCurrent BOOLEAN
);

-- BRIDGE TABLE

CREATE TABLE BridgeAnimalSpecies (
    AnimalID INT,
    SpeciesID INT,
    PRIMARY KEY (AnimalID, SpeciesID)
);

-- FACT TICKET SALES

CREATE TABLE FactTicketSales(
    FactSaleSK INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    SourceSaleID INT UNIQUE,
    DateID INT NOT NULL,
    VisitorID INT NOT NULL,
    TicketTypeID INT NOT NULL,
    Quantity INT,
    TotalAmount NUMERIC(10,2)
);

ALTER TABLE FactTicketSales
ADD CONSTRAINT fk_factticketsales_date
FOREIGN KEY (DateID) REFERENCES DimDate(DateID);

ALTER TABLE FactTicketSales
ADD CONSTRAINT fk_factticketsales_visitor
FOREIGN KEY (VisitorID) REFERENCES DimVisitor(VisitorID);

ALTER TABLE FactTicketSales
ADD CONSTRAINT fk_factticketsales_tickettype
FOREIGN KEY (TicketTypeID) REFERENCES DimTicketType(TicketTypeID);

-- FACT FEEDINGS

CREATE TABLE FactFeedings (
    FactFeedingSK INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    SourceFeedingID INT UNIQUE,
    DateID INT NOT NULL,
    AnimalID INT NOT NULL,
    EmployeeSK INT NOT NULL,
    FoodAmountKg NUMERIC(6,2)
);

ALTER TABLE FactFeedings
ADD CONSTRAINT fk_factfeedings_date
FOREIGN KEY (DateID) REFERENCES DimDate(DateID);

ALTER TABLE FactFeedings
ADD CONSTRAINT fk_factfeedings_animal
FOREIGN KEY (AnimalID) REFERENCES DimAnimal(AnimalID);

ALTER TABLE FactFeedings
ADD CONSTRAINT fk_factfeedings_employee
FOREIGN KEY (EmployeeSK) REFERENCES DimEmployee(EmployeeSK);