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

-- 3.7
DROP VIEW IF EXISTS vw_owner_recent;

CREATE VIEW vw_owner_recent AS
SELECT 
	card_no,
	SUM(spend) AS total_spend ,
	AVG(spend/trans) AS avg_spend_transaction, 
	COUNT (DISTINCT date) AS num_shopping_dates, 
	SUM(trans) AS total_trans,
	MAX(date) AS last_visit
	
FROM owner_spend_date

GROUP BY card_no;

-- SELECT COUNT(DISTINCT card_no) AS owners,
-- ROUND(SUM(total_spend)/1000,1) AS spend_k
-- FROM vw_owner_recent
-- WHERE 5 < total_trans AND
-- total_trans < 25 AND
-- SUBSTR(last_visit,1,4) IN ('2016','2017')

-- 3.8
CREATE TABLE owner_recent AS
SELECT 
    vwr.card_no,
    vwr.total_spend,
    vwr.avg_spend_transaction,
    vwr.num_shopping_dates,
    vwr.total_trans,
    vwr.last_visit,
    osd.spend AS last_spend
FROM vw_owner_recent vwr
JOIN owner_spend_date osd ON vwr.card_no = osd.card_no 
AND vwr.last_visit = osd.date;

/*
1. The first query took 177ms and the second took 8ms
2. The first query uses owner_recent table, which needs to be recreated with each query (SELECT statement. Whereas the second query uses a view that does not need to be recreated with each query.
*/

-- 3.9

SELECT
    owner_recent.card_no,
    owner_recent.total_spend,
    owner_recent.avg_spend_transaction,
    owner_recent.num_shopping_dates,
    owner_recent.total_trans,
    owner_recent.last_visit,
    owner_recent.last_spend

FROM owner_recent
WHERE owner_recent.last_spend < (owner_recent.avg_spend_transaction / 2) 
  AND owner_recent.total_spend >= 5000 
  AND owner_recent.num_shopping_dates >= 270 
  AND owner_recent.last_visit <= DATE('2017-01-31', '-60 days') 
  AND owner_recent.last_spend > 10
ORDER BY owner_recent.total_spend DESC;