-- 3.1 Create temporary owner, year, month table
CREATE TEMP TABLE owner_year_month AS
SELECT 
    card_no,
    substr(date, 1, 4) AS year,
    substr(date, 6, 2) AS month,
    SUM(spend) AS spend,
    SUM(items) AS items
FROM owner_spend_date
GROUP BY card_no, year, month;

-- 3.2 Top 5 Months
SELECT year, month, SUM(spend) AS "Total Spend"
FROM owner_year_month
 GROUP BY year, month
ORDER BY "Total Spend" DESC
LIMIT 5;

-- 3.3 Average Spend by Month for 55405
SELECT 
    owner_year_month.month AS Month,
    ROUND(AVG(owner_year_month.spend), 2) AS "Average Spend By Month"
FROM 
    owner_year_month
WHERE 
    owner_year_month.card_no IN (
        SELECT card_no 
        FROM owners 
        WHERE zip= '55405'
    )
GROUP BY    owner_year_month.month
ORDER BY owner_year_month.month;

-- 3.4 
SELECT zip, SUM(spend) AS total_spend
FROM owner_spend_date AS osd
INNER JOIN owners ON osd.card_no = owners.card_no
GROUP BY zip
ORDER BY total_spend DESC
LIMIT 3

-- 3.5

WITH avg_spend_55405 AS (
    SELECT 
        owner_year_month.month AS Month,
        ROUND(AVG(owner_year_month.spend), 2) AS "Average Spend 55405"
    FROM 
        owner_year_month
    WHERE owner_year_month.card_no IN (
            SELECT card_no 
            FROM owners 
            WHERE zip = '55405'
        )
    GROUP BY owner_year_month.month
),
avg_spend_55408 AS (
    SELECT 
        owner_year_month.month AS Month,
        ROUND(AVG(owner_year_month.spend), 2) AS "Average Spend 55408"
    FROM 
        owner_year_month
    WHERE owner_year_month.card_no IN (
            SELECT card_no 
            FROM owners 
            WHERE zip = "55408" 
        )
    GROUP BY owner_year_month.month
),
avg_spend_55403 AS (
    SELECT 
        owner_year_month.month AS Month,
        ROUND(AVG(owner_year_month.spend), 2) AS "Average Spend 55403"
    FROM 
        owner_year_month
    WHERE owner_year_month.card_no IN (
            SELECT card_no 
            FROM owners 
            WHERE zip = "55403" 
        )
    GROUP BY owner_year_month.month
)

SELECT 
    avg_spend_55405.Month AS Month,
    avg_spend_55405."Average Spend 55405",
    avg_spend_55408."Average Spend 55408",
    avg_spend_55403."Average Spend 55403"
FROM 
    avg_spend_55405
JOIN avg_spend_55408 ON avg_spend_55405.Month = avg_spend_55408.Month
JOIN avg_spend_55403 ON avg_spend_55405.Month = avg_spend_55403.Month
ORDER BY  avg_spend_55405.Month;

-- 3.6

DROP TABLE IF EXISTS owner_year_month;

CREATE TEMP TABLE owner_year_month AS
WITH cte_total_spend AS (
    SELECT 
        card_no,
        SUM(spend) AS total_spend
    FROM 
        owner_spend_date
    GROUP BY 
        card_no
)
SELECT 
    owner_spend_date.card_no,
    substr(owner_spend_date.date, 1, 4) AS year,
    substr(owner_spend_date.date, 6, 2) AS month,
    SUM(owner_spend_date.spend) AS spend,
    SUM(owner_spend_date.items) AS items,
    cte_total_spend.total_spend
FROM 
    owner_spend_date
JOIN 
    cte_total_spend ON owner_spend_date.card_no = cte_total_spend.card_no
GROUP BY 
    owner_spend_date.card_no, year, month;