SELECT 
service_change_num,
stop_id,
--comment out service_rte_num to see a summary of stop data without route breakdown 
service_rte_num, 
--comment out express_local_cd to see a summary of all stop data without route breakdown 
express_local_cd,
trip_id, 
inbd_outbd_cd,
host_street_nm, 
cross_street_nm, 
jurisdiction_cd,
stop_sequence_num, 
avg_arrival_clock_time, 
avg_arrival_mnts_after_midnt,
--comment out day_part_cd to see a summary of all stop data without time breakdown 
day_part_cd,
sum(avg_psngr_boardings) as avg_stop_boardings, 
sum(avg_psngr_alightings) as avg_stop_alightings
--sum(avg_trip_boardings) as sum_stop_boardings_per_trip,
--sum(avg_trip_alightings) as sum_stop_alightings_per_trip
--sum(total_observations) as sum_observations

FROM dp.stop_activity_detail
--change this to the service change number of your choice. 

WHERE service_change_num = 223
--type the route numbers you are interested in between the parenthesis. 
--if you want all boardings at a stop, comment this line out by adding '--' in front of it
AND service_rte_num IN ( 672)
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
GROUP BY service_change_num,
stop_id,
--comment out service_rte_num to see a summary of stop data without route breakdown 
service_rte_num, 
--comment out express_local_cd to see a summary of all stop data without route breakdown 
express_local_cd,
trip_id, 
inbd_outbd_cd,
host_street_nm, 
cross_street_nm, 
avg_arrival_mnts_after_midnt,
jurisdiction_cd,
stop_sequence_num, 
avg_arrival_clock_time, 
--comment out day_part_cd to see a summary of all stop data without time breakdown 
day_part_cd