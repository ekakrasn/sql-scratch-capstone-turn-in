-- Getting Familiar Campaigns and Sources First Query

SELECT COUNT(DISTINCT utm_campaign)
FROM page_visits;

-- Getting Familiar Campaigns and Sources Second Query

SELECT COUNT(DISTINCT utm_source)
FROM page_visits;

-- Getting Familiar Campaigns and Sources Third Query

SELECT DISTINCT utm_campaign, utm_source
FROM page_visits;

-- Getting Familiar Pages

SELECT DISTINCT page_name
FROM page_visits;

-- User Journey First Touches Query

WITH first_touch AS (
    SELECT user_id,
        MIN(timestamp) as first_touch_at
    FROM page_visits
    GROUP BY user_id),
attribution_ft AS (
  SELECT ft.user_id,
    ft.first_touch_at,
    pv.utm_source,
    pv.utm_campaign
  FROM first_touch ft
  JOIN page_visits pv
    ON ft.user_id = pv.user_id
    AND ft.first_touch_at = pv.timestamp
)
SELECT attribution_ft.utm_campaign AS 'campaign_name', 
       COUNT(*) AS 'first_touches'
FROM attribution_ft
GROUP BY 1
ORDER BY 2 DESC;

-- User Journey Last Touches Query

WITH last_touch AS (
    SELECT user_id,
        MAX(timestamp) as last_touch_at
    FROM page_visits
    GROUP BY user_id),
attribution_lt AS (
  SELECT lt.user_id,
    lt.last_touch_at,
    pv.utm_source,
    pv.utm_campaign
  FROM last_touch lt
  JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
)
SELECT attribution_lt.utm_campaign AS 'campaign_name', 
       COUNT(*) AS 'last_touches'
FROM attribution_lt
GROUP BY 1
ORDER BY 2 DESC;

-- User Journey Purchases First Query

SELECT COUNT(DISTINCT user_id)
FROM page_visits
WHERE page_name = '4 - purchase’;

-- User Journey Purchases Second Query

WITH last_touch AS (
    SELECT user_id,
        MAX(timestamp) as last_touch_at
    FROM page_visits
    WHERE page_name = '4 - purchase'
    GROUP BY user_id),
attribution_lt AS (
  SELECT lt.user_id,
    lt.last_touch_at,
    pv.utm_source,
    pv.utm_campaign
  FROM last_touch lt
  JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
)
SELECT attribution_lt.utm_campaign AS 'campaign_name', 
       COUNT(*) AS 'last_touches'
FROM attribution_lt
GROUP BY 1
ORDER BY 2 DESC;