DECLARE @service_change as int = 223;

with t01 as(
select 
KEY_BLOCK_NUM,
SCHED_DAY_TYPE_CODED_NUM,
BUS_BASE_ID, 
BUS_TYPE_NUM,
count(case when trip_kind_cd in('S') THEN 1 ELSE 0 END) as revenue_trips,
sum(trip_miles) as revenue_miles,
sum(trip_duration_mnts) as revenue_minutes
FROM DP.ALL_TRIPS
WHERE SERVICE_CHANGE_NUM = @service_change
AND WORKING_LOAD_STATUS = 'FINAL'
AND MINOR_CHANGE_NUM = 0
AND TRIP_KIND_CD = 'S'
GROUP BY KEY_BLOCK_NUM,
SCHED_DAY_TYPE_CODED_NUM,
BUS_BASE_ID, 
BUS_TYPE_NUM), 

t02 as ( SELECT KEY_BLOCK_NUM, 
SERVICE_CHANGE_NUM, 
SCHED_DAY_TYPE_CODED_NUM,
count(case when trip_kind_cd not in('S') THEN 1 ELSE 0 END) as nonrevenue_trips,
sum(trip_miles) as platform_miles,
sum(trip_duration_mnts) as platform_minutes
FROM DP.ALL_TRIPS
WHERE SERVICE_CHANGE_NUM = @service_change
AND  WORKING_LOAD_STATUS = 'FINAL'
AND MINOR_CHANGE_NUM = 0
GROUP BY SERVICE_CHANGE_NUM, KEY_BLOCK_NUM, SCHED_DAY_TYPE_CODED_NUM)

select t02.service_change_num,
t01.KEY_BLOCK_NUM,
t01.SCHED_DAY_TYPE_CODED_NUM, 
BUS_BASE_ID, 
BUS_TYPE_NUM,
revenue_trips, 
nonrevenue_trips, 
revenue_miles,
platform_miles, 
case
	when t01.SCHED_DAY_TYPE_CODED_NUM = 0 then ((t02.platform_minutes/60.0) *255)
	when t01.SCHED_DAY_TYPE_CODED_NUM = 1 then ((t02.platform_minutes/60.0) *52)
	when t01.SCHED_DAY_TYPE_CODED_NUM = 2 then ((t02.platform_minutes/60.0) *58) 

	end as annual_platform_hours, 
case
	when t01.SCHED_DAY_TYPE_CODED_NUM = 0 then ((t01.revenue_minutes/60.0) *255)
	when t01.SCHED_DAY_TYPE_CODED_NUM = 1 then ((t01.revenue_minutes/60.0) *52)
	when t01.SCHED_DAY_TYPE_CODED_NUM = 2 then ((t01.revenue_minutes/60.0) *58) 

	end as annual_revenue_hours
FROM t01, t02
WHERE t01.KEY_BLOCK_NUM = t02.KEY_BLOCK_NUM 

ORDER BY KEY_BLOCK_NUM, SCHED_DAY_TYPE_CODED_NUM