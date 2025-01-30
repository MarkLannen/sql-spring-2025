-- 1.1 Totals

SELECT SUM(spend) AS 'Total Spend',
SUM(trans) AS 'Total Transactions',
SUM(items) AS 'Total Items'from date_hour;

-- 1.2 Big Days

SELECT  date, SUM(spend) AS 'Daily Spend'
FROM date_hour
GROUP BY date
ORDER BY 'Daily Spend' ASC
LIMIT 5;

-- 1.3 Small Days

SELECT  date, SUM(spend) AS 'Daily Spend'
FROM date_hour
GROUP BY date
ORDER BY 'Daily Spend' DESC
LIMIT 5;

-- 1.4 Top 3 Hours

SELECT  date, hour, CAST(spend AS NUMERIC) AS spend
FROM date_hour
GROUP BY date
ORDER BY spend DESC
LIMIT 3;

-- 1.5 Top Departments

SELECT department, SUM(spend) AS 'Department Spend'
FROM department_date
GROUP BY department
ORDER BY spend DESC

-- 1.6 Top Departments in 2015

SELECT department, SUM(spend) AS 'Department Spend', date
FROM department_date
WHERE date LIKE '%2015%'
GROUP BY date
ORDER BY spend DESC

-- 1.7 Top Days for Frozen

SELECT date, spend
FROM department_date
WHERE department = 6
ORDER BY spend DESC
LIMIT 10;

-- 1.8 Top Days for Deli

SELECT date, spend
FROM department_date
WHERE department = 6
ORDER BY spend DESC
LIMIT 10;

-- 1.9 Total Monthly Spending for One Owner

SELECT strftime('%m', date) AS month, SUM(spend) AS spend
FROM owner_spend_date
WHERE card_no = 18736
GROUP BY strftime('%m', date)
ORDER BY spend DESC
LIMIT 12;

-- 1.10 Monthly Spending for One Owner

SELECT strftime('%Y', date) AS year,  strftime('%m', date) AS month, SUM(spend)
FROM owner_spend_date
WHERE card_no = 18736
GROUP BY strftime('%m', date), strftime('%Y', date)
ORDER BY spend DESC
LIMIT 12;