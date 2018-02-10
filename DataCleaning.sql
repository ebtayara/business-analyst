#Schema
col 1 = accounts, col 2 = orders, col 3 = region, col 4 = sales_reps, col 5 = web_events
        id                id              id              id                  id
        name              account_id      name            name                account_id
        website           occurred_at                     region_id           occured_at
        lat               standard_qty                                        channel
        long              gloss_qty
        primary_doc       poster_qty
        sales_rep_id      total
                          standard_amt_usd
                          gloss_amt_usd
                          poster_amt_usd
                          total_amt_usd

#Datacleaning referes to the practice of:
1) Cleaning/re-structuring messy data.
2) Converting columns to different data types.
3) Manipulating NULLs

#Left&Right
/*
In the accounts table, there is a column holding the website for each company. The last three digits
specify what type of web address they are using. Pulled these extensions and provided
how many of each website type exist in the accounts table.
*/
SELECT RIGHT(website, 3) AS domain, COUNT(*) num_companies
FROM accounts
GROUP BY 1
ORDER BY 2 DESC;
/*
Used the accounts table to pull the first letter of each company name to see the distribution
of company names that begin with each letter (or number).
*/
SELECT LEFT(UPPER(name), 1) AS first_letter, COUNT(*) num_companies
FROM accounts
GROUP BY 1
ORDER BY 2 DESC;
/*
Used the accounts table and a CASE statement to create two groups: one group of company names
that start with a number and a second group of those company names that start with a letter.
What proportion of company names start with a letter?
Note: We find there are 350 company names that start with a letter and 1 that starts with a number.
This gives a ratio of 350/351 that are company names that start with a letter or 99.7%.
*/
SELECT SUM(num) nums, SUM(letter) letters
FROM (SELECT name, CASE WHEN LEFT(UPPER(name), 1) IN ('0','1','2','3','4','5','6','7','8','9')
                       THEN 1 ELSE 0 END AS num,
         CASE WHEN LEFT(UPPER(name), 1) IN ('0','1','2','3','4','5','6','7','8','9')
                       THEN 0 ELSE 1 END AS letter
      FROM accounts) t1;
/*
Considering vowels as a, e, i, o, and u. What proportion of company names start with a vowel,
and what percent start with anything else?
Note: We find there are 80 company names that start with a vowel and 271 that start with other characters.
Therefore 80/351 are vowels or 22.8%. Therefore, 77.2% of company names do not start with vowels.
*/
SELECT SUM(vowels) vowels, SUM(other) other
FROM (SELECT name, CASE WHEN LEFT(UPPER(name), 1) IN ('A','E','I','O','U')
                        THEN 1 ELSE 0 END AS vowels,
          CASE WHEN LEFT(UPPER(name), 1) IN ('A','E','I','O','U')
                       THEN 0 ELSE 1 END AS other
         FROM accounts) t1;

#POSITION, STRPOS, & SUBSTR: POSITION takes a character and a column, and provides the index where that
character is for each row. The index of the first position is 1 in SQL. If we come from another programming language,
many begin indexing at 0. We can pull the index of a comma as POSITION(',' IN city_state).

STRPOS provides the same result as POSITION, but the syntax for achieving those results is a bit different
as shown here: STRPOS(city_state, ',').
/*
Used the accounts table to create first and last name columns that hold the first and last names for the primary_poc.
*/
SELECT LEFT(primary_poc, STRPOS(primary_poc, ' ') -1 ) first_name,
RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc, ' ')) last_name
FROM accounts;
/*
Now we see if we can do the same thing for every rep name in the sales_rep table.
Again, provided first and last name columns.
*/
SELECT LEFT(name, STRPOS(name, ' ') -1 ) first_name,
       RIGHT(name, LENGTH(name) - STRPOS(name, ' ')) last_name
FROM sales_reps;

#CONCAT/Piping: combines values from several columns into one column. E.g. first and last names stored in separate
columns could be combined together to create a full name: CONCAT(first_name, ' ', last_name) or with
piping as first_name || ' ' || last_name.
/*
Each company in the accounts table wants to create an email address for each primary_poc. The email address
should be the first name of the primary_poc . last name primary_poc @ company name .com.
*/
WITH t1 AS (
 SELECT LEFT(primary_poc, STRPOS(primary_poc, ' ') -1 ) first_name, RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc, ' ')) last_name, name
 FROM accounts)
SELECT first_name, last_name, CONCAT(first_name, '.', last_name, '@', name, '.com')
FROM t1;
/*
Created an email address that will work by removing all of the spaces in the account name.
*/
WITH t1 AS (
 SELECT LEFT(primary_poc, STRPOS(primary_poc, ' ') -1 ) first_name, RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc, ' ')) last_name, name
 FROM accounts)
SELECT first_name, last_name, CONCAT(first_name, '.', last_name, '@', REPLACE(name, ' ', ''), '.com')
FROM  t1;
/*
We would also like to create an initial password, which they will change after their first log in.
The first password will be the first letter of the primary_poc's first name (lowercase), then the last letter
of their first name (lowercase), the first letter of their last name (lowercase), the last letter of their last name
(lowercase), the number of letters in their first name, the number of letters in their last name, and then the name
of the company they are working with, all capitalized with no spaces.
*/
WITH t1 AS (
 SELECT LEFT(primary_poc, STRPOS(primary_poc, ' ') -1 ) first_name, RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc, ' ')) last_name, name
 FROM accounts)
SELECT first_name, last_name, CONCAT(first_name, '.', last_name, '@', name, '.com'), LEFT(LOWER(first_name), 1) || RIGHT(LOWER(first_name), 1) || LEFT(LOWER(last_name), 1) || RIGHT(LOWER(last_name), 1) || LENGTH(first_name) || LENGTH(last_name) || REPLACE(UPPER(name), ' ', '')
FROM t1;

#CAST: is useful when we try to change lots of column types. Commonly, we are changing a string to a
date using CAST(date_column AS DATE).
Note: I worked with a different dataset since the data in the schema above is already clean.
/*
Wrote a query to look at the top 10 rows to understand the columns and the raw data set called sf_crime_data.
Note: Looking at the date column, the date is not in the correct format.
The format of the date column is mm/dd/yyyy with times that are not correct also at the end of the date.
*/
SELECT *
FROM sf_crime_data
LIMIT 10;
/*
Wrote a query to change the date into the correct SQL date format.
*/
SELECT date orig_date, (SUBSTR(date, 7, 4) || '-' || LEFT(date, 2) || '-' || SUBSTR(date, 4, 2)) new_date
FROM sf_crime_data;
/*
Used CAST to convert the data to a date. Note: this new date can be operated on using DATE_TRUNC and DATE_PART
in the same way as we did when working with subqueries earlier.
*/
SELECT date orig_date, (SUBSTR(date, 7, 4) || '-' || LEFT(date, 2) || '-' || SUBSTR(date, 4, 2))::DATE new_date
FROM sf_crime_data;

#COALESCEs: In general, COALESCE returns the first non-NULL value passed for each row.
/*
Ran the query below and noticed it produces 11 NULL columns.
*/
1)
SELECT *
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id
WHERE o.total IS NULL;
/*
Used COALESCE to fill in the accounts.id column with the account.id for the NULL value.
*/
SELECT COALESCE(a.id, a.id) filled_id, a.name, a.website, a.lat, a.long, a.primary_poc, a.sales_rep_id, o.*
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id
WHERE o.total IS NULL;
/*
Used COALESCE to fill in the orders.accounts_id column with the account.id for the NULL value.
*/
SELECT COALESCE(a.id, a.id) filled_id, a.name, a.website, a.lat, a.long, a.primary_poc, a.sales_rep_id, COALESCE(o.account_id, a.id) account_id, o.occurred_at, o.standard_qty, o.gloss_qty, o.poster_qty, o.total, o.standard_amt_usd, o.gloss_amt_usd, o.poster_amt_usd, o.total_amt_usd
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id
WHERE o.total IS NULL;
/*
Used COALESCE to fill in each of the qty and usd columns with 0.
*/
SELECT COALESCE(a.id, a.id) filled_id, a.name, a.website, a.lat, a.long, a.primary_poc, a.sales_rep_id, COALESCE(o.account_id, a.id) account_id, o.occurred_at, COALESCE(o.standard_qty, 0) standard_qty, COALESCE(o.gloss_qty,0) gloss_qty, COALESCE(o.poster_qty,0) poster_qty, COALESCE(o.total,0) total, COALESCE(o.standard_amt_usd,0) standard_amt_usd, COALESCE(o.gloss_amt_usd,0) gloss_amt_usd, COALESCE(o.poster_amt_usd,0) poster_amt_usd, COALESCE(o.total_amt_usd,0) total_amt_usd
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id
WHERE o.total IS NULL;
/*
Ran the 1st query with the WHERE removed and used COUNT for the number of ids.
*/
SELECT COUNT(*)
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id;
/*
Ran the query above, but with the COALESCE function.
*/
SELECT COALESCE(a.id, a.id) filled_id, a.name, a.website, a.lat, a.long, a.primary_poc, a.sales_rep_id, COALESCE(o.account_id, a.id) account_id, o.occurred_at, COALESCE(o.standard_qty, 0) standard_qty, COALESCE(o.gloss_qty,0) gloss_qty, COALESCE(o.poster_qty,0) poster_qty, COALESCE(o.total,0) total, COALESCE(o.standard_amt_usd,0) standard_amt_usd, COALESCE(o.gloss_amt_usd,0) gloss_amt_usd, COALESCE(o.poster_amt_usd,0) poster_amt_usd, COALESCE(o.total_amt_usd,0) total_amt_usd
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id;
