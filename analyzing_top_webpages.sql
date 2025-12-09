use mavenfuzzyfactory;

-- top landing page
CREATE TEMPORARY TABLE first_pageview
SELECT 
    website_session_id, MIN(website_pageview_id) as min_pv_id
FROM
    website_pageviews
WHERE
    website_pageview_id < 1000
GROUP BY website_session_id

SELECT 
    website_pageviews.pageview_url,
    COUNT(DISTINCT first_pageview.website_session_id)
FROM
    first_pageview
        LEFT JOIN
    website_pageviews ON first_pageview.min_pv_id = website_pageviews.website_pageview_id
GROUP BY website_pageviews.pageview_url 


-- top pages by pageviews
SELECT 
    pageview_url,
    COUNT(DISTINCT website_pageview_id) AS count_pv
FROM
    website_pageviews
WHERE
    created_at < '2012-06-09'
GROUP BY pageview_url
ORDER BY count_pv DESC

--
create temporary table first_pv
SELECT 
    website_session_id, MIN(website_pageview_id) as min_pv_id
FROM
    website_pageviews
where  created_at < '2012-06-12'
GROUP BY website_session_id

SELECT 
    pageview_url as landing_page_url, COUNT(DISTINCT first_pv.website_session_id) as sessions_hitting_page
FROM
    website_pageviews
        LEFT JOIN
    first_pv ON first_pv.min_pv_id = website_pageviews.website_pageview_id
GROUP BY pageview_url
ORDER BY sessions_hitting_page desc