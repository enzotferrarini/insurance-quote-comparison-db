# Design Document

By Enzo Ferrarini

Video overview: <https://youtu.be/z1vavXMySBo>

## Scope

The purpose of this database is to help an independent insurance agency store and compare insurance quotes for prospective customers. It tracks prospects, insurance carriers, premiums, coverage details, dates, and quote statuses.

The database includes:

* Prospects requesting insurance quotes
* Insurance carriers providing quotes
* Auto, home, and umbrella quotes
* Annual premiums and quote dates
* Coverage types, limits, deductibles, and notes
* Prospect and quote statuses

The database focuses on the quoting and comparison process. It does not include active policies, claims, billing, commissions, underwriting rules, carrier eligibility requirements, or uploaded documents.

Detailed information about drivers, vehicles, homes, and other insured property is also outside the scope. The database assumes that quotes have already been produced by an insurance carrier or quoting platform.

## Functional Requirements

A user should be able to:

* Add prospects and their contact information
* Add insurance carriers
* Enter auto, home, and umbrella quotes
* Store premiums, effective dates, and expiration dates
* Add coverage limits and deductibles to a quote
* View all quotes belonging to a prospect
* Compare premiums between carriers
* Find the least expensive quote
* View coverages included with a quote
* Update prospect and quote statuses
* Remove expired quotes

The database does not calculate premiums, determine underwriting eligibility, submit applications, bind coverage, collect payments, or manage claims. It organizes quote results rather than replacing a carrier quoting system or agency management system.

## Representation

### Entities

The database includes five entities: prospects, carriers, quotes, coverages, and quote coverages.

#### Prospects

The `prospects` table represents people requesting insurance quotes.

Its attributes are:

* `id`, the prospect’s unique identifier
* `first_name` and `last_name`, the prospect’s name
* `email`, an optional email address
* `phone`, an optional phone number
* `status`, the prospect’s position in the quoting process
* `created_at`, the date and time the prospect was added

The `id` is an integer primary key. First and last names are required text values.

Email is stored as text and is unique, preventing the same address from being assigned to multiple prospects. It is optional because a prospect may initially provide only a phone number.

Phone numbers are stored as text because they may contain dashes, parentheses, extensions, or leading zeroes.

The prospect status defaults to `New`. A `CHECK` constraint limits it to `New`, `Quoting`, `Quoted`, `Accepted`, or `Declined`, preventing invalid or misspelled values.

The `created_at` column uses `CURRENT_TIMESTAMP` so the creation time is recorded automatically.

#### Carriers

The `carriers` table represents insurance companies.

Its attributes are:

* `id`, the carrier’s unique identifier
* `name`, the carrier’s name

The carrier name is required and unique, preventing duplicate carrier records.

#### Quotes

The `quotes` table represents individual insurance quotes.

Its attributes are:

* `id`, the quote’s unique identifier
* `prospect_id`, the prospect receiving the quote
* `carrier_id`, the carrier providing the quote
* `quote_type`, whether the quote is Auto, Home, or Umbrella
* `annual_premium_cents`, the annual premium
* `effective_date`, the proposed starting date
* `expiration_date`, the optional expiration date
* `status`, the quote’s current status
* `created_at`, the date and time the quote was added

The `prospect_id` and `carrier_id` columns are foreign keys. They ensure that every quote belongs to an existing prospect and carrier.

The quote type is stored as text and limited by a `CHECK` constraint to `Auto`, `Home`, or `Umbrella`.

Premiums are stored as integer cents. For example, $1,497.00 is stored as `149700`. This avoids floating-point rounding problems. A `CHECK` constraint prevents negative premiums.

Dates are stored as text in `YYYY-MM-DD` format so they can be sorted and compared in SQLite. The effective date is required, while the expiration date is optional. A constraint prevents an expiration date from being earlier than the effective date.

The quote status defaults to `Pending` and is limited to `Pending`, `Presented`, `Accepted`, `Declined`, or `Expired`.

Quote status is separate from prospect status because one prospect may have several quotes with different statuses.

#### Coverages

The `coverages` table stores reusable insurance coverage types.

Its attributes are:

* `id`, the coverage’s unique identifier
* `name`, the coverage name
* `description`, an optional explanation

Examples include Bodily Injury Liability, Property Damage Liability, Collision, Comprehensive, Medical Payments, Rental Reimbursement, and Roadside Assistance.

The coverage name is required and unique so the same coverage definition can be reused across multiple quotes.

#### Quote Coverages

The `quote_coverages` table connects quotes with their coverages.

Its attributes are:

* `quote_id`, the quote
* `coverage_id`, the coverage type
* `limit_cents`, an optional coverage limit
* `deductible_cents`, an optional deductible
* `notes`, additional details

This table is needed because one quote can contain many coverages, while the same coverage can appear on many quotes.

The combination of `quote_id` and `coverage_id` forms a composite primary key. This prevents the same coverage from being added twice to one quote.

Limits and deductibles are stored as integer cents. They may be null because some coverages have only a limit, while others have only a deductible.

The `notes` column stores details that cannot be represented by one number, such as split liability limits or daily rental limits.

The foreign key to `quotes` uses `ON DELETE CASCADE`. Deleting a quote therefore removes its related coverage records.

### Relationships

The relationships are:

* One prospect can receive many quotes
* Each quote belongs to one prospect
* One carrier can provide many quotes
* Each quote belongs to one carrier
* One quote can include many coverages
* One coverage can appear on many quotes
* `quote_coverages` represents the many-to-many relationship between quotes and coverages

![Entity relationship diagram](er_diagram.png)

Prospects and quotes have a one-to-many relationship because one prospect may receive several quotes. Carriers and quotes also have a one-to-many relationship because one carrier may provide quotes to many prospects.

Quotes and coverages have a many-to-many relationship. The `quote_coverages` table connects them and stores the limit, deductible, and notes for each coverage on a specific quote.

## Optimizations

The database includes indexes to improve common searches.

* `prospect_name_search` improves searches by first and last name.
* `quote_prospect_search` improves retrieval of all quotes for one prospect.
* `quote_carrier_search` improves searches and counts by carrier.
* `quote_status_search` improves searches by quote status.
* `quote_price_comparison` supports filtering a prospect’s quotes by type and sorting them by premium.

The database also includes a `quote_comparison` view. It joins prospects, carriers, and quotes so users can see readable names, quote types, premiums, dates, and statuses in one result. It also converts premium cents into dollar amounts, avoiding repeated joins and calculations.

## Limitations

The database stores quote results but does not include detailed information about drivers, vehicles, homes, claims, payments, or active policies.

Some coverages contain multiple limits, such as bodily injury limits per person and per accident. Because the design stores only one limit and one deductible for each coverage, additional details must be entered in the `notes` column.

The database does not separately represent six-month and twelve-month policy terms, installment plans, down payments, fees, or pay-in-full discounts. Premiums must be converted into annual amounts before they are entered.

The database can compare premiums and display coverage details, but it cannot automatically determine which quote is best. An insurance agent must still evaluate limits, deductibles, exclusions, and carrier requirements.
