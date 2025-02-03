-- 3.1 Create temporary owner, year, month table
CREATE TEMP TABLE owner_year_month AS
SELECT 
    card_no,
    substr(date, 1, 4) AS year,
    substr(date, 6, 2) AS month,
    SUM(spend) AS spend,
    SUM(items) AS items
FROM owner_spend_date

-- 3.2 Top 5 Months
SELECT year, month, SUM(spend) AS "Total Spend"
FROM owner_year_month
 GROUP BY year, month
ORDER BY "Total Spend" DESC
LIMIT 5;

