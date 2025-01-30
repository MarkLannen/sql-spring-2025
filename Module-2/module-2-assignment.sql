-- 2.1 Top Departments
SELECT department_date.department ,  departments.dept_name, SUM(spend) AS "Department Spend"
FROM department_date	
INNER JOIN departments ON department_date.department = departments.department
GROUP BY department_date.department
ORDER BY "Department Spend" DESC;
-- Question for John. How do we return more columns from the JOIN than what is specified in the SELECT?

-- 2.2 Top Departments in 2015
SELECT department_date.department ,  departments.dept_name, SUM(spend) AS "Department Spend"
FROM department_date	
INNER JOIN departments ON department_date.department = departments.department
WHERE strftime('%Y', department_date.date) = '2015'
GROUP BY department_date.department
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
