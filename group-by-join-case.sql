# left join

select lhs.symb,rhs.retdate from
(select symb,max(vol) as max_vol from stocks.s2010 group by 1) as lhs
left join 
(select symb,retdate,vol from stocks.s2010 ) as rhs
on lhs.symb=rhs.symb and lhs.max_vol=rhs.vol


# case with in max()

select lsymb, max(case when mindate=retdate then cls end) as firstcls,
max(case when maxdate=retdate then cls end) as lastcls from
(
(select symb as lsymb,min(retdate) as mindate,max(retdate) as maxdate
from stocks.s2010 group by 1) as lhs
left join 
(select symb,retdate,cls from stocks.s2010) as rhs
on lhs.lsymb=rhs.symb and (lhs.mindate=rhs.retdate or lhs.maxdate=rhs.retdate)
) as a
group by 1 

# case wihtin in sum

select l_symb, sum(case when retdate is null then 1 else 0 end)

from (
(select distinct symb as l_symb from stocks.s2010 where date_part('month',retdate)=1
and symb in (select distinct symb from stocks.s2011)
) as J1
cross join 
(select distinct retdate as alldates
from stocks.s2010 where date_part('month',retdate)=1) as J2
left join 
(select symb,retdate from stocks.s2010 where date_part('month',retdate)=1) as J3
on J1.l_symb=J3.symb and J2.alldates=J3.retdate and J2.alldates is not NULL
) A group by 1 order by 2 desc