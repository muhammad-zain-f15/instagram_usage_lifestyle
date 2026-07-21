/*
q1. Identify the top 10 users with the highest engagement score who also spend more than 2 hours
per day on Instagram.
*/

SELECT TOP 10
	user_id, user_engagement_score
FROM bronze.instagram_usage
WHERE daily_active_minutes_instagram >= 120
ORDER BY user_engagement_score desc;

/*
q2. Determine whether urban or rural users spend more time on Instagram on average.
*/
SELECT 
	urban_rural,
	AVG(daily_active_minutes_instagram) as avg_time
FROM bronze.instagram_usage
GROUP BY urban_rural;

/*
q3.Find users who have high stress levels but also high Instagram activity. (Example condition:
stress score > threshold and daily active minutes > threshold)
*/

SELECT
	user_id,
	perceived_stress_score,
	daily_active_minutes_instagram
FROM bronze.instagram_usage
WHERE 
perceived_stress_score > (select avg(perceived_stress_score) FROM bronze.instagram_usage) 
and
daily_active_minutes_instagram > (select avg(daily_active_minutes_instagram) FROM bronze.instagram_usage);

/*
q4.Write a SQL query to show the average daily_active_minutes_instagram for each
combination of age group (<25, 25-34, 35-44, 45+) and gender.
*/

with age_groups as
(
	SELECT
		case 
			when age < 25 then '<25'
			when age  <=34 then '25-34'
			when age <=44 then '35-44'
			else '45+'
	    end as age_group,
		daily_active_minutes_instagram,
		gender
	FROM bronze.instagram_usage
)
SELECT
	age_group,
	gender,
	avg(daily_active_minutes_instagram) as avg_time
FROM age_groups
GROUP BY age_group,gender;

/*
q5. Write a SQL query to find the country with the highest average followers_count, and also
return the average posts_created_per_week for users in that country.
*/

SELECT top 1
	country,
	avg(followers_count) as avg_followers_count,
	avg(posts_created_per_week) as avg_post_per_week
FROM bronze.instagram_usage
GROUP BY country
ORDER BY avg(followers_count) desc;

/*
q6. Show the average self_reported_happiness for smokers vs non-smokers, split further into two
groups: those who exercise > 5 hours/week and those who do not.
*/
with exercise_groups as
(	SELECT 
		exercise_hours_per_week,
		case 
			when exercise_hours_per_week > 5 then '>5 hours exercise'
			else '<5 hours exercise'
		end as exercise_group,
		self_reported_happiness,
		smoking
	FROM bronze.instagram_usage
)

SELECT
	smoking,
	exercise_group,
	avg(self_reported_happiness) as avg_happiness
FROM exercise_groups
GROUP BY smoking,exercise_group;

/*
q7. Among users where income_level = 'high', write a SQL query to find the most frequent
preferred_content_theme and the corresponding average notification_response_rate for users
who prefer that theme.
*/

SELECT top 1
	preferred_content_theme,
	count(preferred_content_theme) as 'frequency',
	avg(notification_response_rate) as avg_notification_response_rate
FROM bronze.instagram_usage
WHERE income_level = 'high'
GROUP BY preferred_content_theme
ORDER BY count(preferred_content_theme) desc;

/*
q8. Determine which content theme leads to the highest user engagement score on average.
*/

SELECT top 1
	preferred_content_theme,
	avg(user_engagement_score) as avg_engagement_score
FROM bronze.instagram_usage
GROUP BY preferred_content_theme
ORDER BY avg(user_engagement_score) desc;

/*
q9. Find the relationship between alcohol frequency and daily Instagram usage by computing the
average usage grouped by alcohol frequency.
*/

SELECT 
	alcohol_frequency,
	avg(daily_active_minutes_instagram) as avg_usage
FROM bronze.instagram_usage
GROUP BY alcohol_frequency
ORDER BY avg(daily_active_minutes_instagram) desc;

/*
q10. Among users with followers_count > 500, write a SQL query to show the average
ads_clicked_per_day for those who view more than 20 stories_viewed_per_day vs. those who
view 5 or fewer.
*/

with viewed_stories_groups as
(	SELECT 
		followers_count,
		stories_viewed_per_day,
		case 
			when stories_viewed_per_day > 20 then '>20 stories'
			when stories_viewed_per_day <= 5 then '5 or fewer'
			else 'others'
		end as stories_groups,
		ads_clicked_per_day
	FROM bronze.instagram_usage
)
SELECT 
	stories_groups,
	avg(ads_clicked_per_day) as avg_ads_clicked
FROM viewed_stories_groups
WHERE 
followers_count > 500
GROUP BY stories_groups;
