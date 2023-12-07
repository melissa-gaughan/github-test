WITH t01 as ( SELECT  
SERVICE_CHANGE_NUM, 
SCHED_DAY_TYPE_CODED_NUM,
WORKING_LOAD_STATUS,
sum(TRIP_DURATION_MNTS) as trip_minutes
FROM DP.ALL_TRIPS
WHERE SERVICE_CHANGE_NUM = 223
AND  WORKING_LOAD_STATUS = 'FINAL'
AND MINOR_CHANGE_NUM = 0 --working load and minor change only for SC after 172
GROUP BY SERVICE_CHANGE_NUM, SCHED_DAY_TYPE_CODED_NUM, WORKING_LOAD_STATUS), 

t02 as(

select service_change_num,
SCHED_DAY_TYPE_CODED_NUM,
WORKING_LOAD_STATUS,
case
	when t01.SCHED_DAY_TYPE_CODED_NUM = 0 then ((t01.trip_minutes/60.0) *255)
	when t01.SCHED_DAY_TYPE_CODED_NUM = 1 then ((t01.trip_minutes/60.0) *52)
	when t01.SCHED_DAY_TYPE_CODED_NUM = 2 then ((t01.trip_minutes/60.0) *58) 

	end as annual_platform_hours
FROM t01


)

select service_change_num,
WORKING_LOAD_STATUS,
round(sum(annual_platform_hours),2) as annual_platform_hours_sum

FROM t02
GROUP BY service_change_num, WORKING_LOAD_STATUS