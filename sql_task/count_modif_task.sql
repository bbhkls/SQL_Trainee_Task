-- Задача:
/*
 Найти таблицы, в которых было много изменений (Insert, Update, Delete).
 Вывести в порядке убывания.
 */

select table_name, (inserts + updates + deletes) modif
from (
	select relname AS table_name, sum(n_tup_ins) AS inserts, sum(n_tup_upd) AS updates, sum(n_tup_del) AS deletes
	from pg_stat_all_tables pgst join pg_tables pt on pgst.relname = pt.tablename
	where pt.tableowner = 'serps'
	group by relname
)
order by modif desc
