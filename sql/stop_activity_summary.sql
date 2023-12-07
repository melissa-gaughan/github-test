SELECT 
service_change_num, 
case when service_change_num = 193 then 'Fall 2019'
when service_change_num = 221 then 'Spring 2022'
End as service_change_name,
stop_id,
--comment out service_rte_num to see a summary of stop data without route breakdown 
service_rte_num, 
--comment out express_local_cd to see a summary of all stop data without route breakdown 
express_local_cd,
--comment out day_part_cd to see a summary of all stop data without time breakdown 
day_part_cd,
sum(avg_total_boardings) as sum_stop_boardings, 
sum(avg_total_alightings) as sum_stop_alightings, 
sum(avg_trip_boardings) as sum_stop_boardings_per_trip,
sum(avg_trip_alightings) as sum_stop_alightings_per_trip, 
sum(total_observations) as sum_observations

FROM dp.stop_activity_summary
--change this to the service change number of your choice. 

WHERE service_change_num in ( 193, 221)
--type the route numbers you are interested in between the parenthesis. 
--if you want all boardings at a stop, comment this line out by adding '--' in front of it
AND service_rte_num IN (20, 73, 301, 302, 303, 304, 322, 330, 331, 345, 346, 372)
--if you need to look at multiple stops, type their ids in the parenthesis 
--AND stop_id IN (60670, 50480, 61090)
--if you need just one stop, you can use the line below or delete everything else from
--the parenthesis
--AND stop_id = 60670

--this line tells tbird what time periods you are interested. 
--This table only has weekday data. Comment it out if you want to look across the whole day
AND day_part_cd IN ('AM', 'MID', 'PM', 'XEV', 'XNT')

--if you want to get summarized data for all stop boardings regardless of route or
--time of day, you will need to remove service_rte_num, express_local_cd and day_part_cd 
--from the grouping command
GROUP BY service_change_num, service_rte_num, stop_id,  day_part_cd, express_local_cd