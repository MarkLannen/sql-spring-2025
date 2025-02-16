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

