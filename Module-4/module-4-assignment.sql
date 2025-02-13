
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