-- 2.1 Top Departments
-- SELECT department_date.department ,  departments.dept_name, SUM(spend) AS "Department Spend"
-- FROM department_date	
-- INNER JOIN departments ON department_date.department = departments.department
-- GROUP BY department_date.department, departments.dept_name
-- ORDER BY "Department Spend" DESC;
-- Question for John. How do we return more columns from the JOIN than what is specified in the SELECT? Answer: You can't. This question may be ambiguously worded.

-- 2.2 Top Departments in 2015 - Updated
SELECT department_date.department ,  departments.dept_name, SUM(spend) AS "Department Spend"
FROM department_date	
INNER JOIN departments ON department_date.department = departments.department
WHERE SUBSTR(date,1,4) = "2015"
GROUP BY department_date.department, departments.dept_name
ORDER BY "Department Spend" DESC;

-- 2.3 Owners and Sales by Year - Updated
SELECT SUBSTR (date,1,4) AS year,
	COUNT(DISTINCT card_no), 
	SUM(spend) AS total_spend 
FROM owner_spend_date
GROUP BY year
ORDER BY year DESC;

-- 2.4 Rows and Sales by Hour
-- SELECT hour,
--     COUNT(hour) AS "Num Days",
--     ROUND(SUM(spend), 2) AS "Total Sales"
-- FROM date_hour
-- GROUP BY hour
-- ORDER BY hour;

-- -- 2.5 Rows and Sales by Hour
-- SELECT hour,
--     COUNT(hour) AS "Num Days",
--     ROUND(SUM(spend), 2) AS "Total Sales"
-- FROM date_hour
-- GROUP BY hour
-- HAVING COUNT(hour) < 2570
-- ORDER BY hour;

-- 2.6 Owner Spend and Shopping Days - Updated
SELECT card_no, 
COUNT (DISTINCT SUBSTR(owner_spend_date.date,9,10)) AS "Num Days",
SUM(spend) AS "Total Spend"
FROM owner_spend_date
GROUP BY card_no
ORDER BY "Total Spend" DESC

-- 2.7 Owner Spend and Shopping Days - Updated
SELECT card_no, 
COUNT (DISTINCT SUBSTR(owner_spend_date.date,9,10)) AS "Num Days",
SUM(spend) AS "Total Spend",
AVG(spend) AS "Average Daily Spend"
FROM owner_spend_date
GROUP BY card_no
ORDER BY "Average Daily Spend" DESC

-- 2.8 Zip Spend and Shopping Days
SELECT owners.zip AS "ZIP Code",
    COUNT(DISTINCT owner_spend_date.card_no || owner_spend_date.date) AS "Num Owner-Days", 
    ROUND(SUM(owner_spend_date.spend), 2) AS "Total Spend",  
    ROUND(SUM(owner_spend_date.spend) / COUNT(DISTINCT owner_spend_date.card_no || owner_spend_date.date), 2) AS "Average Daily Spend"  
FROM owner_spend_date
JOIN owners ON owner_spend_date.card_no = owners.card_no 
GROUP BY owners.zip 
ORDER BY  "Total Spend" DESC;

-- 2.9 Area Information
SELECT
    CASE
        WHEN owners.zip = '55405' THEN 'Wedge'
        WHEN owners.zip IN ('55442', '55416', '55408', '55404', '55403') THEN 'Adjacent'
        ELSE 'Other'
    END AS "Area",

    COUNT(DISTINCT owners.card_no) AS "Number of Owners", -- Correct
    COUNT(DISTINCT owner_spend_date.card_no || owner_spend_date.date) AS "Total Number of Owner-Days", -- Correct
    COUNT(DISTINCT owner_spend_date.card_no || owner_spend_date.date) / COUNT(DISTINCT owners.card_no) AS "Average Total Days per Owner",  -- concatenate card_no and date
    SUM(owner_spend_date.spend) AS "Total Spend", 
    SUM(owner_spend_date.spend) / COUNT(DISTINCT owners.card_no) AS "Average Total Spend per Owner", 
    SUM(owner_spend_date.spend) / COUNT(DISTINCT owner_spend_date.card_no || owner_spend_date.date) AS "Average Total Spend per Owner per Day" 
FROM owner_spend_date
JOIN owners ON owner_spend_date.card_no = owners.card_no
GROUP BY "Area"
ORDER BY "Total Spend" DESC;

-- 2.10
SELECT
    departments.department AS "Department Number",
    departments.dept_name AS "Department Name",
    ROUND(SUM(department_date.spend), 0) AS "Total Department Spend",
  SUM(department_date.items) AS "Total Items Purchased by Department",
    SUM(DISTINCT department_date.trans) AS "Total Transactions by Department",
    ROUND(SUM(department_date.spend) / SUM(department_date.items), 2) AS "Average Item Price in Department"
FROM department_date
JOIN departments ON department_date.department = departments.department
GROUP BY departments.department, departments.dept_name
ORDER BY "Average Item Price" DESC;
