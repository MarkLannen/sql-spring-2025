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
WITH avg_spend_55406 AS(
SELECT t.month AS month, 
	ROUND (AVG(t.spend)) AS "Avg Spend 05"
FROM owner_year_month AS t
INNER JOIN owners as o
	ON o.card_no = t.card_no
WHERE o.zip = "55405"
GROUP BY t.month), 
avg_spend_55408 AS (
SELECT t.month, 
	ROUND (AVG(t.spend)) AS "Avg Spend 08"
FROM owner_year_month AS t
INNER JOIN owners AS o
	ON o.card_no = t.card_no
WHERE o.zip = "55408"
GROUP BY t.month),
avg_spend_55403 AS (
SELECT t.month ,
	ROUND(AVG(t.spend)) AS "Avg Spend 03"
FROM owner_year_month AS t
INNER JOIN owners AS o
	ON o.card_no = t.card_no
WHERE o.zip = "55403"
GROUP BY t.month)
SELECT t03.month, "Avg Spend 03", "Avg Spend 05", "Avg Spend 08"
FROM avg_spend_55403 AS t03
INNER JOIN avg_spend_55405 AS t05 ON t03.month = t05.month
