/*  ***********    Project 1 Presentation By Group 6  ***********
                                                        
Project code: P250

Domain : E-Commerce

Project Name: Olist Store Analysis

Summary: Olist is a Brazilian e-commerce platform that connects small and medium-sized businesses to customers across Brazil. 
The platform operates as a marketplace, where merchants can list their products and services and customers can browse and purchase them online.

Dataset Name: Total 9 files

EDA: These are the following quality issues:

- Null & Empty values
- Unwanted special characters
- Irrelevant columns
- Errors in spelling

Import: 9 clean files

*/
----------------------------------------------------------------
use project1_oliststoreanalysis;

-- _______________________________________________________________________________________________________________
-- KPI_1. Weekday Vs Weekend (order_purchase_timestamp) Payment Statistics

select  
case 
when weekday(o.order_purchase_timestamp)=5 then "weekend"
when weekday(o.order_purchase_timestamp)=6 then "weekend"
else "weekday"
end as Weekday_Vs_Weekend,
count(o.order_purchase_timestamp) as No_Of_Order_Placed, 
concat(round((count(o.order_id)/103886)*100),"%") as percentage_Order_Placed,
round(sum(op.payment_value),2) as Total_Payment,
concat(round((sum(op.payment_value)/16008872)*100),"%") as percentage_payment
from orders as o
inner join
order_payments as op
on (op.order_id=o.order_id)
group by  Weekday_Vs_Weekend;

-- __________________________________________________________________________________________________________________________________________

-- 2. Number of Orders with review score 5 and payment type as credit card.
select count(*) as Total_Orders
from order_reviews as ors
inner join
order_payments as op
on (op.order_id=ors.order_id)
where
ors.review_score=5
and
op.payment_type="credit_card";

-- ______________________________________________________________________________________________________________________________
-- 3. Average number of days taken for order_delivered_customer_date for pet_shop

select round(avg(datediff( o.order_delivered_customer_date, o.order_purchase_timestamp)),0) as average_delivery_days
from orders as o
inner join
order_items as oi
on (o.order_id=oi.order_id)
inner join
products as p
on (oi.product_id=p.product_id)
where
p.product_category_name="pet_shop";

-- ________________________________________________________________________________________________________________________________
-- 4. Average price and payment values from customers of sao paulo city

select truncate(avg((oi.price)),2) as AvgPrice, truncate(avg((op.payment_value)),2) as AvgPayment
from order_payments as op
inner join
order_items as oi
on (op.order_id=oi.order_id)
inner join
orders as o
on (oi.order_id=o.order_id)
inner join
customers as c
on (o.customer_id=c.customer_id)
where customer_city="Sao paulo";

-- ___________________________________________________________________________________________________________________________________
-- 5. Relationship between shipping days (order_delivered_customer_date - order_purchase_timestamp) Vs review scores.

select ors.review_score, 
round(avg( datediff(o.order_delivered_customer_date, o.order_purchase_timestamp)),0)
as Avg_shipping_days
from
orders as o
join
order_reviews as ors
on o.order_id=ors.order_id
group by ors.review_score
order by ors.review_score;

