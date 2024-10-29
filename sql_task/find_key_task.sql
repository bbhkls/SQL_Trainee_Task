-- Задача:
/*
 Необходимо найти все таблицы с гипотетической связью и столбцы, которые образуют эту гипотетическую связь
 */

-- Создание таблиц для примера, где точно есть связь
create table find_key1 (id integer, name varchar, phone varchar, primary key(id, name));
create table find_key2 (pid integer, nname varchar, age integer, primary key(pid));
create table find_key3 (id integer, age integer, primary key(id));

-- Drop
drop table find_key1;
drop table find_key2;
drop table find_key3;

-- Заполнение таблиц
-- find_key1
insert into find_key1
select 1, 'Katya', 'phone1'
union 
select 2, 'Katya', 'phone2'
union 
select 1, 'Mary', 'phone1'
union 
select 3, 'Katya', 'phone3'
union 
select 1, 'Kolya', 'phone1'
union 
select 1, 'Kollin', 'phone1'
union 
select 2, 'Kollya', 'phone2';

-- find_key2
insert into find_key2
select 1, 'Katya', 20
union 
select 2, 'Mary', 12
union 
select 3, 'Kolya', 39
union 
select 4, 'Tanya', 19
union 
select 5, 'Jack', 56;

-- find_key3
insert into find_key3
select 1, 20
union 
select 2, 12
union 
select 5, 56
union 
select 6, 14;

-- SELECT
select * from find_key1;
select * from find_key2;
select * from find_key3;

-- DELETE
delete from find_key1;
delete from find_key2;
delete from find_key3;

-- TASK
-- quote_ident() используется для безопасного экранирования имен таблиц и столбцов, чтобы избежать проблем с SQL-инъекциями и неправильным синтаксисом.
-- ordinal_position - позиция столбца в таблице

-- Таблица запросов для просмотра данных в каждом столбцe, в каждой таблице
/*
with querry as (
select 'select ' || quote_ident(column_name) || ' from ' || quote_ident(table_name) as sql_query, 
	   table_name, column_name, data_type
from (
	  select infs.table_name, infs.column_name, infs.data_type, row_number() over(order by infs.table_name, infs.ordinal_position) rn
		from information_schema.columns infs 
		join pg_tables pt on infs.table_name = pt.tablename
	   where pt.tableowner = 'serps'
    )
)
*/

-- Поиск запросов для использования в поиске гипотетической связи таблиц. 
-- Таблицы должны быть разными, а тип данных одинаковым. 

-- CREATE
create table hypothesis as (

	-- Таблица запросов для просмотра данных в каждом столбцe, в каждой таблице
	with querry as (
	select 'select ' || quote_ident(column_name) || ' from ' || quote_ident(table_name) as sql_query, 
		   table_name, column_name, data_type
	from (
		  select infs.table_name, infs.column_name, infs.data_type, row_number() over(order by infs.table_name, infs.ordinal_position) rn
			from information_schema.columns infs 
			join pg_tables pt on infs.table_name = pt.tablename
		   where pt.tableowner = 'serps'
	    )
	)
	
	select q1.sql_query querry_from_first, q1.table_name table_from_first, q1.column_name column_from_first, 
		   q2.sql_query querry_from_second, q2.table_name table_from_second, q2.column_name column_from_second,
		   null is_connection
	from querry q1 join querry q2 on q1.table_name <> q2.table_name and q1.data_type = q2.data_type
); 

-- DROP
drop table hypothesis;

-- DELETE
delete from hypothesis;

-- SELECT
select * from hypothesis;

-- PL/SQL PostgreSQL для поиска гипотетической связи
DO $$
declare
	is_conn text; -- true / false гипотезы о связи
	-- Переменные для хранения запросов
	q_f text; 
	q_s text;
	querry cursor for 
	select querry_from_first, querry_from_second from hypothesis;
	ex_quer varchar;
begin
	-- Очищаем и заполняем таблицу с информацией о всех таблицах пользователя на случай, 
	-- если были созданыб изменены или удалены какие-то таблицы
	delete from hypothesis;

	-- Таблица запросов для просмотра данных в каждом столбцe, в каждой таблице
	with querry as (
	select 'select ' || quote_ident(column_name) || ' from ' || quote_ident(table_name) as sql_query, 
		   table_name, column_name, data_type
	from (
		  select infs.table_name, infs.column_name, infs.data_type, row_number() over(order by infs.table_name, infs.ordinal_position) rn
			from information_schema.columns infs 
			join pg_tables pt on infs.table_name = pt.tablename
		   where pt.tableowner = 'serps'
	    )
	) 
	
	insert into hypothesis (
	
	select q1.sql_query querry_from_first, q1.table_name table_from_first, q1.column_name column_from_first, 
		   q2.sql_query querry_from_second, q2.table_name table_from_second, q2.column_name column_from_second,
		   null is_connection
	from querry q1 join querry q2 on q1.table_name <> q2.table_name and q1.data_type = q2.data_type
); 
	-- Открываем курсор
  open querry;
  loop
	-- Записываем данные из курсора в переменные
    fetch querry into q_f, q_s;
   	-- Вывод в Output содержимое переменных для проверки
   	--raise notice 'q_f: %',  q_f;
	--raise notice 'q_s: %',  q_s;    
    --raise notice ' ';

    ex_quer := E'select case when count(*) > 1 then \'true\' else \'false\' end from (  '|| q_f ||' intersect '|| q_s ||' )';
    raise notice 'ex_quer: %',  ex_quer; 

    -- Просматриваем каждую гипотетическую связь
    if ex_quer is not null then
   		execute ex_quer into is_conn;
   		--raise notice 'is_conn: %',  is_conn; 
    	--raise notice ' ';
   	
   		-- Обновляем столбец, который поможет узнать, существует ли гипотетическая связь между таблицами
   		update hypothesis
   		set is_connection = is_conn
   		where querry_from_first = q_f and querry_from_second = q_s;
	end if;

    -- Выход, если дошли до конца 
    EXIT WHEN NOT FOUND;
    
  end loop;
  -- Закрываем курсор
  close querry;
end $$;

-- Просмотр таблиц, которые гипотетически могут быть связаны, и солбцы, по которым возможна связь
select table_from_first table_f, column_from_first maybe_key_f,  
	   table_from_second table_s, column_from_second maybe_key_s
from hypothesis
where is_connection = 'true';


-- Песочница для проверки запросов
-- Если есть хоть одно пересечение, то гипотетическая связь таблиц
select case when count(*) > 1 then 'true' else 'false' end
from (
select id from find_key1
intersect
select age from find_key2
);

select 'select case when count(*) > 1 then ''true'' else ''false'' end from (  '

select case when count(*) > 1 then 'true' else 'false' end
from (
select name from user2
intersect
select nname from find_key2
);