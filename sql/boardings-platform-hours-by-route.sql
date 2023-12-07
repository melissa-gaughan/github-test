WITH t01 as(
SELECT
service_change_num, 
service_rte_num, 
express_local_cd, 
inbd_outbd_cd,
day_code,
day_part_cd, 
min_psngr_boardings, 
max_psngr_boardings, 
avg_psngr_boardings,
platform_hours,
revenue_hours,

case 
	when day_part_cd = 'AM' then 'Peak'
	when day_part_cd = 'MID' then 'Off Peak'
	when day_part_cd = 'PM' then 'Peak'
	when day_part_cd = 'XEV' then 'Night'
	when day_part_cd = 'XNT' then 'Night'

end as service_guidelines_period,

case 
	when day_code = 'WK' then platform_hours *255
	when day_code = 'SA' then platform_hours *52
	when day_code = 'SU' then platform_hours *58
end as annual_platform_hours,

case 
	when day_code = 'WK' then revenue_hours *255
	when day_code = 'SA' then revenue_hours  *52
	when day_code = 'SU' then revenue_hours  *58
end as annual_revenue_hours,


case 
	when day_code = 'WK' then min_psngr_boardings *255
	when day_code = 'SA' then min_psngr_boardings *52
	when day_code = 'SU' then min_psngr_boardings *58
end as annual_min_psngr_boardings,


case 
	when day_code = 'WK' then avg_psngr_boardings *255
	when day_code = 'SA' then avg_psngr_boardings *52
	when day_code = 'SU' then avg_psngr_boardings *58
end as annual_avg_psngr_boardings,

case 
	when day_code = 'WK' then max_psngr_boardings *255
	when day_code = 'SA' then max_psngr_boardings *52
	when day_code = 'SU' then max_psngr_boardings *58
end as annual_max_psngr_boardings,

case 
	when day_code = 'WK' then 255
	when day_code = 'SA' then 52
	when day_code = 'SU' then 58
end as annual_trips

FROM DP.TRIP_SUMMARY

WHERE service_change_num in (223) --change this to select service change numbers
AND (service_rte_num < 500 OR service_rte_num >600) --type the routes you are interested in here separated by commas. comment the entire line to get all routes
AND express_local_cd IN ('E', 'L')--useful if you are interested in an express or local variant of a route
--choose what service direction you are interested in
--AND inbd_outbd_cd IN ('I', 'O')
--choose what day type you need
AND day_code IN ('WK', 'SA', 'SU')
)
select
service_change_num, 
service_rte_num, 
express_local_cd, 
--inbd_outbd_cd,
day_code,
service_guidelines_period,

SUM(annual_min_psngr_boardings) AS sum_annual_min_passenger_boardings, 
SUM(annual_avg_psngr_boardings) AS sum_annual_avg_passenger_boardings,
SUM(annual_max_psngr_boardings) AS sum_annual_max_passenger_boardings,
SUM(platform_hours) as daily_platform_hours,
sum(revenue_hours) as daily_revenue_hours,
sum(annual_platform_hours) as annualized_platform_hours, 
sum(annual_revenue_hours) as  annualized_revenue_hours,
sum(annual_trips) as total_revenue_trips

from t01

GROUP BY service_change_num, 
service_rte_num, 
express_local_cd, 
--inbd_outbd_cd,
day_code,
service_guidelines_period
order by service_change_num, 
service_rte_num, 
express_local_cd,
day_code,
service_guidelines_period