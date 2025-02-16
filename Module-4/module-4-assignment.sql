
-- 4.1
DROP TABLE IF EXISTS product_summary;

CREATE TABLE product_summary (
    year INTEGER,
    description TEXT,
    sales NUMERIC
);

-- 4.2
INSERT INTO product_summary (year, description, sales)
VALUES
    (2014, 'BANANA Organic', 176818.73),
    (2015, 'BANANA Organic', 258541.96),
    (2014, 'AVOCADO Hass Organic', 146480.34),
    (2014, 'ChickenBreastBoneless/Skinless', 204630.90);

SELECT * FROM product_summary;

-- 4.3
UPDATE product_summary
SET year = 2022
WHERE description = 'AVOCADO Hass Organic';

SELECT * FROM product_summary;

-- 4.4
DELETE FROM product_summary
WHERE description = 'BANANA Organic'
AND year = (SELECT MIN(year) FROM product_summary WHERE description = 'BANANA Organic');

SELECT * FROM product_summary;

-- 4.5
SELECT 
    `umt-msba.wedge_example.department_date`.department, 
    `umt-msba.wedge_example.departments`.department, 
    SUM(`umt-msba.wedge_example.department_date`.spend) AS dept_spend
FROM 
    `umt-msba.wedge_example.department_date`
JOIN 
    `umt-msba.wedge_example.departments`
ON 
    `umt-msba.wedge_example.department_date`.department = `umt-msba.wedge_example.departments`.department
WHERE 
    EXTRACT(YEAR FROM `umt-msba.wedge_example.department_date`.date) = 2015
GROUP BY 
    `umt-msba.wedge_example.department_date`.department, 
    `umt-msba.wedge_example.departments`.department
ORDER BY 
    dept_spend DESC;

-- 4.6
SELECT 
    card_no, 
    EXTRACT(YEAR FROM date) AS year, 
    EXTRACT(MONTH FROM date) AS month, 
    SUM(spend) AS spend, 
    SUM(items) AS items
FROM 
    `umt-msba.wedge_example.owner_spend_date`
GROUP BY 
    card_no, year, month
HAVING 
    spend BETWEEN 750 AND 1250
ORDER BY 
    spend DESC
LIMIT 10;

-- 4.7
SELECT 
    COUNT(*) AS total_rows,
    COUNT(DISTINCT card_no) AS unique_card_numbers,
    SUM(total) as total,
    COUNT(DISTINCT description) AS description
FROM 
    `umt-msba.transactions.transArchive_201001_201003`;

    -- 4.8
    SELECT 
    EXTRACT(YEAR FROM datetime) AS year,
    COUNT(*) AS total_rows,
    COUNT(DISTINCT card_no) AS unique_card_numbers,
    SUM(total) AS total,
    COUNT(DISTINCT description) AS description
FROM 
    `umt-msba.transactions.*`
GROUP BY 
    year
ORDER BY 
    year;
