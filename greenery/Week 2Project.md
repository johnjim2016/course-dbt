What is our user repeat rate?
--0.79838709677419354839 ~80%

WITH order_bucket AS (
SELECT 
user_id
,COUNT(DISTINCT order_id) as total_orders
FROM dbt_john_j.stg_orders
GROUP BY 1
)
SELECT
COUNT(DISTINCT user_id) as total_users
,COUNT(DISTINCT CASE WHEN total_orders>1 THEN user_id ELSE NULL END) as repeat_users
,CAST(COUNT(DISTINCT CASE WHEN total_orders>1 THEN user_id ELSE NULL END) AS DECIMAL(7,2) )/COUNT(DISTINCT user_id) as repeat_pct
FROM order_bucket
;


What are good indicators of a user who will likely purchase again? What about indicators of users who are likely NOT to purchase again? If you had more data, what features would you want to look into to answer this question?

At my company, we would perform the following steps to help start answering the question:  

1) define who owns this question? is it growth, product, marketing ,etc? 

2) we would want to understand the buckets: purchasers vs non-purchasers; 

3) dissect repeat purchasers, one time purchases, and non purchases?

    A) I would compare general characteristics at a user level (age, demographics) 

    B) I would look at order level information is there a product that is performing well proportionally amongst the groups, is there a promo that led to this, 

    C) I would look at event level data to find out the what the users journey looked like for each group? Is there a landing page performing much better amongst repeat users? is there process in the chain for non-purchasers that we need to improve? I would also look at the when the order was created vs when it was delivered to see if there were was correlation between delivery expediency

Explain the marts models you added. Why did you organize the models in the way you did?

Core:
> fct_session: session level data on user journey
> dim_user: user level data with address information
Marketing:
> fct_users_orders: user information on first order date, last order date, and total spend, who is high value
Product:
> fct_order_product: product information on order item level to assess which products are doing super well

What assumptions are you making about each model? (i.e. why are you adding each test?)
> fct_session: session level data on user journey
--> all products shipped should also have a checkout page view.
> fct_users_orders: user information on first order date, last order date, and total spend, who is high value
--> first order date should not be after last order date
> fct_order_product: product information on order item level to assess which products are doing super well
---> quantities should be positive

Did you find any “bad” data as you added and ran tests on your models? How did you go about either cleaning the data in the dbt model or adjusting your assumptions/tests?

when I ran my tests, i made a unique tests on the first column which was flawed because I had repeat ids just based on my logic. For example, i ran a unique test on orderis on fct_order_product table BUT this was flawed because I had repeat orderids based on individual order_item_ids. One step i took was to eliminate the tests and really think through what tests are valuable. 

Additional steps would be to allow data consumers to also analyze this information to make sure that they think it is available. 

Your stakeholders at Greenery want to understand the state of the data each day. Explain how you would ensure these tests are passing regularly and how you would alert stakeholders about bad data getting through.

I think we often talk about data roles as siloed which is fundamentally flawed. The feedback loop between analytics engineers and data analyst is often one sided. Analytics Engineers are the individuals gathering business requirements and produce a product but the conversation often stops there with minimal testing. I would talk to data consumers about what issues with the data they have seen in the past to make sure that my tests are capturing. I would also create a notion doc to make sure that we testing the right tables. This type of conversation is key to growing feedback loops. 