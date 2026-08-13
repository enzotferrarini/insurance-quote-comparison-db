-- Enforce foreign key constraints in SQLite
PRAGMA foreign_keys = ON;

-- Represent prospective insurance customers
CREATE TABLE "prospects" (
    "id" INTEGER,
    "first_name" TEXT NOT NULL,
    "last_name" TEXT NOT NULL,
    "email" TEXT UNIQUE,
    "phone" TEXT,
    "status" TEXT NOT NULL DEFAULT 'New'
        CHECK (
            "status" IN (
                'New',
                'Quoting',
                'Quoted',
                'Accepted',
                'Declined'
            )
        ),
    "created_at" TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY ("id")
);

-- Represent insurance companies that provide quotes
CREATE TABLE "carriers" (
    "id" INTEGER,
    "name" TEXT NOT NULL UNIQUE,
    PRIMARY KEY ("id")
);

-- Represent insurance quotes provided to prospects
CREATE TABLE "quotes" (
    "id" INTEGER,
    "prospect_id" INTEGER NOT NULL,
    "carrier_id" INTEGER NOT NULL,
    "quote_type" TEXT NOT NULL
        CHECK (
            "quote_type" IN (
                'Auto',
                'Home',
                'Umbrella'
            )
        ),
    "premium_cents" INTEGER NOT NULL
        CHECK ("premium_cents" >= 0),
    "effective_date" TEXT NOT NULL,
    "expiration_date" TEXT,
    "status" TEXT NOT NULL DEFAULT 'Pending'
        CHECK (
            "status" IN (
                'Pending',
                'Presented',
                'Accepted',
                'Declined',
                'Expired'
            )
        ),
    "created_at" TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY ("id"),
    FOREIGN KEY ("prospect_id")
        REFERENCES "prospects" ("id"),
    FOREIGN KEY ("carrier_id")
        REFERENCES "carriers" ("id"),
    CHECK (
        "expiration_date" IS NULL
        OR "expiration_date" >= "effective_date"
    )
);

-- Represent insurance coverage types
CREATE TABLE "coverages" (
    "id" INTEGER,
    "name" TEXT NOT NULL UNIQUE,
    "description" TEXT,
    PRIMARY KEY ("id")
);

-- Represent the coverages included with each quote
CREATE TABLE "quote_coverages" (
    "quote_id" INTEGER NOT NULL,
    "coverage_id" INTEGER NOT NULL,
    "limit_cents" INTEGER
        CHECK (
            "limit_cents" IS NULL
            OR "limit_cents" >= 0
        ),
    "deductible_cents" INTEGER
        CHECK (
            "deductible_cents" IS NULL
            OR "deductible_cents" >= 0
        ),
    "notes" TEXT,
    PRIMARY KEY ("quote_id", "coverage_id"),
    FOREIGN KEY ("quote_id")
        REFERENCES "quotes" ("id")
        ON DELETE CASCADE,
    FOREIGN KEY ("coverage_id")
        REFERENCES "coverages" ("id")
);

-- Speed up searches for prospects by name
CREATE INDEX "prospect_name_search"
ON "prospects" ("first_name", "last_name");

-- Speed up searches for quotes belonging to a prospect
CREATE INDEX "quote_prospect_search"
ON "quotes" ("prospect_id");

-- Speed up searches for quotes provided by a carrier
CREATE INDEX "quote_carrier_search"
ON "quotes" ("carrier_id");

-- Speed up searches by quote status
CREATE INDEX "quote_status_search"
ON "quotes" ("status");

-- Speed up premium comparisons for a prospect
CREATE INDEX "quote_price_comparison"
ON "quotes" (
    "prospect_id",
    "quote_type",
    "premium_cents"
);

-- Simplify comparisons between quotes
CREATE VIEW "quote_comparison" AS
SELECT
    "quotes"."id" AS "quote_id",
    "prospects"."first_name",
    "prospects"."last_name",
    "carriers"."name" AS "carrier",
    "quotes"."quote_type",
    ROUND(
        "quotes"."premium_cents" / 100.0,
        2
    ) AS "annual_premium",
    "quotes"."effective_date",
    "quotes"."expiration_date",
    "quotes"."status"
FROM "quotes"
JOIN "prospects"
    ON "quotes"."prospect_id" = "prospects"."id"
JOIN "carriers"
    ON "quotes"."carrier_id" = "carriers"."id";
