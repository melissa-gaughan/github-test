/****** Script for SelectTopNRows command from SSMS  ******/
SELECT  
    CASE 
		WHEN TRANS_LINK_ID = 164594 then '3rd North of Pike'
		WHEN TRANS_LINK_ID = 132937 then '3rd South of Pike'
		END AS TLINK_NAME
	,[SCHED_DAY_TYPE_CODED_NUM]
    ,[HOUR_OF_DAY]
    ,[TRIP_COMPASS_DIR_CD]
	, sum([DAILY_TRIP_CNT]) as TLINK_TRIPS
  FROM [DP].[SCHED_DAILY_BUS_TRIP_CNT_BY_TLINK]
 WHERE TRANS_LINK_ID IN (164594, 132937)
 AND HOUR_OF_DAY = 12
 AND SCHED_DAY_TYPE_CODED_NUM = 1
		AND CHANGE_NUM  = 153 --update to reflect the change num of the biweekly you are interested in. Should not be used to select more than 1
  GROUP BY  [TRANS_LINK_ID]
	,[SCHED_DAY_TYPE_CODED_NUM]
    ,[HOUR_OF_DAY]
    ,[TRIP_COMPASS_DIR_CD]



	 
 --(SELECT TRANS_LINK_ID
	--					 FROM [DP].[SCHED_DAILY_BUS_TRIP_CNT_BY_TLINK]
	--					 WHERE  SERVICE_RTE_NUM = 40) --update this to change route filtering. Can select multiple.
