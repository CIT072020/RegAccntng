--insert into СпрСоато (kod,name,name_b,ate_id )
  select a.kod, a.name, a.name_b, a.ate_id from ate a
  left join СпрСоато s on s.ate_id=a.ate_id
  where s.kod is null and category<>245 and category<>243