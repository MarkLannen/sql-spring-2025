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

-- 5.5
SELECT
    owners.zip,
    COUNT(DISTINCT owners.card_no) AS num_owners,
    SUM(owner_spend_date.spend) / COUNT(DISTINCT owners.card_no) AS avg_spent_per_owner,
    SUM(owner_spend_date.spend) / COUNT(owner_spend_date.card_no) AS avg_spent_per_transaction
FROM
    owners
JOIN
    owner_spend_date ON owners.card_no = owner_spend_date.card_no
WHERE
    owners.zip IN (
        SELECT zip
        FROM owners
        GROUP BY zip
        HAVING COUNT(DISTINCT card_no) >= 100
    )
GROUP BY
    owners.zip
ORDER BY
    avg_spent_per_transaction DESC
LIMIT 5;

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

-- 5.9

owner_prod = []
with open("owner_products.txt", 'r') as infile:
    next(infile)
    for line in infile:
        line = line.strip().split("\t")
        owner_prod.append(line)

c.executemany('''
INSERT INTO owner_products (owner, upc, description, dept_name, spend, items, trans)
VALUES (?, ?, ?, ?, ?, ?, ?)
''', owner_prod)

conn.commit()
conn.close()

-- 5.10

conn = sqlite3.connect('owner_prod.db')
c = conn.cursor()

query = '''
SELECT description, dept_name, SUM(spend) AS total_spend
FROM owner_products
WHERE dept_name LIKE '%groc%'
GROUP BY description, dept_name
ORDER BY total_spend DESC
'''

c.execute(query)

for i in range(10):
    print(rows[i])

conn.close()

