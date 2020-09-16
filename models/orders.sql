with orders as (
    select * from {{ref('stg_orders')}}
)

, payments as (
    select * from {{ref('stg_payments')}}
)

, final as (
    select
        orders.order_id,
        orders.customer_id,
        sum(payments.amount) as total_amount
    from orders
    left join payments
    on payments.order_id = orders.order_id
    group by 1, 2

)

select * from final