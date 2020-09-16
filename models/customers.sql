{{
  config(
    materialized='view'
  )
}}

with customers as (

    select * from {{ ref('stg_customers') }}

),

orders as (

    select * from {{ ref('stg_orders') }}

),

payments as (

    select * from {{ref('stg_payments')}}
),

customer_orders_all as (

    select
        customer_id,
        payments.status,
        min(orders.order_date) as first_order_date,
        max(orders.order_date) as most_recent_order_date,
        count(orders.order_id) as number_of_orders,
        sum(payments.amount) as lifetime_value

    from orders
    left join payments
    on payments.order_id = orders.order_id
    group by 1, 2

),

customer_orders as (
    select *
    from customer_orders_all
    where status = 'success'
),

final as (

    select
        customers.customer_id,
        customers.first_name,
        customers.last_name,
        customer_orders.first_order_date,
        customer_orders.most_recent_order_date,
        coalesce(customer_orders.number_of_orders, 0) as number_of_orders,
        coalesce(customer_orders.lifetime_value, 0 ) as lifetime_value

    from customers

    left join customer_orders using (customer_id)

)

select * from final