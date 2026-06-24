-- Выручка по месяцам

SELECT
    d.Year,
    d.Month,
    SUM(f.TotalAmount) AS revenue
FROM FactTicketSales f
JOIN DimDate d ON d.DateID = f.DateID
GROUP BY d.Year, d.Month
ORDER BY d.Year, d.Month;

-- Какие билеты самые популярные

SELECT
    t.TicketType,
    SUM(f.Quantity) AS total_sold
FROM FactTicketSales f
JOIN DimTicketType t ON t.TicketTypeID = f.TicketTypeID
GROUP BY t.TicketType
ORDER BY total_sold DESC;

-- Сколько корма по видам животных

SELECT
    s.SpeciesName,
    SUM(f.FoodAmountKg) AS total_food
FROM FactFeedings f
JOIN DimAnimal a ON a.AnimalID = f.AnimalID
JOIN DimSpecies s ON s.SpeciesID = a.SpeciesID
GROUP BY s.SpeciesName
ORDER BY total_food DESC;