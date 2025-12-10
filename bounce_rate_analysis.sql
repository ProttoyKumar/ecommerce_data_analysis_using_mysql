use mavenfuzzyfactory;

Create temporary table first_pageviews_demo
SELECT 
    website_pageviews.website_session_id,
    MIN(website_pageviews.website_pageview_id) as min_pv_id
FROM
    website_pageviews
        INNER JOIN
    website_sessions ON website_sessions.website_session_id = website_pageviews.website_session_id
    And website_sessions.created_at between '2014-01-01' and '2014-02-01'
GROUP BY website_pageviews.website_session_id;

Create temporary table sessions_w_landing_page_demo
SELECT 
    first_pageviews_demo.website_session_id,
    website_pageviews.pageview_url as landing_page
FROM
    first_pageviews_demo
Inner Join website_pageviews on website_pageviews.website_pageview_id = first_pageviews_demo.min_pv_id;

Create temporary table bounced_sessions_only
SELECT 
    sessions_w_landing_page_demo.website_session_id,
    sessions_w_landing_page_demo.landing_page,
    COUNT(DISTINCT website_pageviews.website_pageview_id) AS count_of_pages_viewed
FROM
    sessions_w_landing_page_demo
        INNER JOIN
    website_pageviews ON website_pageviews.website_session_id = sessions_w_landing_page_demo.website_session_id
GROUP BY sessions_w_landing_page_demo.website_session_id , sessions_w_landing_page_demo.landing_page
Having count_of_pages_viewed = 1;

SELECT 
    sessions_w_landing_page_demo.landing_page,
    sessions_w_landing_page_demo.website_session_id,
    bounced_sessions_only.website_session_id AS bounced_website_session_id
FROM
    sessions_w_landing_page_demo
        LEFT JOIN
    bounced_sessions_only ON bounced_sessions_only.website_session_id = sessions_w_landing_page_demo.website_session_id
ORDER BY sessions_w_landing_page_demo.website_session_id;

SELECT 
    sessions_w_landing_page_demo.landing_page,
    COUNT(DISTINCT sessions_w_landing_page_demo.website_session_id) AS sessions,
    COUNT(DISTINCT bounced_sessions_only.website_session_id) AS bounced_sessions,
    COUNT(DISTINCT bounced_sessions_only.website_session_id) / COUNT(DISTINCT sessions_w_landing_page_demo.website_session_id) as bounce_rate
FROM
    sessions_w_landing_page_demo
        LEFT JOIN
    bounced_sessions_only ON bounced_sessions_only.website_session_id = sessions_w_landing_page_demo.website_session_id
GROUP BY sessions_w_landing_page_demo.landing_page;

