/*
drop table emp1;
drop table emp2;

create table emp1
(
emp_id int,
nname varchar2(50),
sal int,
job_id int,
dep_id int
);

create table emp2
(
emp_id int,
nname varchar(50),
sal int,
job_id int,
dep_id int
);

-- emp1
insert into emp1 values (1, 'UPD <=35000 -> DEL', 40000, 5, 5);
insert into emp2 values (2, 'emp y dep no -> NotUPD -> NotDEL', 35000, 5, 2);
insert into emp1 values (2, 'UPD >35000  -> NotDEL', 20000, 4, 4);
insert into emp1 values (3, 'NotUPD -> NotDEL', 25000, 2, null);
insert into emp1 values (4, 'UPD <=35000 -> DEL', null, 3, 5);
insert into emp1 values (5, 'UPD null -> NotDEL', 60000, 2, 1);
insert into emp1 values (null, 'NotUPD -> NotDEL', 38000, 3, 3);
insert into emp1 values (null, 'NotUPD -> NotDEL', 27000, 3, null);
insert into emp1 values (6, 'NotUPD -> NotDEL', 27000, 1, 3);
insert into emp1 values (6, 'NotUPD -> NotDEL', 27000, 1, 3);
insert into emp1 values (9, 'UPD <=35000 -> DEL', 36000, 1, 3);
insert into emp1 values (9, 'UPD <=35000 -> DEL', 36000, 1, 3);
insert into emp1 values (10, 'UPD >35000 -> NotDEL', 25000, 1, 1);
insert into emp1 values (10, 'UPD >35000 -> NotDEL', 25000, 1, 1);
insert into emp1 values (11, 'UPD same <=35000 -> DEL', 25000, 1, 2);
insert into emp1 values (11, 'UPD same >35000 -> NotDEL', 50000, 1, 4);
insert into emp1 values (12, 'NotUPD -> NotDEL', 24000, 2, 4);
insert into emp1 values (12, 'NotUPD -> NotDEL', 24000, 3, 4);

-- emp2
insert into emp2 values (1, 'UPD <=35000 -> DEL', 35000, 5, 5);
insert into emp2 values (1, 'emp y dep no -> NotUPD -> NotDEL', 35000, 5, 2);
insert into emp2 values (2, 'UPD >35000  -> NotDEL', 40000, 4, 4);
insert into emp2 values (3, 'NotUPD -> NotDEL', 25000, 2, null);
insert into emp2 values (4, 'UPD <=35000 -> DEL', 15000, 3, 5);
insert into emp2 values (5, 'UPD null -> NotDEL', null, 2, 1);
insert into emp2 values (null, 'NotUPD -> NotDEL', 32000, 3, 3);
insert into emp2 values (7, 'NewVal -> NotDEL', 27000, 2, 1);
insert into emp2 values (7, 'NewVal -> NotDEL', 27000, 2, 1);
insert into emp2 values (7, 'NewVal -> NotDEL', 27000, 2, 1);
insert into emp2 values (8, 'NewVal -> NotDEL', 47000, 4, 6);
insert into emp2 values (8, 'NewVal -> NotDEL', 47000, 4, 6);
insert into emp2 values (8, 'NewVal -> NotDEL', 47000, 4, 6);
insert into emp2 values (9, 'UPD <=35000 -> DEL', 32000, 1, 3);
insert into emp2 values (10, 'UPD >35000 -> NotDEL', 45000, 1, 1);
insert into emp2 values (11, 'UPD same <=35000 -> DEL', 25000, 1, 2);
insert into emp2 values (11, 'UPD same >35000 -> NotDEL', 50000, 1, 4);
insert into emp2 values (13, 'NewVal -> NotDEL', 33000, 1, 4);
insert into emp2 values (13, 'NewVal -> NotDEL', 40000, 1, 4);

-- emp3
drop table emp3;

CREATE TABLE emp3 as
(
select * from emp2
);

insert into emp3 values( 1, 'REPEAT UPD -> ERROR', 40000, 5, 5);
*/

select * from emp1 order by emp_id, dep_id;
select * from emp2;
select * from emp3;

-- Реализация через MERGE
MERGE INTO emp1
USING emp2
ON (emp1.emp_id = emp2.emp_id AND emp1.dep_id = emp2.dep_id)

WHEN MATCHED THEN
  UPDATE
     SET emp1.nname   = emp2.nname,
         emp1.sal    = emp2.sal,
         emp1.job_id = emp2.job_id DELETE
   WHERE emp1.sal <= 35000
  

WHEN NOT MATCHED THEN
  INSERT
    (emp1.emp_id, emp1.nname, emp1.sal, emp1.job_id, emp1.dep_id)
  VALUES
    (emp2.emp_id, emp2.nname, emp2.sal, emp2.job_id, emp2.dep_id);

-- реализация через Insert, Update, Delete
select * from emp1 order by emp_id, dep_id;
update emp1 e
   set (nname, sal, job_id)  =
       (select nname, sal, job_id
          from emp2
         where emp_id = e.emp_id
           and dep_id = e.dep_id)
 where exists (select 1 from emp2 where emp_id = e.emp_id and dep_id = e.dep_id);
select * from emp1 order by emp_id, dep_id;

insert into emp1(emp_id, nname, sal, job_id, dep_id)
  select emp_id, nname, sal, job_id, dep_id
    from emp2 e
   where ((emp_id, dep_id) = (select distinct emp_id, dep_id from emp1 where emp_id = e.emp_id and dep_id = e.dep_id) and sal <= 35000) 
   or not exists (select 1 from emp1 where emp_id = e.emp_id and dep_id = e.dep_id);
   
select * from emp1 order by emp_id, dep_id;

delete emp1 e
 where 1 < (select count(*) from emp1 where emp_id = e.emp_id and dep_id = e.dep_id and sal <= 35000 group by emp_id, dep_id ) and 
       1 >= (select count(*) from emp2 where emp_id = e.emp_id and dep_id = e.dep_id and sal <= 35000 group by emp_id, dep_id );
select * from emp1 order by emp_id, dep_id;

-- реализация через Insert, Update, Delete c повторным обновлением
select * from emp1 order by emp_id, dep_id;
update emp1 e
   set (nname, sal, job_id)  =
       (select nname, sal, job_id
          from emp3
         where emp_id = e.emp_id
           and dep_id = e.dep_id)
 where exists (select 1 from emp3 where emp_id = e.emp_id and dep_id = e.dep_id);
select * from emp1 order by emp_id, dep_id;

insert into emp1(emp_id, nname, sal, job_id, dep_id)
  select emp_id, nname, sal, job_id, dep_id
    from emp3 e
   where ((emp_id, dep_id) = (select distinct emp_id, dep_id from emp1 where emp_id = e.emp_id and dep_id = e.dep_id) and sal <= 35000) 
   or not exists (select 1 from emp1 where emp_id = e.emp_id and dep_id = e.dep_id);
select * from emp1 order by emp_id, dep_id;

delete emp1 e
 where 1 < (select count(*) from emp1 where emp_id = e.emp_id and dep_id = e.dep_id group by emp_id, dep_id ) and 
       1 >= (select count(*) from emp3 where emp_id = e.emp_id and dep_id = e.dep_id group by emp_id, dep_id );
select * from emp1 order by emp_id, dep_id;