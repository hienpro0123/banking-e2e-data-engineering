{{ config(
    materialized='incremental', 
    unique_key='transaction_id'
) }}

WITH deduped_transactions AS (
    SELECT *
    FROM {{ ref('stg_transactions') }}
    -- Lọc lấy bản ghi mới nhất cho mỗi ID nếu bị lặp
    QUALIFY ROW_NUMBER() OVER (
        PARTITION BY transaction_id 
        ORDER BY transaction_time DESC
    ) = 1
)

SELECT
    t.transaction_id,
    t.account_id,
    a.customer_id,
    t.amount,
    t.related_account_id,
    t.status,
    t.transaction_type,
    t.transaction_time,
    CURRENT_TIMESTAMP AS load_timestamp
FROM deduped_transactions t
LEFT JOIN {{ ref('stg_accounts') }} a
    ON t.account_id = a.account_id

{% if is_incremental() %}
    -- Chỉ lấy dữ liệu mới hơn thời điểm lớn nhất hiện có trong bảng
    WHERE t.transaction_time > (SELECT MAX(transaction_time) FROM {{ this }})
{% endif %}