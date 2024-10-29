-- Задача : вывести id и sum_s из таблицы с самой поздней датой обновления информации.
-- Решить задачу с помощью оконных функций

-- 1) LAST 
select distinct id, sum(sum_s) keep (dense_rank last order by date_s) over(partition by id) lasts
from bl_gaia.windows;
-- 2) FIRST
select distinct id, sum(sum_s) keep (dense_rank first order by date_s desc) over(partition by id) firsts
from bl_gaia.windows;
-- 3) ROW_NUMBER
select id, sum_s
from (select id, sum_s, row_number() over(partition by id order by date_s DESC) rn
      from bl_gaia.windows)
where rn = 1;
-- 4) RANK
select id, sum_s
from (select id, sum_s, rank() over(partition by id order by date_s DESC) r
from bl_gaia.windows)
where r = 1;
-- 5) DENSE_RANK
select id, sum_s
from (select id, sum_s, dense_rank() over(partition by id order by date_s DESC) dr
from bl_gaia.windows)
where dr = 1;
-- 6) MAX
select id, sum_s
from bl_gaia.windows ww
where (id, date_s) = (select distinct id, max(date_s) over(partition by id) maxs
from bl_gaia.windows
where id = ww.id);
-- 7) PERCENT_RANK
select id, sum_s
from (select id, sum_s, PERCENT_RANK() OVER(partition by id ORDER BY id asc, date_s desc) PR
from bl_gaia.windows)
where pr = 0;
-- 8) CUME_DIST()
select id, sum_s
from (select id, sum_s, CUME_DIST() OVER(partition by id ORDER BY id, date_s) cd
from bl_gaia.windows)
where cd = 1;
-- 9) COUNT
select id, sum_s
from (select id, sum_s, count(date_s) OVER(partition by id ORDER BY date_s desc) c
from bl_gaia.windows)
where c = 1;
-- 10) AVG
select distinct id, sum_s
from (select id, date_s, sum_s, avg(rownum) 
                                     OVER(partition by id ORDER BY date_s desc
                                     rows between 1 preceding and current row) c, rownum r
from bl_gaia.windows) ww
where c = r;
-- еще способ
select distinct id, sum_s
from (select id, date_s, sum_s, avg( nvl(sum_s, -1)) 
                                     OVER(partition by id ORDER BY date_s desc
                                     rows BETWEEN (select distinct count(*) over(partition by sum_s) 
                                                   from bl_gaia.windows 
                                                   where id = w.id and nvl(sum_s, -1) = nvl(w.sum_s, -1) ) PRECEDING AND CURRENT ROW) c
from bl_gaia.windows w) ww
where c = nvl(sum_s, -1);
-- еще способ
select id, date_s, case 
           when sum_s = 0
           then null 
           else sum_s 
           end sum_s
from (select distinct id, date_s, nvl(sum_s, 0) sum_s, avg(nvl(sum_s, 0)) OVER(partition by id ORDER BY date_s desc) c
from bl_gaia.windows) ww
where c = sum_s and (date_s, 1) = any(select date_s, count(*) over(partition by id, sum_s order by date_s desc) c 
                 from bl_gaia.windows where id = ww.id) ;
-- 11) MIN
select distinct id, sum_s
from bl_gaia.windows ww
where (id, -extract(day from date_s)) = (select distinct id, min(- extract(day from date_s)) over(partition by id) mins
from bl_gaia.windows
where id = ww.id);
-- 12) FIRST_VALUE
select distinct id, FIRST_VALUE(sum_s) OVER(PARTITION BY id ORDER BY date_s desc) fv
from bl_gaia.windows;
-- 13) LAST_VALUE
select distinct id, LAST_VALUE(sum_s) OVER(PARTITION BY id order by id desc) lv
from bl_gaia.windows;
-- 14) SUM
select distinct id, case when sum_s = -1 then null else sum_s end sum_s
from (select id, date_s, nvl(sum_s, -1) sum_s, sum(nvl(sum_s, -1)) OVER(partition by id ORDER BY date_s desc) c
from bl_gaia.windows)
where c = sum_s or sum_s is null;
-- 15) NTILE
select distinct id, sum_s
from (select id, sum_s, ntile(999999) OVER(partition by id ORDER BY date_s desc) n
from bl_gaia.windows)
where n = 1;
-- 16) NTH_VALUE
select distinct id, nth_value(sum_s, 1) OVER(partition by id ORDER BY date_s desc) n
from bl_gaia.windows;
-- 17) PERCENTILE_CONT
select id, sum_s
from bl_gaia.windows
where (id, date_s) = any(select id, PERCENTILE_CONT(1) within group (ORDER BY date_s ) over(partition by id) n
from bl_gaia.windows);
-- 18) PERCENTILE_DISC
select id, sum_s
from bl_gaia.windows
where (id, date_s) = any(select id, PERCENTILE_DISC(1) within group (ORDER BY date_s ) over(partition by id) n
from bl_gaia.windows);
-- 19) STDDEV
select distinct id, sum_s
from (select id, sum_s, stddev(nvl(sum_s, 1)) OVER(partition by id order by date_s desc) std
from bl_gaia.windows)
where std = 0;
-- 20) COVAR_POP
select distinct id, sum_s 
from (select id, sum_s, covar_pop(nvl(sum_s, 0), nvl(sum_s, 0)) OVER(partition by id order by date_s desc) cp
from bl_gaia.windows)
where cp = 0;
-- 21) COVAR_SAMP
select distinct id, sum_s
from (select id, sum_s, covar_samp(nvl(sum_s, 0), nvl(sum_s, 0)) OVER(partition by id order by date_s desc) csp
from bl_gaia.windows)
where csp is null;
-- 22) CORR
select distinct id, sum_s
from (select id, date_s, sum_s, corr(nvl(sum_s, 0), nvl(sum_s, 0)) OVER(partition by id ORDER BY date_s desc ROWS BETWEEN unbounded PRECEDING AND current row) c
from bl_gaia.windows) ww
where c is null and date_s >= all (select date_s from bl_gaia.windows where id = ww.id);
-- 23) STDDEV_POP
select distinct id, sum_s
from (select id, sum_s, stddev_pop(nvl(sum_s, 1)) OVER(partition by id order by date_s desc) std
from bl_gaia.windows)
where std = 0;
-- 24) STDDEV_SAMP
select distinct id, sum_s
from (select id, sum_s, stddev_samp(nvl(sum_s, 1)) OVER(partition by id order by date_s desc) std
from bl_gaia.windows)
where std is null;
-- 25) VARIANCE
select distinct id, sum_s
from (select id, date_s, sum_s, variance(nvl(sum_s, 1)) OVER(partition by id ORDER BY date_s desc) v
from bl_gaia.windows)
where v = 0;
-- 26) VAR_POP
select distinct id, sum_s
from (select id, date_s, sum_s, var_pop(nvl(sum_s, 1)) OVER(partition by id ORDER BY date_s desc) vp
from bl_gaia.windows)
where vp = 0;
-- 27) VAR_SAMP
select distinct id, sum_s
from (select id, date_s, sum_s, var_samp(nvl(sum_s, 1)) OVER(partition by id ORDER BY date_s desc) vs
from bl_gaia.windows)
where vs is null;
-- 28) REGR_
select id, sum_s
from (select id, sum_s, regr_r2(rownum, rownum) OVER(partition by id order by date_s desc) rg
from bl_gaia.windows)
where rg is null;
-- 29) LAG
select distinct id, sum_s 
from bl_gaia.windows w
where (id, nvl(sum_s, 0)) = any(select id, 
       lag(nvl(sum_s, 0), (select distinct count(*) over(partition by id) from bl_gaia.windows where id = ww.id) - 1) 
                  over(partition by id order by date_s desc)ls
from bl_gaia.windows ww
where id = w.id);
-- 30) LEAD
select distinct id, sum_s 
from bl_gaia.windows w
where (id, nvl(sum_s, 0)) = any(select id, 
       lead(nvl(sum_s, 0), (select distinct count(*) over(partition by id) from bl_gaia.windows where id = ww.id) - 1) 
                  over(partition by id order by date_s)ls
from bl_gaia.windows ww
where id = w.id);
-- 31) LISTAG
select distinct id, 
case when INSTR(lst, ',') = 0 then sum_s 
     when SUBSTR(lst, 1, INSTR(lst, ',') - 1) = nvl(sum_s, 0) then sum_s 
     else cast(SUBSTR(lst, 1, INSTR(lst, ',') - 1) as integer)
end rs 
from (select id, sum_s, date_s, listagg(nvl(sum_s, 0), ', ') within group(order by date_s desc) 
                                                             over(partition by id) lst
from bl_gaia.windows);
-- 32) RATIO_TO_REPORT
select distinct id, sum_s
from (select id, sum_s, date_s, RATIO_TO_REPORT(extract(day from date_s)) OVER(partition by id) rtrd,
                                RATIO_TO_REPORT(extract(month from date_s)) OVER(partition by id) rtrm,
                                RATIO_TO_REPORT(extract(year from date_s)) OVER(partition by id) rtry
from bl_gaia.windows) xx
where rtrd >= all(select RATIO_TO_REPORT(extract(day from date_s)) OVER(partition by id)
from bl_gaia.windows
where id = xx.id) and 
      rtrm >= all(select RATIO_TO_REPORT(extract(month from date_s)) OVER(partition by id)
from bl_gaia.windows
where id = xx.id) and
      rtry >= all(select RATIO_TO_REPORT(extract(year from date_s)) OVER(partition by id)
from bl_gaia.windows
where id = xx.id);


-- Способ без оконных функций
select distinct id, sum_s
from bl_gaia.windows
where date_s >= all (select date_s from bl_gaia.windows where id = ww.id);


select * from bl_gaia.windows;
