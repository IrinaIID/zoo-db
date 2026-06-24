DROP TABLE IF EXISTS VetVisits CASCADE;
DROP TABLE IF EXISTS Feedings CASCADE;
DROP TABLE IF EXISTS TicketSales CASCADE;
DROP TABLE IF EXISTS Animals CASCADE;
DROP TABLE IF EXISTS TicketTypes CASCADE;
DROP TABLE IF EXISTS Visitors CASCADE;
DROP TABLE IF EXISTS Employees CASCADE;
DROP TABLE IF EXISTS Enclosures CASCADE;
DROP TABLE IF EXISTS Species CASCADE;

CREATE TABLE Species (
    SpeciesID INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    SpeciesName VARCHAR(100) NOT NULL UNIQUE,
    HabitatType VARCHAR(50) NOT NULL,
    DietType VARCHAR(50) NOT NULL
);

CREATE TABLE Enclosures (
    EnclosureID INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    EnclosureName VARCHAR(100) NOT NULL UNIQUE,
    Zone CHAR(1) NOT NULL,
    Capacity INT NOT NULL CHECK (Capacity > 0)
);

CREATE TABLE Employees (
    EmployeeID INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Position VARCHAR(50) NOT NULL,
    HireDate DATE NOT NULL
);

CREATE TABLE Visitors (
    VisitorID INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    VisitorCode VARCHAR(20) NOT NULL UNIQUE,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    City VARCHAR(100) NOT NULL,
    VisitorType VARCHAR(20) NOT NULL
);

CREATE TABLE TicketTypes (
    TicketTypeID INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TicketType VARCHAR(50) NOT NULL UNIQUE,
    Price NUMERIC(10,2) NOT NULL
);

CREATE TABLE Animals (
    AnimalID INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    AnimalName VARCHAR(100) NOT NULL,
    BirthDate DATE NOT NULL,
    Gender CHAR(1) NOT NULL CHECK (Gender IN ('M','F')),
    SpeciesID INT NOT NULL,
    EnclosureID INT NOT NULL,

    CONSTRAINT fk_animal_species
        FOREIGN KEY (SpeciesID)
        REFERENCES Species(SpeciesID),

    CONSTRAINT fk_animal_enclosure
        FOREIGN KEY (EnclosureID)
        REFERENCES Enclosures(EnclosureID)
);

CREATE TABLE TicketSales (
    SaleID INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    VisitorID INT NOT NULL,
    TicketTypeID INT NOT NULL,
    SaleDate DATE NOT NULL,
    Quantity INT NOT NULL CHECK (Quantity > 0),

    CONSTRAINT fk_sale_visitor
        FOREIGN KEY (VisitorID)
        REFERENCES Visitors(VisitorID),

    CONSTRAINT fk_sale_ticket
        FOREIGN KEY (TicketTypeID)
        REFERENCES TicketTypes(TicketTypeID)
);

CREATE TABLE Feedings (
    FeedingID INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    AnimalID INT NOT NULL,
    EmployeeID INT NOT NULL,
    FeedingDate DATE NOT NULL,
    FoodAmountKg NUMERIC(6,2) NOT NULL CHECK (FoodAmountKg > 0),

    CONSTRAINT fk_feeding_animal
        FOREIGN KEY (AnimalID)
        REFERENCES Animals(AnimalID),

    CONSTRAINT fk_feeding_employee
        FOREIGN KEY (EmployeeID)
        REFERENCES Employees(EmployeeID)
);

CREATE TABLE VetVisits (
    VisitID INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    AnimalID INT NOT NULL,
    EmployeeID INT NOT NULL,
    VisitDate DATE NOT NULL,
    Diagnosis VARCHAR(100) NOT NULL,

    CONSTRAINT fk_visit_animal
        FOREIGN KEY (AnimalID)
        REFERENCES Animals(AnimalID),

    CONSTRAINT fk_visit_employee
        FOREIGN KEY (EmployeeID)
        REFERENCES Employees(EmployeeID)
);