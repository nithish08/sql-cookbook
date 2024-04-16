-- simple use of case statement


-- https://leetcode.com/problems/monthly-transactions-i/description/?envType=study-plan-v2&envId=top-sql-50
-- Write an SQL query to find for each month and country, the number of transactions and their total amount, the number of approved transactions and their total amount.
-- Return the result table in any order.
-- The query result format is in the following example.

select 
DATE_FORMAT(trans_date, '%Y-%m') AS month, 
country,
sum(1) as trans_count,
sum(case when state="approved" then 1 else 0 end) as approved_count,
sum(amount) as trans_total_amount,
sum(case when state="approved" then amount else 0 end) as approved_total_amount
from 
Transactions
group by 1,2 order by 2,1;