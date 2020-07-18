#1
select max(cls) from
(select cls,ntile(2) over (order by cls) from stocks.s2010
) A
where ntile=1

#2
select count(1),count(distinct symb) from 
(select cls,symb,retdate,opn-prev_cls as opn_cls from
(select cls,symb,retdate,opn,
lag(cls) over (partition by symb order by retdate) as prev_cls
from stocks.s2010) as A) as B 
where opn_cls is NULL

#3 
---------

select symb,retdate,cls,
avg(cls) over (partition by symb order by retdate
rows between 2 preceding and 1 preceding),
cls - avg(cls) over (partition by symb order by retdate
rows between 2 preceding and 1 preceding) from stocks.s2010

---------
#4
select c1, row_number() over (order by c1) - 1 as c2 from
(select distinct(symb) as c1 from stocks.s2010 
order by 1) A


------------
#5

select lhs.symb,count(rhs.symb) from
(select distinct(symb) as symb from stocks.s2010 order by 1) as lhs
left join 
(select distinct(symb) as symb from stocks.s2010 order by 1) as rhs
on lhs.symb>rhs.symb
group by 1

