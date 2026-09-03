-- ============================================================
-- 1. DIMENSION: GEOLOCATION
-- Grain: One row per zip code prefix
-- ============================================================

DROP TABLE IF EXISTS dwh.dim_geolocation;

CREATE TABLE dwh.dim_geolocation AS
SELECT 
    geolocation_zip_code_prefix AS zip_code_prefix,
    MAX(geolocation_lat) AS latitude,
    MAX(geolocation_lng) AS longitude,
    INITCAP(MAX(geolocation_city)) AS city,
    MAX(geolocation_state) AS state
FROM staging.olist_geolocation_dataset
GROUP BY geolocation_zip_code_prefix;


-- ============================================================
-- 2. FACT: MARKETING FUNNEL
-- Grain: One row per MQL
-- ============================================================

DROP TABLE IF EXISTS dwh.fact_funnel;

CREATE TABLE dwh.fact_funnel AS

WITH ranked_mql AS (
    SELECT 
        mql_id,
        first_contact_date,
        origin,
        landing_page_id,

        ROW_NUMBER() OVER (
            PARTITION BY mql_id
            ORDER BY first_contact_date ASC
        ) AS row_num

    FROM staging.olist_marketing_qualified_leads_dataset
)

SELECT
    m.mql_id,

    m.first_contact_date::date AS contact_date,

    m.landing_page_id,

    INITCAP(
        REPLACE(m.origin, '_', ' ')
    ) AS lead_origin,

    c.seller_id,
    c.sdr_id,
    c.sr_id,

    c.won_date::timestamp AS won_date,

    INITCAP(
        REPLACE(c.business_segment, '_', ' ')
    ) AS business_segment,

    INITCAP(
        REPLACE(c.lead_type, '_', ' ')
    ) AS lead_type,

    c.lead_behaviour_profile,
    c.has_company,
    c.has_gtin,
    c.average_stock,
    c.business_type,
    c.declared_product_catalog_size,
    c.declared_monthly_revenue,

    CASE
        WHEN c.mql_id IS NOT NULL THEN 1
        ELSE 0
    END AS is_won

FROM ranked_mql m

LEFT JOIN staging.olist_closed_deals_dataset c
    ON m.mql_id = c.mql_id

WHERE m.row_num = 1;


-- ============================================================
-- 3. DIMENSION: CUSTOMER
-- Grain: One row per customer_id
-- ============================================================

DROP TABLE IF EXISTS dwh.dim_customer;

CREATE TABLE dwh.dim_customer AS

WITH customer_first_purchase AS (

    SELECT 
        c.customer_unique_id,

        MIN(
            o.order_purchase_timestamp::date
        ) AS first_purchase_date,

        DATE_TRUNC(
            'month',
            MIN(o.order_purchase_timestamp::timestamp)
        )::date AS cohort_month

    FROM staging.olist_customers_dataset c

    JOIN staging.olist_orders_dataset o
        ON c.customer_id = o.customer_id

    GROUP BY c.customer_unique_id
)

SELECT 
    c.customer_id,
    c.customer_unique_id,
    c.customer_zip_code_prefix,

    INITCAP(c.customer_city) AS customer_city,

    c.customer_state,

    g.latitude,
    g.longitude,

    cfp.first_purchase_date,
    cfp.cohort_month

FROM staging.olist_customers_dataset c

LEFT JOIN dwh.dim_geolocation g
    ON c.customer_zip_code_prefix = g.zip_code_prefix

LEFT JOIN customer_first_purchase cfp
    ON c.customer_unique_id = cfp.customer_unique_id;


-- ============================================================
-- 4. DIMENSION: SELLER
-- Grain: One row per seller
-- ============================================================

DROP TABLE IF EXISTS dwh.dim_seller;

CREATE TABLE dwh.dim_seller AS

SELECT DISTINCT

    s.seller_id,

    s.seller_zip_code_prefix,

    INITCAP(s.seller_city) AS seller_city,

    s.seller_state,

    g.latitude,
    g.longitude,

    f.lead_origin,
    f.business_segment,

    CASE
        WHEN f.seller_id IS NOT NULL
            THEN 'Marketing Acquired'
        ELSE 'Organic'
    END AS acquisition_channel

FROM staging.olist_sellers_dataset s

LEFT JOIN dwh.dim_geolocation g
    ON s.seller_zip_code_prefix = g.zip_code_prefix

LEFT JOIN dwh.fact_funnel f
    ON s.seller_id = f.seller_id;


-- ============================================================
-- 5. DIMENSION: PRODUCT
-- Grain: One row per product
-- ============================================================

DROP TABLE IF EXISTS dwh.dim_product;

CREATE TABLE dwh.dim_product AS

SELECT

    p.product_id,

    COALESCE(
        INITCAP(
            REPLACE(
                t.product_category_name_english,
                '_',
                ' '
            )
        ),
        'Unknown'
    ) AS product_category,

    p.product_name_lenght AS product_name_length,

    p.product_description_lenght AS product_description_length,

    p.product_photos_qty,

    p.product_weight_g,

    p.product_length_cm,

    p.product_height_cm,

    p.product_width_cm

FROM staging.olist_products_dataset p

LEFT JOIN staging.product_category_name_translation t
    ON p.product_category_name = t.product_category_name;


-- ============================================================
-- 6. FACT: SALES
-- Grain: One row per order item
-- ============================================================

DROP TABLE IF EXISTS dwh.fact_sales;

CREATE TABLE dwh.fact_sales AS

SELECT

    i.order_id,

    i.order_item_id,

    i.product_id,

    i.seller_id,

    o.customer_id,

    o.order_status,

    o.order_purchase_timestamp::timestamp
        AS purchase_date,

    o.order_approved_at::timestamp
        AS approved_date,

    o.order_delivered_carrier_date::timestamp
        AS delivered_carrier_date,

    o.order_estimated_delivery_date::timestamp
        AS estimated_delivery_date,

    o.order_delivered_customer_date::timestamp
        AS delivered_date,

    i.shipping_limit_date::timestamp
        AS shipping_limit_date,

    i.price,

    i.freight_value

FROM staging.olist_order_items_dataset i

JOIN staging.olist_orders_dataset o
    ON i.order_id = o.order_id;


-- ============================================================
-- 7. FACT: PAYMENTS
-- Grain: One row per payment record
-- ============================================================

DROP TABLE IF EXISTS dwh.fact_payments;

CREATE TABLE dwh.fact_payments AS

SELECT

    order_id,

    payment_sequential,

    payment_type,

    payment_installments,

    payment_value

FROM staging.olist_order_payments_dataset;


-- ============================================================
-- 8. DIMENSION: ORDERS
-- Grain: One row per order
-- ============================================================

DROP TABLE IF EXISTS dwh.dim_orders;

CREATE TABLE dwh.dim_orders AS

SELECT DISTINCT
    order_id

FROM staging.olist_orders_dataset;


-- ============================================================
-- 9. DATA QUALITY CHECKS
-- ============================================================

-- Check customer uniqueness
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM dwh.dim_customer;


-- Check seller uniqueness
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT seller_id) AS unique_sellers
FROM dwh.dim_seller;


-- Check product uniqueness
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT product_id) AS unique_products
FROM dwh.dim_product;


-- Check sales grain
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT order_id) AS unique_orders,
    COUNT(DISTINCT order_item_id) AS unique_order_items
FROM dwh.fact_sales;


-- Check funnel grain
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT mql_id) AS unique_mqls
FROM dwh.fact_funnel;
