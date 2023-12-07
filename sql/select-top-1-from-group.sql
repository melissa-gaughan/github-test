select * from (
SELECT service_rte_num, 
HRS_CHANGE_CATG, 
row_number() over (partition by service_rte_num order by CHANGE_IN_ANNL_SERVICE_HRS desc) as reason_rank
FROM DP.SERVICE_HOUR_CHANGE_ACCOUNTING
WHERE CURRENT_SERVICE_CHANGE_NUM = 233 and HRS_CHANGE_CATG <> 'Scheduling Changes') ranks
WHERE reason_rank = 1