try
  drop table #tmp;
  drop table #tb_update;
catch all
end;
select ate_id tmp_ate_id into #tmp from ate where category=103 group by 1;
select * from #tmp;
 
--select count(*)
--from ( 
select s.id, a.ate_id, a.kod kod_ate, s.Kod kod, a.name,
	   s.name name_spr, a.namec, a.datein, a.dateout new_dateout
into #tb_update 
from #tmp t
left join ate a on a.ate_id=tmp_ate_id
left join спрсоато s on tmp_ate_id=s.ate_id
  where s.kod<>a.kod and a.category=103 
        and s.id<>26434 and s.id<>26431 and s.id<>24742 and s.id<>26019 /* Рыжковичский */ and s.id<>26334 /* Козловщинский поселковый */

--update s set kod=kod_ate, dateout=new_dateout 
-- from спрсоато s inner join #tb_update t ON s.ate_id=t.ate_id;
