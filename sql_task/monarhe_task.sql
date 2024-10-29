-- Решить задачу Энштейн с определенными условиями с помощью SQL
-- Реализован способом перебора

/*
drop table monarhe_objects;
drop table m_o�
drop table condition;

create table monarhe_objects (
id int,
oname varchar2(150),
type_o varchar2(100),
period int
);

create table m_o (
id int,
oname varchar2(150),
type_o varchar2(100)
);

create table condition (
id int,
who int,
whom int,
wher varchar2(50),
period_c int
);

drop table types;

create table types as(
select row_number() over(order by type_o) id, type_o
from monarhe_objects
group by type_o
);

--INSERTS
insert into m_o values
(1, '��', 'castle');
insert into m_o values
(2, '���', 'castle');
insert into m_o values
(3, '���', 'castle');
insert into m_o values
(4, '��', 'castle');
insert into m_o values
(5, '��', 'castle');
insert into m_o values
(11, '�', 'monument');
insert into m_o values
(12, '�', 'monument');
insert into m_o values
(13, '�', 'monument');
insert into m_o values
(14, '�', 'monument');
insert into m_o values
(15, '�', 'monument');
insert into m_o values
(21, '���', 'revolution');
insert into m_o values
(22, '��', 'revolution');
insert into m_o values
(23, '��', 'revolution');
insert into m_o values
(24, '���', 'revolution');
insert into m_o values
(25, '���', 'revolution');
insert into m_o values
(31, '���', 'reform');
insert into m_o values
(32, '���', 'reform');
insert into m_o values
(33, '���', 'reform');
insert into m_o values
(34, '��', 'reform');
insert into m_o values
(35, '���', 'reform');
insert into m_o values
(41, '�I', 'monarhe');
insert into m_o values
(42, '��', 'monarhe');
insert into m_o values
(43, '��', 'monarhe');
insert into m_o values
(44, '�I', 'monarhe');
insert into m_o values
(45, '��', 'monarhe');

insert into monarhe_objects values
(1, '������', 'castle', 0);
insert into monarhe_objects values
(2, '�������', 'castle', 0);
insert into monarhe_objects values
(3, '�����������', 'castle', 0);
insert into monarhe_objects values
(4, '�������', 'castle', 0);
insert into monarhe_objects values
(5, '��������', 'castle', 0);
insert into monarhe_objects values
(11, '�', 'monument', 0);
insert into monarhe_objects values
(12, '�', 'monument', 0);
insert into monarhe_objects values
(13, '�', 'monument', 0);
insert into monarhe_objects values
(14, '�', 'monument', 0);
insert into monarhe_objects values
(15, '�', 'monument', 0);
insert into monarhe_objects values
(21, '��������', 'revolution', 0);
insert into monarhe_objects values
(22, '��������', 'revolution', 0);
insert into monarhe_objects values
(23, '������', 'revolution', 0);
insert into monarhe_objects values
(24, '�����������', 'revolution', 0);
insert into monarhe_objects values
(25, '���������-��������', 'revolution', 0);
insert into monarhe_objects values
(31, '������� ��������', 'reform', 0);
insert into monarhe_objects values
(32, '��������� ������', 'reform', 0);
insert into monarhe_objects values
(33, '������ �����', 'reform', 0);
insert into monarhe_objects values
(34, '����������', 'reform', 0);
insert into monarhe_objects values
(35, '����������� �����', 'reform', 0);
insert into monarhe_objects values
(41, '������� I', 'monarhe', 0);
insert into monarhe_objects values
(42, '������� ����������', 'monarhe', 0);
insert into monarhe_objects values
(43, '��������� �������', 'monarhe', 0);
insert into monarhe_objects values
(44, '���� I', 'monarhe', 0);
insert into monarhe_objects values
(45, '������ ���������', 'monarhe', 0);
*/

select * from monarhe_objects;

/*
insert into condition values
(1, 12, 21, 's', null);
insert into condition values
(2, 13, 22, 'n', null);
insert into condition values
(3, 15, 31, 'r', null);
insert into condition values
(4, 15, 14, 'n', null);
insert into condition values
(5, 12, 41, 'r', null);
insert into condition values
(6, 41, 42, 'n', null);
insert into condition values
(7, 15, 41, 'n', null);
insert into condition values
(8, 23, 43, 'n', null);
insert into condition values
(9, 32, 14, 's', null);
insert into condition values
(10, 1, 33, 's', null);
insert into condition values
(11, 2, 44, 'n', null);
insert into condition values
(12, 24, 43, 'r', null);
insert into condition values
(13, 34, 33, 'n', null);
insert into condition values
(14, 2, 21, 's', null);
insert into condition values
(15, 11, 31, 'n', null);
insert into condition values
(16, 25, 3, 'n', null);
insert into condition values
(17, 4, 13, 's', null);
*/

select * from monarhe_objects;
select * from condition;

/*
create table t1 as (select c.id id, oname who, null whom, wher, period
from condition c join monarhe_objects mo on who = mo.id
union all
select c.id id, null who, oname whom, wher, period
from condition c join monarhe_objects mo on whom = mo.id)

create table cond_name as (
select distinct id, coalesce(who, (select who from t1 where id = t.id and who is not null)) who,
                coalesce(whom, (select whom from t1 where id = t.id and whom is not null)) whom,
                wher, period
from t1 t
);

alter table monarhe_objects drop column period;
*/


select * from condition;
select * from cond_name order by id;
select * from monarhe_objects;

grant all privileges on types to alexeymn;
grant all privileges on condition to alexeymn;
grant all privileges on monarhe_objects to alexeymn;
/*
drop table decision_m

create table decision_m as (
select m1.oname castle, m2.oname monument, m3.oname revolution, 
       m4.oname reform, m5.oname monarhe, period 
from monarhe_objects m1, monarhe_objects m2, monarhe_objects m3, monarhe_objects m4, monarhe_objects m5,
     (select level period from dual connect by level < 6)
where m1.type_o = 'castle' and m2.type_o = 'monument' 
  and m3.type_o = 'revolution' and m4.type_o = 'reform' and m5.type_o = 'monarhe');
*/

select * from decision_m;
select * from cond_name order by id;
select * from types;
select * from monarhe_objects;

select *
from
(select ltrim(SYS_CONNECT_BY_PATH(oname, ', '), ', ') castle
from monarhe_objects
where CONNECT_BY_ISLEAF = 1 and type_o = 1
connect by NOCYCLE prior oname <> oname and type_o = prior type_o and level < 6),
(select ltrim(SYS_CONNECT_BY_PATH(oname, ', '), ', ') monarhe
from monarhe_objects
where CONNECT_BY_ISLEAF = 1 and type_o = 2
connect by NOCYCLE prior oname <> oname and type_o = prior type_o and level < 6),
(select ltrim(SYS_CONNECT_BY_PATH(oname, ', '), ', ') monument
from monarhe_objects
where CONNECT_BY_ISLEAF = 1 and type_o = 3
connect by NOCYCLE prior oname <> oname and type_o = prior type_o and level < 6),
(select ltrim(SYS_CONNECT_BY_PATH(oname, ', '), ', ') reform
from monarhe_objects
where CONNECT_BY_ISLEAF = 1 and type_o = 4
connect by NOCYCLE prior oname <> oname and type_o = prior type_o and level < 6),
(select ltrim(SYS_CONNECT_BY_PATH(oname, ', '), ', ') revolution
from monarhe_objects
where CONNECT_BY_ISLEAF = 1 and type_o = 5
connect by NOCYCLE prior oname <> oname and type_o = prior type_o and level < 6)

--update monarhe_objects mo set type_o = (select to_char(id) from types where type_o = mo.type_o);
--grant all privileges on cond_name to alexeymn;
--update monarhe_objects set oname = '�������' where oname = '��������';

select d2.*
from decision_m d1, decision_m d2
where (d1.castle = d2.castle and d1.monument = d2.monument and d1.revolution = d2.revolution 
  and d1.reform = d2.reform and d1.monarhe = d2.monarhe and d1.period = d2.period) or (d1.castle <> d2.castle 
  and d1.monument <> d2.monument and d1.revolution <> d2.revolution and d1.reform <> d2.reform 
  and d1.monarhe <> d2.monarhe and d1.period <> d2.period);


-- Reshenie 
select nt.* 
from (
select dm.*, who, whom, wher, cm.period p, 
       case when wher is null and cm.period = dm.period then 1
            when wher = 'r' and (((who = castle or who = monument or who = revolution or who = reform or who = monarhe) and
                                dm.period > 1) or 
                                ((whom = castle or whom = monument or whom = revolution or whom = reform or whom = monarhe) 
                                and dm.period < 5)) then 1
            when wher = 'l' and (((who = castle or who = monument or who = revolution or who = reform or who = monarhe) and
                                dm.period < 5) or 
                                ((whom = castle or whom = monument or whom = revolution or whom = reform or whom = monarhe) 
                                and dm.period > 1)) then 1
            when wher = 's' and (who = castle or who = monument or who = revolution or who = reform or who = monarhe) and
                        (whom = castle or whom = monument or whom = revolution or whom = reform or whom = monarhe) then 1
       else 0 end ext
from decision_m dm, cond_name cm
where (who = castle or who = monument or who = revolution or who = reform or who = monarhe
   or whom = castle or whom = monument or whom = revolution or whom = reform or whom = monarhe)
) nt where ext = 1;

select distinct a, oname, type_o
from(
select who a from cond_name
union all
select whom a from cond_name ) right join monarhe_objects on a = oname
order by type_o;
