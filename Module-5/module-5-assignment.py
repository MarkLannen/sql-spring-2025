# 5.8
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

# 5.9

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

# 5.10

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