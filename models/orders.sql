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
        payments.amount
    from orders
    left join payments
    on payments.order_id = orders.order_id

)

select * from final