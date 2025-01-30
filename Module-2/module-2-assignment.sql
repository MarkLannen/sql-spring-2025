-- 2.1 Top Departments
SELECT department_date.department ,  departments.dept_name, SUM(spend) AS "Department Spend"
FROM department_date	
INNER JOIN departments ON department_date.department = departments.department
GROUP BY department_date.department, departments.dept_name
ORDER BY "Department Spend" DESC;
-- Question for John. How do we return more columns from the JOIN than what is specified in the SELECT?

-- 2.2 Top Departments in 2015
SELECT department_date.department ,  departments.dept_name, SUM(spend) AS "Department Spend"
FROM department_date	
INNER JOIN departments ON department_date.department = departments.department
WHERE strftime('%Y', department_date.date) = '2015'
GROUP BY department_date.department, departments.dept_name
ORDER BY "Department Spend" DESC;

-- 2.3 Owners and Sales by Year
SELECT strftime('%Y', owner_spend_date.date) AS year,
	COUNT(DISTINCT card_no), 
	SUM(spend) AS total_spend 
FROM owner_spend_date
GROUP BY year
ORDER BY year DESC;

-- 2.4 Rows and Sales by Hour
SELECT hour,
    COUNT(hour) AS "Num Days",
    ROUND(SUM(spend), 2) AS "Total Sales"
FROM date_hour
GROUP BY hour
ORDER BY hour;

-- 2.5 Rows and Sales by Hour
SELECT hour,
    COUNT(hour) AS "Num Days",
    ROUND(SUM(spend), 2) AS "Total Sales"
FROM date_hour
GROUP BY hour
HAVING COUNT(hour) < 2570
ORDER BY hour;

-- 2.6 Owner Spend and Shopping Days
SELECT card_no, 
strftime('%d', owner_spend_date.date) AS "Num Days",
SUM(spend) AS "Total Spend"
FROM owner_spend_date
GROUP BY card_no
ORDER BY "Total Spend" DESC

-- 2.7 Owner Spend and Shopping Days
SELECT card_no, 
strftime('%d', owner_spend_date.date) AS "Num Days",
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
   
    COUNT(DISTINCT owners.card_no) AS "Number of Owners",
    COUNT(DISTINCT owner_spend_date.card_no || owner_spend_date.date) AS "Total Number of Owner-Days",
    ROUND(COUNT(DISTINCT owner_spend_date.card_no || owner_spend_date.date) / COUNT(DISTINCT owners.card_no), 2) AS "Average Total Days per Owner",
    ROUND(SUM(owner_spend_date.spend), 2) AS "Total Spend",
    ROUND(SUM(owner_spend_date.spend) / COUNT(DISTINCT owners.card_no), 2) AS "Average Total Spend per Owner",
    ROUND(SUM(owner_spend_date.spend) / COUNT(DISTINCT owner_spend_date.card_no || owner_spend_date.date), 2) AS "Average Total Spend per Owner per Day"
FROM owner_spend_date
JOIN owners ON owner_spend_date.card_no = owners.card_no
GROUP BY "Area"
ORDER BY "Total Spend" DESC