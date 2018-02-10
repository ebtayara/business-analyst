JOINS
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

#First JOIN - The ON statement holds the two columns that get linked across the two tables.
/*
Pulled all the data from the accounts table, and all the data from the orders table.
*/
SELECT orders.*, accounts.*
FROM accounts
JOIN orders
ON accounts.id = orders.account_id;
/*
Pulled standard_qty, gloss_qty, and poster_qty from the orders table, and the website and the primary_poc from the accounts table.
*/
SELECT orders.standard_qty, orders.gloss_qty,
       orders.poster_qty,  accounts.website,
       accounts.primary_poc
FROM orders
JOIN accounts
ON orders.account_id = accounts.id

#Alias
/*
Provided a table for all web_events associated with account name of Walmart.
Included the primary_poc, time of the event, and the channel for each event.
I also added a fourth column to assure only Walmart events were chosen.
*/
SELECT a.primary_poc, w.occurred_at, w.channel, a.name
FROM web_events w
JOIN accounts a
ON w.account_id = a.id
WHERE a.name = 'Walmart';
/*
Created a table that provides the region for each sales_rep along with their associated accounts.
Sorted the accounts alphabetically (A-Z) according to account name.
*/
SELECT r.name region, s.name rep, a.name account
FROM sales_reps s
JOIN region r
ON s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id
ORDER BY a.name;
/*
Provided the name for each region for every order, as well as the account name and the unit price they paid (total_amt_usd/total) for the order.
A few accounts had 0 for total, so I divided by (total + 0.01) to assure not dividing by zero.
*/
SELECT r.name region, a.name account,
       o.total_amt_usd/(o.total + 0.01) unit_price
FROM region r
JOIN sales_reps s
ON s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON o.account_id = a.id;

#Left/Right Joins
/*
Provided a table that provides the region for each sales_rep along with their associated accounts
for the Midwest region. Sorted the accounts alphabetically (A-Z) according to account name.
*/
SELECT r.name region, s.name rep, a.name account
FROM sales_reps s
JOIN region r
ON s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id
WHERE r.name = 'Midwest'
ORDER BY a.name;
/*
Provided a table that provides the region for each sales_rep along with their associated accounts
for accounts where the sales rep has a first name starting with S and in the Midwest region.
Sorted the accounts alphabetically (A-Z) according to account name.
*/
SELECT r.name region, s.name rep, a.name account
FROM sales_reps s
JOIN region r
ON s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id
WHERE r.name = 'Midwest' AND s.name LIKE 'S%'
ORDER BY a.name;
/*
Provided a table that provides the region for each sales_rep along with their associated accounts
for accounts where the sales rep has a last name starting with K and in the Midwest region.
Sorted the accounts alphabetically (A-Z) according to account name.
*/
SELECT r.name region, s.name rep, a.name account
FROM sales_reps s
JOIN region r
ON s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id
WHERE r.name = 'Midwest' AND s.name LIKE '% K%'
ORDER BY a.name;
/*
Provided the name for each region for every order, as well as the account name
and the unit price they paid (total_amt_usd/total) for the order.
Only provided the results if the standard order quantity exceeds 100.
*/
SELECT r.name region, a.name account, o.total_amt_usd/(o.total + 0.01) unit_price
FROM region r
JOIN sales_reps s
ON s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON o.account_id = a.id
WHERE o.standard_qty > 100;
/*
Provided the name for each region for every order, as well as the account name
and the unit price they paid (total_amt_usd/total) for the order.
Only provided the results if the standard order quantity exceeds 100 and the poster order quantity exceeds 50.
Sorted for the smallest unit price first.
*/
SELECT r.name region, a.name account, o.total_amt_usd/(o.total + 0.01) unit_price
FROM region r
JOIN sales_reps s
ON s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON o.account_id = a.id
WHERE o.standard_qty > 100 AND o.poster_qty > 50
ORDER BY unit_price;
/*
^same, except sorted for the largest unit price first.
*/
SELECT r.name region, a.name account, o.total_amt_usd/(o.total + 0.01) unit_price
FROM region r
JOIN sales_reps s
ON s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON o.account_id = a.id
WHERE o.standard_qty > 100 AND o.poster_qty > 50
ORDER BY unit_price DESC;
/*
Provided the different channels used by account id 1001.
Tried SELECT DISTINCT to narrow down the results to only the unique values.
*/
SELECT DISTINCT a.name, w.channel
FROM accounts a
RIGHT JOIN web_events w
ON a.id = w.account_id
WHERE a.id = '1001';
/*
Found all the orders that occurred in 2015.
The final table showed 4 columns: occurred_at, account name, order total, and order total_amt_usd.
*/
SELECT o.occurred_at, a.name, o.total, o.total_amt_usd
FROM accounts a
JOIN orders o
ON o.account_id = a.id
WHERE o.occurred_at BETWEEN '01-01-2015' AND '01-01-2016'
ORDER BY o.occurred_at DESC;
