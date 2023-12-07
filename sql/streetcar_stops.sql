/****** Script for SelectTopNRows command from SSMS  ******/
SELECT DISTINCT dp.transit_stop.stop_id
STOP_ID, 
ON_STREET_NM, 
CROSS_STREET_NM, 
SERVICE_RTE_NUM, 
INBD_OUTBD_CD, 
GPS_LATITUDE, 
GPS_LONGITUDE,
SERVICE_CHANGE_NUM
  FROM [DP].[STOP_SEQUENCE]
  LEFT JOIN DP.TRANSIT_STOP  on dp.stop_sequence.stop_id = dp.transit_stop.stop_id

  WHERE SERVICE_RTE_NUM IN (96, 98)