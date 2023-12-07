/****** Script to derive average daily ramp deployuments by route/stop over given time range  ******/
WITH T01 as (
SELECT
OPERATION_DATE
      ,[STOP_ID]
	,  SERVICE_RTE_NUM
      ,SUM([RAMP_LIFT_DEPLOY_CNT]) as SUM_RAMP_LIFT_DEPLOY_CNT --sum to get daily total
  FROM [DP].[VEH_TRIP_STOP_PASSENGER]
  WHERE DOOR_OPEN_SEC > 10 AND DOOR_OPEN_FLAG = 0 --door is open for at least ten seconds and the door open flag is on 
-- AND RAMP_LIFT_DEPLOY_CNT >0
  AND IS_APC_FLAG = 1 -- filter for bus has APC counter
  AND PCNT_PATT_QUALITY >= 90 -- filter for making sure bus is following route pattern
  AND TRIP_ROLE = 'S' -- Bus is in service
  AND STOP_ROLE IN ('S', 'ST', 'STE') -- stop is an inservice stop
  AND OPERATION_DATE >= CAST('2022-03-01' AS DATE ) --earliest date of interest
  AND OPERATION_DATE <= CAST('2022-03-31' AS DATE ) -- last date of interest
 -- AND SERVICE_RTE_NUM IN (1, 2, 3, 4, 5) -- type in a comma delimited list of routes  you are interested in. Comment out with -- if you want all routes
  --AND STOP_ID IN (4245, 12760) -- type in a comma delimited list of stops you are interested in. Comment out with -- if you want all stops
  GROUP BY STOP_ID , 
  SERVICE_RTE_NUM,
  OPERATION_DATE) 

  SELECT
    [STOP_ID]
	,  SERVICE_RTE_NUM
  , SERVICE_DAY_TYPE_CODE
      , AVG([SUM_RAMP_LIFT_DEPLOY_CNT]) as AVG_DAILY_RAMP_LIFT_DEPLOY_CNT--daily average, grouped by day type across specified time range. 
	  FROM T01
LEFT JOIN EDW.DIM_DATE on T01.OPERATION_DATE = EDW.DIM_DATE.FULL_DATE
GROUP BY [STOP_ID]
	, SERVICE_RTE_NUM
	, SERVICE_DAY_TYPE_CODE
	ORDER BY AVG_DAILY_RAMP_LIFT_DEPLOY_CNT DESC,  stop_id, service_rte_num, service_day_type_code