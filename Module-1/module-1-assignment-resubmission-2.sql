-- RESUBMISSION

-- 1.2 Big Days - updated
SELECT date, SUM(spend) AS "Daily Spend"
FROM date_hour
GROUP BY date
ORDER BY "Daily Spend" DESC
LIMIT 5;

-- 1.3 Small Days - updated
SELECT date, SUM(spend) AS "Daily Spend"
FROM date_hour
GROUP BY date
ORDER BY "Daily Spend" ASC
LIMIT 5;

-- -- 1.4 Top 3 Hours
-- SELECT date, hour, CAST(spend AS NUMERIC) AS spend
-- FROM date_hour
-- ORDER BY spend DESC
-- LIMIT 3

-- 1.5 Top Departments - Updated
SELECT department, sum(spend) AS "Department Spend"
FROM department_date
GROUP BY department
ORDER BY "Department Spend" DESC

-- 1.6 Top Departments in 2015 - Updated
SELECT department, sum(spend) AS "Department Spend"
FROM department_date
WHERE date LIKE "%2015%"
GROUP BY department
ORDER BY "Department Spend" DESC

-- -- 1.7 Top Days for Frozen
-- SELECT date, spend
-- FROM department_date
-- WHERE department = 6
-- ORDER BY spend DESC
-- LIMIT 10;

-- -- 1.8 Top Days for Deli
-- SELECT date, spend
-- FROM department_date
-- WHERE department = 8
-- ORDER BY spend DESC
-- LIMIT 10;

-- -- 1.9 Total Monthly Spending for One Owner 
-- SELECT substr(date, 6,2) AS month, SUM(spend) AS spend
-- FROM owner_spend_date
-- WHERE card_no = 18736
-- GROUP BY substr(date, 6,2)
-- ORDER BY month ASC

-- -- 1.10 Monthly Spending for One Owner 
-- SELECT  substr(date, 1,4) AS year, substr(date, 6,2) AS month, SUM(spend) AS spend
-- FROM owner_spend_date
-- WHERE card_no = 18736
-- GROUP BY substr(date, 1,4) , substr(date, 6,2) 
-- ORDER BY year , month ASC
