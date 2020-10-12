select * from СпрСоато s 
left join ate a on s.ate_id=a.ate_id
where a.kod is null and category<>245 and category<>243