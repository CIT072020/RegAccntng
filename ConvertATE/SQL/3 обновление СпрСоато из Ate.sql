try
  drop table #tmp;
  drop table #tb_update;
catch all
end;
select ate_id tmp_ate_id, max(datein) tmp_datein into #tmp from ate group by 1;
--select * from #tmp;
 
--select count(*)
--from (
 
select a.ate_id, a.kod kod_ate, s.Kod kod, a.name name_ate, s.name, a.name_b name_b_ate, s.name_b, ISNULL(s.typepunkt,999), cat2tp(category) new_typepunkt, 
         category, a.namec, a.datein, a.dateout new_dateout
into #tb_update 
from #tmp t
left join ate a on a.ate_id=tmp_ate_id and a.datein=tmp_datein
left join спрсоато s on tmp_ate_id=s.ate_id
where (s.kod<>a.kod or s.name<>a.name or s.name_b<>a.name_b or ISNULL(s.typepunkt,999)<>cat2tp(a.category))  
       and a.category<>245 and a.category<>243 and a.category<>103 and a.category<>101 and a.category<>202; --and a.category<>102;
	   
--) aaa
--order by a.ate_id, a.datein;
--select count(*) from #tb_update

//---- UPDATE ------------------
update s set name=name_ate, name_b=name_b_ate,  kod=kod_ate, typepunkt=IIF(new_typepunkt=999, null,new_typepunkt), dateout=new_dateout 
    from спрсоато s inner join #tb_update t ON s.ate_id=t.ate_id;
--update спрсоато set typepunkt=null where typepunkt=999;

--select count(*) from спрсоато s inner join #tb_update t ON s.ate_id=t.ate_id
--select * from #tb_update

