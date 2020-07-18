# percent change

select distinct lhs.symb,lhs.avg_symb,rhs.symb_count from (

(select symb,upper(left(symb,1)) as fl ,
avg((cls-opn)/opn) over (partition by symb) as avg_symb,
max((cls-opn)/opn) over (partition by symb) as max_symb,
max((cls-opn)/opn) over (partition by upper(left(symb,1))) as max_fl
from stocks.s2010) as lhs
inner join
(select upper(left(symb,1)) as fl ,count(distinct symb) as symb_count from stocks.s2010 
group by 1) as rhs
on lhs.max_symb=lhs.max_fl and lhs.fl = rhs.fl ) 


# joining afer groupby


select lhs.symb,lhs.fl,lhs.l_avg,rhs.r_count from 
(
(select symb,max((cls-opn)/opn) as l_max,
upper(left(symb,1)) as fl , avg((cls-opn)/opn) as l_avg
from stocks.s2010 group by 1) as lhs
left join
(select upper(left(symb,1)) as fl , max((cls-opn)/opn) as r_max,
count(distinct symb) as r_count from stocks.s2010 group by 1) as rhs
on lhs.fl=rhs.fl and lhs.l_max=rhs.r_max
)


# Row_number() usage

select  c1,c2,c3 from
(select symb as c1,cls , 
max(cls) over (partition by symb) as c2,
row_number() over (partition by symb order by retdate) as c3
from stocks.s2010) IQ
where cls=c2


# 2 joins syntax
	
select outerlhs.symb,outerlhs.max_cls,
count(outerrhs.retdate)
from 
(
  (select lhs.symb,lhs.max_cls,rhs.retdate from 
    (select symb,max(cls) as max_cls from stocks.s2010 group by 1) as lhs
    inner join 
    (select symb,cls,retdate from stocks.s2010) as rhs
    on lhs.symb=rhs.symb and lhs.symb is not null
    and lhs.max_cls is not null and lhs.max_cls=rhs.cls
  ) as outerlhs
  inner join 
  (select symb,cls,retdate from stocks.s2010) as outerrhs
  on outerlhs.symb=outerrhs.symb and outerlhs.retdate>=outerrhs.retdate
   )
group by 1,2


# final window function

select symb,rn  from 
(
select lhs.symb ,lhs.cls,rhs.retdate,
max(lhs.cls) over (partition by lhs.symb) as max_cls,
row_number() over (partition by lhs.symb order by lhs.retdate) as rn
from 
  (
  (select symb,cls,retdate from stocks.s2010) as lhs
  right join
  (select distinct retdate from stocks.s2010 ) as rhs
  on rhs.retdate=lhs.retdate
  )
) A  
where cls=max_cls


