-- 5.1
SELECT SUM(spend) AS total_spend
FROM owner_spend_date;

-- 5.2
WITH high_spenders AS (
    SELECT owner_spend_date.card_no
    FROM owner_spend_date
    WHERE SUBSTR(owner_spend_date.spend, 1, 4) = '2017'
    GROUP BY owner_spend_date.card_no
    HAVING SUM(owner_spend_date.
	spend) > 10000
)

SELECT owner_spend_date.card_no, MAX(owner_spend_date.spend) AS spend
FROM owner_spend_date
JOIN high_spenders ON owner_spend_date.card_no = high_spenders.card_no
WHERE owner_spend_date.card_no != 3
GROUP BY owner_spend_date.card_no
ORDER BY spend DESC;

-- 5.3
SELECT * 
FROM department_date
WHERE department NOT IN (1, 2)
AND spend BETWEEN 5000 AND 7500
AND SUBSTR(date, 6, 2) IN ('05', '06', '07', '08')
ORDER BY spend DESC;

-- 5.4
WITH busiest_months AS (
    SELECT 
        substr(date, 1, 4) AS year, 
        substr(date, 6, 2) AS month, 
        SUM(spend) 
    FROM date_hour
    GROUP BY year, month
    ORDER BY spend DESC
    LIMIT 4
)
SELECT 
    substr(date, 1, 4) AS year, 
    substr(date, 6, 2) AS month, 
    SUM(spend) as spend,
    department_date.department, 
    SUM(department_date.spend) 
FROM department_date
JOIN busiest_months
ON substr(department_date.date, 1, 4) = busiest_months.year
AND substr(department_date.date, 6, 2) = busiest_months.month
GROUP BY year, month, department_date.department
HAVING SUM(department_date.spend) > 200000
ORDER BY year ASC, month ASC, SUM(department_date.spend) DESC;

-- 5.8
import sqlite3

conn = sqlite3.connect('owner_prod.db')
c = conn.cursor()

c.execute('''
CREATE TABLE IF NOT EXISTS owner_products (
    owner INTEGER,
    upc INTEGER,
    description TEXT,
    dept_name TEXT,
    spend NUMERIC,
    items INTEGER,
    trans INTEGER
)
''')

conn.commit()
conn.close()


