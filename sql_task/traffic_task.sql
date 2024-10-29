SELECT acc
FROM (
	SELECT DISTINCT CASE WHEN amt > lim THEN acc END acc
	FROM (
		SELECT acc, dt, amt s, ldt, sum(amt) OVER (PARTITION BY acc, ldt ORDER BY dt ROWS BETWEEN per - 1 PRECEDING AND CURRENT ROW) amt, lim
		FROM (
			SELECT nt.acc, nt.dt, nt.amt, tc.dt ldt, lim, per
			FROM (
				SELECT DISTINCT acc, dt, sum(amt) over(PARTITION BY acc, dt) amt
				FROM (
				SELECT DISTINCT uacc acc, udt + lvl dt, amt
				FROM (
				SELECT us_cond.*, conb.*, 
					   CASE WHEN lvl <> 0 THEN 0 ELSE amt_a_day END amt 
				FROM (
					SELECT tu.acc uacc, tu.dt udt, amt_a_day, tc.acc cacc, tc.dt cdt, lim, per
					FROM (
						SELECT acc, dt, sum(amt) amt_a_day
						FROM alexeymn.FINAL_TRAFIC
						GROUP BY acc, dt ) tu
						JOIN alexeymn.FINAL_CONDITIONS tc ON tu.acc = tc.acc AND tu.dt >= tc.dt - tc.per) us_cond, 
					(SELECT CASE WHEN MOD(LEVEL,2) = 0 THEN ceil(LEVEL / 2)
								 ELSE - ceil(LEVEL / 2) END lvl
					FROM dual
					CONNECT BY LEVEL <= (SELECT max(per) * 2 FROM alexeymn.FINAL_CONDITIONS)
					UNION 
					SELECT 0 FROM dual) conb
				WHERE abs(lvl) < per))) nt
				LEFT JOIN alexeymn.FINAL_CONDITIONS tc ON nt.acc = tc.acc AND nt.dt > tc.dt - per) ust
		WHERE dt < (SELECT lddt
					FROM (
						SELECT acc, dt, lead(dt, 1, to_date('9999-01-01', 'yyyy-mm-dd')) over(PARTITION BY acc ORDER BY dt) lddt FROM alexeymn.FINAL_CONDITIONS) 
						WHERE acc = ust.acc AND ust.ldt = dt)
		  AND lim IS NOT NULL)
	UNION
	SELECT acc 
	FROM alexeymn.FINAL_CONDITIONS
	WHERE acc NOT IN (SELECT acc FROM alexeymn.FINAL_TRAFIC) AND lim < 0
	UNION
	SELECT acc 
	FROM (
		SELECT DISTINCT u.acc acc, 0 amt, lim
		FROM alexeymn.FINAL_TRAFIC u JOIN alexeymn.FINAL_CONDITIONS c ON u.acc = c.acc 
		 AND (u.dt <= (SELECT min(dt - per) FROM alexeymn.FINAL_CONDITIONS WHERE acc = c.acc GROUP BY acc)
		  OR u.dt < (SELECT max(dt - per) FROM alexeymn.FINAL_CONDITIONS WHERE acc = c.acc GROUP BY acc)
		  OR u.dt > (SELECT max(dt + per) FROM alexeymn.FINAL_CONDITIONS WHERE acc = c.acc GROUP BY acc)))
	WHERE amt > lim)
WHERE acc IS NOT null