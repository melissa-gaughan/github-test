
-- avg boardings per trip by block
with abpt as
(
select a.service_change_num, a.sched_day_type_coded_num, b.block_rte_num, b.block_run_num,
cast(sum(avg_psngr_boardings) as float)/cast(count(distinct a.trip_id) as float) avg_boardings_per_trip
from dp.trip_summary a
left join dp.all_trips b
on a.service_change_num = b.service_change_num
and a.key_block_num = b.key_block_num
and a.trip_id = b.trip_id
where a.service_change_num=223 and b.trip_kind_cd = 'S' and b.minor_change_num=0 and working_load_status in ('FINAL')
group by a.service_change_num, b.block_rte_num, b.block_run_num, a.sched_day_type_coded_num
--order by 1,2,3
),

-- disrupted trips
dt as (
select b.service_change_num, a.full_date, a.block_rte_num, a.block_run_num, sum(a.disrupted_trip_est_cnt) disrupted_trips
from dp.disrupted_bus_trips a
left join reference.service_change_sched b
on a.full_date between b.start_date and dateadd(dd, -1, b.end_date)
where b.service_change_num = 223
group by b.service_change_num, a.full_date, a.block_rte_num, a.block_run_num
)

select a.*, b.avg_boardings_per_trip, a.disrupted_trips * b.avg_boardings_per_trip affected_customers
from dt a
left join abpt b
on a.service_change_num=b.service_change_num
and a.block_rte_num = b.block_rte_num
and a.block_run_num = b.block_run_num

