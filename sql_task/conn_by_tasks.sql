select * from employee;

select lpad('_', 4*level, '_')|| first_name || ' ' || last_name as nm, SYS_CONNECT_BY_PATH(first_name || last_name, '/') as Path, level
from employee
start with pid is null
connect by prior id = pid order siblings by first_name, last_name;

select lpad('_', 4*level, '_')|| first_name || ' ' || last_name as nm, 
       SYS_CONNECT_BY_PATH(first_name || last_name, ' / ') as Path, level,
       CONNECT_BY_ISLEAF as IsLeaf, 
       PRIOR first_name as Parent, 
       CONNECT_BY_ROOT first_name as Root
from employee
start with pid is null
connect by prior id = pid;

select rownum, level
from dual
connect by level <= (select max(id) from employee);

-- grant all privilege on employee to bl_gaia;


select level, s, SYS_CONNECT_BY_PATH(s, ' / ') ps, SYS_CONNECT_BY_PATH(level, ' / ') pl
from (select level s from dual connect by level < 4) 
connect by level < s
order by s, level;

select level, s, count(*) cnt
from (select level s from dual connect by level < 4) 
connect by level < s
group by s, level
order by s, level;


-- Перевести число n в систему счисления base
select distinct n, base, ( select listagg( mod(floor(n/power(base, level-1)), base), '') 
                         within group (order by level DESC) 
                  from dual
                  connect by level <= ceil(log(base, n))) newnum
from nbase;

select 782, listagg( mod(floor(782/power(2, level-1)), 2), '') 
                                  within group (order by level DESC) 
from dual 
connect by level <= ceil(log(2, 782));

-- Для более, чем 9тиричная
select distinct n, base, ( select listagg( decode( mod(floor(n/power(base, level-1)), base), 
               10, 'A', 11, 'B', 12, 'C', 13, 'D', 14, 'E',
               15, 'F', 16, 'G', 17, 'H', 18, 'I', 19, 'J',
               20, 'K', 21, 'L', 22, 'M', 23, 'N', 24, 'O',
               25, 'P', 26, 'Q', 27, 'R', 28, 'S', 29, 'T', 
               30, 'U', 31, 'V', 32, 'W', 33, 'X', 34, 'Y', 
               35, 'Z', mod(floor(n/power(base, level-1)), base)), '') 
                         within group (order by level DESC) 
                  from dual
                  connect by level <= ceil(log(base, n))) newnum
from nbase
order by base;
--
select distinct n, base, 
       (select listagg( SUBSTR( '123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ', mod(floor(n/power(base, level-1)), base), 1 ), '') 
                         within group (order by level DESC) 
                  from dual
                  connect by level <= ceil(log(base, n))) newnum
from nbase
order by base;
--
select distinct n, base, 
       (select listagg( SUBSTR( '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ', mod(floor(n/power(base, level-1)) , base) + 1, 1 ), '') 
                         within group (order by level DESC) 
                  from dual
                  connect by level <= trunc(ceil(log(base, n))) + 1) newnum
from nbase
order by base;
--

-- Вывести работников лесенкой, в зависимости от подчинения, всех начальников работника через запятую и сумму зарплат подчиненных, не включая зарплату самого работникаselect level, lpad(' ', 4*level, ' ')|| first_name || ' ' || last_name as name, 
select level, lpad(' ', 4*level, ' ')|| first_name || ' ' || last_name as name, 
       LTRIM(SYS_CONNECT_BY_PATH(prior first_name || ' ' || prior last_name, ', '), ', , ') bosses,
       coalesce((select sum(salary) from conby start with id = e.id connect by prior id =  pid ), 0) - salary as salary1,
       salary
from employee e
start with pid is null
connect by prior id = pid order siblings by first_name, last_name;

-- Наполнить новую таблицу рандомными значениями для проверки работоспособности функции
create table conby (id integer primary key,
                    pid integer,
                    name varchar2(25),
                    salary float);
                    
insert into conby (id, pid, name, salary)
select level, round(dbms_random.value(level - 1, 2500)),
       dbms_random.string('a', 5) || ' ' || dbms_random.string('a', 7),
       round(dbms_random.value(100, 500), 2)
from dual
connect by level <= 5000;

update conby
set pid = null
where id = pid;
 
select * from conby;

truncate table conby;

-- сама функция
create table conby_prov as (select  lpad(' ', 5*level, ' ') || name as name, 
       LTRIM(SYS_CONNECT_BY_PATH(prior name, ', '), ', ') as bosses,
       coalesce((select sum(salary) from conby start with id = e.id connect by prior id =  pid ), 0) - salary as salary
from conby e
start with pid is null
connect by prior id = pid );

-- вывести числовые ряды до максимального
select (select listagg(level, ' ' ) within group (order by level) from dual connect by level <= t.lvl)
from (select level lvl
from (select 5 n from dual)
connect by level <= n ) t;

select tt.lvl
from (select level lvl
from (select 5 n from dual)
connect by level <= n ) t, (select level lvl
from (select 5 n from dual)
connect by level <= n ) tt
where tt.lvl <= t.lvl;
               
-- вывести два столбца 1й по возрастанию, второй по убыванию
select level, coalesce(prior lvl - 1, 5) invert_lvl
from (select level lvl
from (select 5 n from dual)
connect by level <= n ) t
start with lvl = 5 
connect by prior lvl = lvl + 1;

-- Вывести все вариации комбинаций
select distinct ps
from
(select level lvl, SYS_CONNECT_BY_PATH(numb, ' ') ps
from (select level numb
from dual
connect by level < 5)
connect by NOCYCLE prior numb <> numb)
where lvl = 4
order by ps;

select SYS_CONNECT_BY_PATH(numb, ' ') ps
from (select level numb
from dual
connect by level < 5)
where CONNECT_BY_ISLEAF = 1
connect by NOCYCLE prior numb <> numb