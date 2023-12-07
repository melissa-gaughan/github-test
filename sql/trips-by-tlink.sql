/****** Script for SelectTopNRows command from SSMS  ******/
SELECT 
		[TRANS_LINK_ID]
	  , [INBD_OUTBD_CD]
      , sum([DAILY_TRIP_CNT]) as trip_total
     
  FROM [DP].[SCHED_DAILY_BUS_TRIP_CNT_BY_TLINK]
 WHERE TRANS_LINK_ID IN (SELECT TRANS_LINK_ID
						 FROM [DP].[SCHED_DAILY_BUS_TRIP_CNT_BY_TLINK]
						 WHERE  SERVICE_RTE_NUM = 40) --update this to change route filtering. Can select multiple.
		AND CHANGE_NUM  = 153 --update to reflect the change num of the biweekly you are interested in. Should not be used to select more than 1
		AND HOUR_OF_DAY = 17
		AND SCHED_DAY_TYPE_CODED_NUM = 0
		GROUP BY [TRANS_LINK_ID]
	  , [INBD_OUTBD_CD]
  