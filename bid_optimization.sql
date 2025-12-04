use mavenfuzzyfactory;

-- Date functions
SELECT 
    website_session_id,
    created_at,
    DATE(created_at) AS date,
    YEAR(created_at) AS year,
    MONTH(created_at) AS month
FROM
    website_sessions

-- use of count and case
-- finds how many orders contain 1 item and how many contain 2 items
SELECT 
    primary_product_id,
    COUNT(CASE
            WHEN items_purchased = 1 THEN 1
        END) AS orders_with_1_item,
    COUNT(CASE
            WHEN items_purchased = 2 THEN 1
        END) AS orders_with_2_items
FROM
    orders
WHERE
    order_id BETWEEN 31000 AND 32000
GROUP BY primary_product_id

-- It helps us analyze:
-- How many orders are small (1 item)
-- How many are larger (2 items)
-- Which products tend to be bought alone or with more items

-- weekly traffic trends for a campaign
-- Understanding seasonality and traffic patterns
SELECT 
    YEAR(created_at),
    WEEK(created_at),
    MIN(DATE(created_at)) AS week_start,
    COUNT(website_session_id) as sessions
FROM
    website_sessions
WHERE
    utm_source = 'gsearch'
        AND utm_campaign = 'nonbrand'
        AND created_at < '2012-05-10'
GROUP BY 1 , 2
-- Comment: traffic declined sharply, suggesting a change in campaign performance or budget.

-- Convertion rates from session to order by device type
SELECT 
    device_type,
    COUNT(DISTINCT website_sessions.website_session_id) AS sessions,
    COUNT(DISTINCT orders.order_id) AS orders,
    COUNT(DISTINCT orders.order_id) / COUNT(DISTINCT website_sessions.website_session_id) AS session_to_order_conv_rate
FROM
    website_sessions
        LEFT JOIN
    orders ON orders.website_session_id = website_sessions.website_session_id
WHERE
    website_sessions.created_at < '2012-05-11'
        AND utm_source = 'gsearch'
        AND utm_campaign = 'nonbrand'
GROUP BY 1
-- Comment: It is recommended to bid gsearch nonbrand desktop campaigns up

-- Show the impact of bid changes for nonbrand gsearch campaigns
SELECT 
    MIN(DATE(created_at)) AS week_start,
    COUNT(CASE
        WHEN device_type = 'desktop' THEN 1
    END) AS desktop_sessions,
    COUNT(CASE
        WHEN device_type = 'mobile' THEN 1
    END) AS mobile_sessions
FROM
    website_sessions
WHERE
    created_at < '2012-06-09'
        AND utm_source = 'gsearch'
        AND utm_campaign = 'nonbrand'
GROUP BY YEAR(created_at) , WEEK(created_at)
