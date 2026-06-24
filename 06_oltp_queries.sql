-- Сколько билетов продано по типам

SELECT tt.TicketType, SUM(ts.Quantity) AS total_sold
FROM TicketSales ts
JOIN TicketTypes tt ON tt.TicketTypeID = ts.TicketTypeID
GROUP BY tt.TicketType
ORDER BY total_sold DESC;


-- Сколько животных в каждом виде

SELECT s.SpeciesName, COUNT(a.AnimalID) AS animals_count
FROM Animals a
JOIN Species s ON s.SpeciesID = a.SpeciesID
GROUP BY s.SpeciesName
ORDER BY animals_count DESC;


-- Сколько корма используют сотрудники

SELECT
    e.FirstName,
    e.LastName,
    SUM(f.FoodAmountKg) AS total_food
FROM Feedings f
JOIN Employees e ON e.EmployeeID = f.EmployeeID
GROUP BY e.FirstName, e.LastName
ORDER BY total_food DESC;
