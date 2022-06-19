--ensure that first order_date is before or on last order date
SELECT *
FROM {{ref('fct_users_order')}}
WHERE first_order_date>last_order_date
