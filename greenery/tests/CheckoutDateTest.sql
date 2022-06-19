-- this tests ensures that everyone who has a package_shipped has gone through the checkout process instead of some backdoor deals

SELECT *
FROM {{ref('fct_sess')}}
WHERE checkout<package_shipped
