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
#Basic Queries

#Limits
/*
Wrote a query that limits the response to only the first 15 rows and includes the occurred_at, account_id, and channel fields in the web_events table.
*/
SELECT occurred_at, account_id, channel
FROM web_events
LIMIT 15;

#OrderBy
/*
Wrote a query to return the 10 earliest orders in the orders table. Included the id, occurred_at, and total_amt_usd.
*/
SELECT id, occurred_at, total_amt_usd
FROM orders
ORDER BY occurred_at
LIMIT 10;
/*
Wrote a query to return the top 5 orders in terms of largest total_amt_usd. Included the id, account_id, and total_amt_usd.
*/
SELECT id, account_id, total_amt_usd
FROM orders
ORDER BY total_amt_usd DESC
LIMIT 5;
/*
Wrote a query to return the bottom 20 orders in terms of least total. Included the id, account_id, and total.
*/
SELECT id, account_id, total
FROM orders
ORDER BY total ASC (#notnecessary)
LIMIT 20;
/*
Wrote a query that returns the top 5 rows from orders ordered according to newest to oldest,
but with the largest total_amt_usd for each date listed first for each date.
Each of these dates shows up as unique because of the time element.
When I learned about truncating dates later, I was better able to tackle this question on a day, month, or yearly basis.
*/
SELECT *
FROM orders
ORDER BY occurred_at DESC, total_amt_usd DESC
LIMIT 5;
/*
Wrote a query that returns the top 10 rows from orders ordered according to oldest to newest,
but with the smallest total_amt_usd for each date listed first for each date.
*/
SELECT *
FROM orders
ORDER BY occurred_at, total_amt_usd
LIMIT 10;

#Symbols
/*
Using the WHERE statement, we can subset out tables based on conditions that must be met.
Common symbols used within WHERE statements include:
> (greater than)
< (less than)
>= (greater than or equal to)
<= (less than or equal to)
= (equal to)
!= (not equal to)
*/

/*
Pulled the first 5 rows and all columns from the orders table that have a dollar amount of gloss_amt_usd greater than or equal to 1000.
*/
SELECT *
FROM orders
WHERE gloss_amt_usd >= 1000
LIMIT 5;
/*
Pulled the first 10 rows and all columns from the orders table that have a total_amt_usd less than 500.
*/
SELECT *
FROM orders
WHERE total_amt_usd < 500
LIMIT 10;
/*
Filtered the accounts table to include the company name, website, and the primary point of contact (primary_poc) for Exxon Mobil in the accounts table.
*/
SELECT name, website, primary_poc
FROM accounts
WHERE name = 'Exxon Mobil';

#Arithmetic Operators
/*
Created a column that divides the standard_amt_usd by the standard_qty to find the unit price for standard paper for each order.
Limited the results to the first 10 orders, and included the id and account_id fields.
*/
SELECT id, account_id, standard_amt_usd/standard_qty AS unit_price
FROM orders
LIMIT 10;
/*
Wrote a query that finds the percentage of revenue that comes from poster paper for each order.
I used only the columns that end with _usd.
Included the id and account_id fields. However - There is an error. This is for a division by zero.
I learned how to get a solution without an error to this query when I learned about CASE statements later.
As a workaround, I added a very small value to the denominator.
*/
SELECT id, account_id,
       poster_amt_usd/(standard_amt_usd + gloss_amt_usd + poster_amt_usd) AS post_per
FROM orders;

#Logical Operators
/*
Used the accounts table to find
1. All the companies whose names start with 'C'.
2. All companies whose names contain the string 'one' somewhere in the name.
3. All companies whose names end with 's'.
*/
SELECT name
FROM accounts
WHERE name LIKE 'C%';

SELECT name
FROM accounts
WHERE name LIKE '%one%';

SELECT name
FROM accounts
WHERE name LIKE '%s';
/*
Used the accounts table to find the account name, primary_poc, and sales_rep_id for Walmart, Target, and Nordstrom.
*/
SELECT name, primary_poc, sales_rep_id
FROM accounts
WHERE name IN ('Walmart', 'Target', 'Nordstrom');
/*
Used the web_events table to find all information regarding individuals who were contacted via the channel of organic or adwords.
*/
SELECT *
FROM web_events
WHERE channel IN ('organic', 'adwords');
/*
Wrote a query that returns all the orders where the standard_qty is over 1000, the poster_qty is 0, and the gloss_qty is 0.
*/
SELECT *
FROM orders
WHERE standard_qty > 1000 AND poster_qty = 0 AND gloss_qty = 0;
/*
Used the accounts table find all the companies whose names do not start with 'C' and end with 's'.
*/
SELECT name
FROM accounts
WHERE name NOT LIKE 'C%' AND name LIKE '%s';
/*
Used the web_events table to find all information regarding individuals who were
contacted via organic or adwords and started their account at any point in 2016 sorted from newest to oldest.
*/
SELECT *
FROM web_events
WHERE channel IN ('organic', 'adwords') AND occurred_at BETWEEN '2016-01-01' AND '2017-01-01'
ORDER BY occurred_at DESC;

NOTE - BETWEEN is tricky for dates! While BETWEEN is generally inclusive of endpoints, it assumes the time is at 00:00:00 (i.e. midnight) for dates. This is the reason why we set the right-side endpoint of the period at '2017-01-01'.
/*
Found list of orders ids where either gloss_qty or poster_qty is greater than 4000.
Only included the id field in the resulting table.
*/
SELECT id
FROM orders
WHERE gloss_qty > 4000 OR poster_qty > 4000;
/*
Wrote a query that returns a list of orders where the standard_qty is zero and either the gloss_qty or poster_qty is over 1000.
*/
SELECT *
FROM orders
WHERE standard_qty = 0 AND (gloss_qty > 1000 OR poster_qty > 1000);
/*
Found all the company names that start with a 'C' or 'W', and the primary contact contains 'ana' or 'Ana', but it doesn't contain 'eana'.
*/
SELECT *
FROM accounts
WHERE (name LIKE 'C%' OR name LIKE 'W%')
           AND ((primary_poc LIKE '%ana%' OR primary_poc LIKE '%Ana%')
           AND primary_poc NOT LIKE '%eana%');

#After learning about Joins, Aggregations, Data Cleaning, Subqueries & Temporary Tables..
