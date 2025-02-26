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

-- 5.6
SELECT
    owners.zip AS "Zip",
    COUNT(DISTINCT owners.card_no) AS "Number of Owners",
    AVG(owner_spend.total_spend) AS "Avg Spent Per Owner",
    SUM(owner_spend_date.spend) / COUNT(owner_spend_date.card_no) AS "Avg Spend Per Transaction"
FROM
    owners
JOIN
    owner_spend_date ON owners.card_no = owner_spend_date.card_no
JOIN (
    SELECT card_no, SUM(spend) AS total_spend
    FROM owner_spend_date
    GROUP BY card_no
) AS owner_spend ON owners.card_no = owner_spend.card_no
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
    "Avg Spend Per Transaction" ASC
LIMIT 5;
