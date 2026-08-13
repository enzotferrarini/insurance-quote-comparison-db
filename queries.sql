-- Demonstrate typical database operations using fictional sample data.
-- Run this file after schema.sql on a new database.

-- Add a new prospect
INSERT INTO "prospects"
    (
        "first_name",
        "last_name",
        "email",
        "phone"
    )
VALUES
    (
        'Enzo',
        'Ferrarini',
        'enzo@example.com',
        '123-456-7890'
    );

-- Add insurance carriers
INSERT INTO "carriers" ("name")
VALUES
    ('Travelers'),
    ('Mercury');

-- Add two auto quotes for the prospect
INSERT INTO "quotes"
    (
        "prospect_id",
        "carrier_id",
        "quote_type",
        "premium_cents",
        "effective_date",
        "expiration_date"
    )
VALUES
    (
        (
            SELECT "id"
            FROM "prospects"
            WHERE "email" = 'enzo@example.com'
        ),
        (
            SELECT "id"
            FROM "carriers"
            WHERE "name" = 'Travelers'
        ),
        'Auto',
        149700,
        '2026-08-01',
        '2027-02-01'
    ),
    (
        (
            SELECT "id"
            FROM "prospects"
            WHERE "email" = 'enzo@example.com'
        ),
        (
            SELECT "id"
            FROM "carriers"
            WHERE "name" = 'Mercury'
        ),
        'Auto',
        135900,
        '2026-08-01',
        '2027-02-01'
    );

-- Add auto coverage types
INSERT INTO "coverages"
    (
        "name",
        "description"
    )
VALUES
    (
        'Bodily Injury Liability',
        'Pays for injuries caused to other people in an accident.'
    ),
    (
        'Property Damage Liability',
        'Pays for damage caused to another person''s property.'
    ),
    (
        'Comprehensive',
        'Pays for covered vehicle damage not caused by a collision.'
    ),
    (
        'Collision',
        'Pays for covered collision damage to the insured vehicle.'
    ),
    (
        'Uninsured Motorist Bodily Injury',
        'Pays for injuries caused by an uninsured or underinsured driver.'
    ),
    (
        'Medical Payments',
        'Pays eligible medical expenses after an auto accident.'
    ),
    (
        'Rental Reimbursement',
        'Helps pay for a rental vehicle after a covered loss.'
    ),
    (
        'Roadside Assistance',
        'Provides services such as towing and battery assistance.'
    );

-- Add coverages to the Travelers quote
INSERT INTO "quote_coverages"
    (
        "quote_id",
        "coverage_id",
        "limit_cents",
        "deductible_cents",
        "notes"
    )
VALUES
    (
        (
            SELECT "quotes"."id"
            FROM "quotes"
            JOIN "carriers"
                ON "quotes"."carrier_id" = "carriers"."id"
            JOIN "prospects"
                ON "quotes"."prospect_id" = "prospects"."id"
            WHERE "carriers"."name" = 'Travelers'
            AND "prospects"."email" = 'enzo@example.com'
            AND "quotes"."quote_type" = 'Auto'
            AND "quotes"."effective_date" = '2026-08-01'
        ),
        (
            SELECT "id"
            FROM "coverages"
            WHERE "name" = 'Bodily Injury Liability'
        ),
        25000000,
        NULL,
        '$250,000 per person and $500,000 per accident'
    ),
    (
        (
            SELECT "quotes"."id"
            FROM "quotes"
            JOIN "carriers"
                ON "quotes"."carrier_id" = "carriers"."id"
            JOIN "prospects"
                ON "quotes"."prospect_id" = "prospects"."id"
            WHERE "carriers"."name" = 'Travelers'
            AND "prospects"."email" = 'enzo@example.com'
            AND "quotes"."quote_type" = 'Auto'
            AND "quotes"."effective_date" = '2026-08-01'
        ),
        (
            SELECT "id"
            FROM "coverages"
            WHERE "name" = 'Property Damage Liability'
        ),
        10000000,
        NULL,
        '$100,000 per accident'
    ),
    (
        (
            SELECT "quotes"."id"
            FROM "quotes"
            JOIN "carriers"
                ON "quotes"."carrier_id" = "carriers"."id"
            JOIN "prospects"
                ON "quotes"."prospect_id" = "prospects"."id"
            WHERE "carriers"."name" = 'Travelers'
            AND "prospects"."email" = 'enzo@example.com'
            AND "quotes"."quote_type" = 'Auto'
            AND "quotes"."effective_date" = '2026-08-01'
        ),
        (
            SELECT "id"
            FROM "coverages"
            WHERE "name" = 'Comprehensive'
        ),
        NULL,
        50000,
        '$500 deductible'
    ),
    (
        (
            SELECT "quotes"."id"
            FROM "quotes"
            JOIN "carriers"
                ON "quotes"."carrier_id" = "carriers"."id"
            JOIN "prospects"
                ON "quotes"."prospect_id" = "prospects"."id"
            WHERE "carriers"."name" = 'Travelers'
            AND "prospects"."email" = 'enzo@example.com'
            AND "quotes"."quote_type" = 'Auto'
            AND "quotes"."effective_date" = '2026-08-01'
        ),
        (
            SELECT "id"
            FROM "coverages"
            WHERE "name" = 'Collision'
        ),
        NULL,
        100000,
        '$1,000 deductible'
    ),
    (
        (
            SELECT "quotes"."id"
            FROM "quotes"
            JOIN "carriers"
                ON "quotes"."carrier_id" = "carriers"."id"
            JOIN "prospects"
                ON "quotes"."prospect_id" = "prospects"."id"
            WHERE "carriers"."name" = 'Travelers'
            AND "prospects"."email" = 'enzo@example.com'
            AND "quotes"."quote_type" = 'Auto'
            AND "quotes"."effective_date" = '2026-08-01'
        ),
        (
            SELECT "id"
            FROM "coverages"
            WHERE "name" = 'Uninsured Motorist Bodily Injury'
        ),
        25000000,
        NULL,
        '$250,000 per person and $500,000 per accident'
    ),
    (
        (
            SELECT "quotes"."id"
            FROM "quotes"
            JOIN "carriers"
                ON "quotes"."carrier_id" = "carriers"."id"
            JOIN "prospects"
                ON "quotes"."prospect_id" = "prospects"."id"
            WHERE "carriers"."name" = 'Travelers'
            AND "prospects"."email" = 'enzo@example.com'
            AND "quotes"."quote_type" = 'Auto'
            AND "quotes"."effective_date" = '2026-08-01'
        ),
        (
            SELECT "id"
            FROM "coverages"
            WHERE "name" = 'Medical Payments'
        ),
        500000,
        NULL,
        '$5,000 per person'
    ),
    (
        (
            SELECT "quotes"."id"
            FROM "quotes"
            JOIN "carriers"
                ON "quotes"."carrier_id" = "carriers"."id"
            JOIN "prospects"
                ON "quotes"."prospect_id" = "prospects"."id"
            WHERE "carriers"."name" = 'Travelers'
            AND "prospects"."email" = 'enzo@example.com'
            AND "quotes"."quote_type" = 'Auto'
            AND "quotes"."effective_date" = '2026-08-01'
        ),
        (
            SELECT "id"
            FROM "coverages"
            WHERE "name" = 'Rental Reimbursement'
        ),
        NULL,
        NULL,
        '$50 per day, maximum of $1,500'
    ),
    (
        (
            SELECT "quotes"."id"
            FROM "quotes"
            JOIN "carriers"
                ON "quotes"."carrier_id" = "carriers"."id"
            JOIN "prospects"
                ON "quotes"."prospect_id" = "prospects"."id"
            WHERE "carriers"."name" = 'Travelers'
            AND "prospects"."email" = 'enzo@example.com'
            AND "quotes"."quote_type" = 'Auto'
            AND "quotes"."effective_date" = '2026-08-01'
        ),
        (
            SELECT "id"
            FROM "coverages"
            WHERE "name" = 'Roadside Assistance'
        ),
        NULL,
        NULL,
        'Included'
    );

-- Find all quotes for a prospect by email address
SELECT
    "quotes".*
FROM "quotes"
WHERE "prospect_id" = (
    SELECT "id"
    FROM "prospects"
    WHERE "email" = 'enzo@example.com'
);

-- Display a clean quote comparison
SELECT *
FROM "quote_comparison"
WHERE "first_name" = 'Enzo'
AND "last_name" = 'Ferrarini'
ORDER BY "annual_premium";

-- Find the least expensive auto quote
SELECT
    "carriers"."name" AS "carrier",
    ROUND(
        "quotes"."premium_cents" / 100.0,
        2
    ) AS "annual_premium"
FROM "quotes"
JOIN "carriers"
    ON "quotes"."carrier_id" = "carriers"."id"
WHERE "quotes"."prospect_id" = (
    SELECT "id"
    FROM "prospects"
    WHERE "email" = 'enzo@example.com'
)
AND "quotes"."quote_type" = 'Auto'
ORDER BY "quotes"."premium_cents"
LIMIT 1;

-- Display all coverages included with the Travelers quote
SELECT
    "coverages"."name",
    ROUND(
        "quote_coverages"."limit_cents" / 100.0,
        2
    ) AS "coverage_limit",
    ROUND(
        "quote_coverages"."deductible_cents" / 100.0,
        2
    ) AS "deductible",
    "quote_coverages"."notes"
FROM "quote_coverages"
JOIN "coverages"
    ON "quote_coverages"."coverage_id" = "coverages"."id"
JOIN "quotes"
    ON "quote_coverages"."quote_id" = "quotes"."id"
JOIN "carriers"
    ON "quotes"."carrier_id" = "carriers"."id"
JOIN "prospects"
    ON "quotes"."prospect_id" = "prospects"."id"
WHERE "carriers"."name" = 'Travelers'
AND "prospects"."email" = 'enzo@example.com'
AND "quotes"."quote_type" = 'Auto'
AND "quotes"."effective_date" = '2026-08-01'
ORDER BY "coverages"."name";

-- Count how many quotes each carrier has provided
SELECT
    "carriers"."name",
    COUNT("quotes"."id") AS "number_of_quotes"
FROM "carriers"
LEFT JOIN "quotes"
    ON "carriers"."id" = "quotes"."carrier_id"
GROUP BY "carriers"."id"
ORDER BY "number_of_quotes" DESC;

-- Mark the Travelers quote as presented
UPDATE "quotes"
SET "status" = 'Presented'
WHERE "id" = (
    SELECT "quotes"."id"
    FROM "quotes"
    JOIN "carriers"
        ON "quotes"."carrier_id" = "carriers"."id"
    JOIN "prospects"
        ON "quotes"."prospect_id" = "prospects"."id"
    WHERE "carriers"."name" = 'Travelers'
    AND "prospects"."email" = 'enzo@example.com'
    AND "quotes"."quote_type" = 'Auto'
    AND "quotes"."effective_date" = '2026-08-01'
);

-- Mark the prospect as quoted
UPDATE "prospects"
SET "status" = 'Quoted'
WHERE "email" = 'enzo@example.com';

-- Remove quotes marked as expired after their expiration date
DELETE FROM "quotes"
WHERE "status" = 'Expired'
AND "expiration_date" < DATE('now');
