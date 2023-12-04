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


# more joins

select distinct origin, dest, first_value(cost) over (partition by origin, dest order by cost ,stops) as cost,
 first_value(stops) over (partition by origin, dest order by cost ,stops) as stops
from
(
select a1.origin, b1.dest, (a1.cost + b1.cost) as cost, 2 as stops from
trips a1 join
(select a.origin, b.dest,(a.cost+b.cost ) as cost from 
trips a join trips b on a.dest=b.origin) b1
on a1.dest = b1.origin

union

select a.origin, b.dest,a.cost+b.cost as cost, 1 as stops from 
trips a join trips b on a.dest=b.origin

union 

select *,0 as stops from trips ) joined_table

select * from trips


--  calculating percentile values using window function

--  here 95th percentile is calculated
SELECT * FROM 
(SELECT t.*,  @row_num :=@row_num + 1 AS row_num FROM YOUR_TABLE t, 
    (SELECT @row_num:=0) counter ORDER BY YOUR_VALUE_COLUMN) 
temp WHERE temp.row_num = ROUND (.95* @row_num); 