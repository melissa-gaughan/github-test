Select * from(
SELECT CHANGE_NUM, SERVICE_CHANGE_NUM, 
row_number() over 
(partition by SERVICE_CHANGE_NUM order by CHANGE_NUM desc) as reason_rank
FROM DP.ALL_TRIPS
) ranks
WHERE reason_rank = 1
order by service_change_num