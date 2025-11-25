use mavenfuzzyfactory;


-- Finding top traffic sources
SELECT 
    utm_source,
    utm_campaign,
    http_referer,
    COUNT(DISTINCT website_session_id)
FROM
    website_sessions
WHERE
    created_at < '2012-04-14'
GROUP BY utm_source , utm_campaign , http_referer
ORDER BY COUNT(DISTINCT website_session_id) DESC

-- Calculate Conversion Rate (CVR) from Session to Order
SELECT 
    utm_source,
    utm_campaign,
    COUNT(DISTINCT orders.order_id) / COUNT(DISTINCT website_sessions.website_session_id) AS session_to_order_cvr
FROM
    website_sessions
        LEFT JOIN
    orders ON website_sessions.website_session_id = orders.website_session_id
WHERE
    website_sessions.created_at < '2012-04-14'
GROUP BY utm_source , utm_campaign
ORDER BY session_to_order_cvr DESC
