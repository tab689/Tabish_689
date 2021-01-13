create schema sql_assignment;

use sql_assignment;

# importing and checking table
### BAJAJ
select * from bajaj;

# Creating bajaj1
create table bajaj1 as
select Date, round(`Close Price`, 2) as 'Close Price',
round(avg(`Close Price`) over (order by date rows 19 preceding), 2) as 20_MA,
round(avg(`Close Price`) over (order by date rows 49 preceding), 2) as 50_MA
from bajaj;

# Checking bajaj1
select * from bajaj1;

# EICHER
# Importing Eicher 
select * from eicher;

# Creating eicher1
create table eicher1 as
select Date, round(`Close Price`, 2) as 'Close Price',
round(avg(`Close Price`) over (order by date rows 19 preceding), 2) as 20_MA,
round(avg(`Close Price`) over (order by date rows 49 preceding), 2) as 50_MA
from eicher;

# checking eicher1 table
select * from eicher1;

#HERO
# Importing and checking HERO table
select * from hero;

# create table hero1 
create table hero1 as
select Date, round(`Close Price`, 2) as 'Close Price',
round(avg(`Close Price`) over (order by date rows 19 preceding), 2) as 20_MA,
round(avg(`Close Price`) over (order by date rows 49 preceding), 2) as 50_MA
from hero;

# checking table hero1
select * from hero1;

# INFOSYS
#importing and checking the Infosys table
select * from infosys;

# Creating new Table Infosys1
create table Infosys1 as 
select Date, round(`Close Price`, 2) as 'Close Price',
round(avg(`Close Price`) over (order by date rows 19 preceding), 2) as 20_MA,
round(avg(`Close Price`) over (order by date rows 49 preceding), 2) as 50_MA
from infosys;

# checking table infosys1
select * from infosys1;

# TCS 
# checking and importing TCS
select * from TCS;

# Create new table TCS1
create table TCS1 as 
select Date, round(`Close Price`, 2) as 'Close Price',
round(avg(`Close Price`) over (order by date rows 19 preceding), 2) as 20_MA,
round(avg(`Close Price`) over (order by date rows 49 preceding), 2) as 50_MA
from TCS;

# Checking table TCS1
select * from TCS1;

# TVS
# importing and checking TVS
select * from TVS;

# Create table tvs1
create table TVS1 as
select Date, round(`Close Price`, 2) as 'Close Price',
round(avg(`Close Price`) over (order by date rows 19 preceding), 2) as 20_MA,
round(avg(`Close Price`) over (order by date rows 49 preceding), 2) as 50_MA
from TVS;

#checking table tvs1
select * from TVS1;

# MASTER TABLE
Create table master_table as 
select bajaj.date,
round(tvs.`Close Price`,2) as TVS,
round(tcs.`Close Price`,2) as TCS,
round(infosys.`Close Price`,2) as Infosys, 
round(eicher.`Close Price`,2) as Eicher, 
round(hero.`Close Price`,2) as Hero, 
round(bajaj.`Close Price`,2) as Bajaj
from bajaj 
left join eicher on eicher.date = bajaj.date
left join hero on hero.date = eicher.date
left join infosys on infosys.date = hero.date
left join tcs on tcs.date = infosys.date
left join tvs on tvs.date = tcs.date;

# checking master table
select * from master_table;

SET SQL_SAFE_UPDATES = 0;


# Creating bajaj2
# We are dropping 20 day ma and 50 day ma as we are now interested in differnece
create table bajaj_1 as 
select date, `close price`,
50_MA - 20_MA as'Diff',
row_number() over () as 'Row'
from bajaj1;

# Adding a column Signal
alter table bajaj_1
add column `Signal` varchar(10) default 'Hold';

# checking table bajaj_1
select * from bajaj_1;

# Create a new table bajaj2
create table bajaj2 as
select a.`Date`, a.`close price`, a.Diff, b.Diff 'Diffp' , a.row , a.signal
from bajaj_1 a inner join bajaj_1 b on a.row = b.row-1;

# checking bajaj2
select * from bajaj2;

# Now we update the signal column based on the values of Diff and Diffp.
# Remember flag is defined as 20  MA - 50 MA. 
# When the sign changes from -ve to +ve, buy as the stock is on an upturn
# When the sign changes from +ve to -ve , sell 
# Note that when the Diff and Diffp are of same sign no signal is generated (Hold default)

update bajaj2
set `signal` = 'Buy'
where Diff > 0 and Diffp <0 ;

select *
from bajaj2
where `signal` = 'buy';

update bajaj2
set `signal` = 'Sell'
where Diff < 0 and Diffp > 0 ;

select *
from bajaj2
where `signal` = 'sell' or `signal` = 'buy';

# for eicher


create table eicher_1 
select `Date`, `Close Price`,
50_MA - 20_ma as 'Diff', 
row_number() over () as 'Row'
from eicher1;

# Adding a signal column (Populate it with the default hold)

alter table eicher_1
add column `Signal` varchar(6) default 'Hold';

# Checking table

select * 
from eicher_1;


# Create a new table eicher2

create table eicher2 as
select a.`Date`, a.`close price`, a.Diff, b.Diff 'Diffp' , a.row , a.signal
from eicher_1 a inner join eicher_1 b on a.row = b.row-1;

select *
from eicher2;

# updating and adding sell column
update eicher2
set `signal` = 'Buy'
where diff > 0 and Diffp <0 ;

select *
from eicher2
where `signal` = 'buy';

# Again updating
update eicher2
set `signal` = 'Sell'
where Diff < 0 and Diffp > 0 ;

select * 
from eicher2
where `signal` = 'sell';

# Creating hero2

create table hero_1 
select `Date`, `Close Price`,
50_MA - 20_ma as 'Diff' , 
row_number() over () as 'Row'
from hero1;

# Adding a signal column

alter table hero_1
add column `Signal` varchar(6) default 'Hold';

select * 
from hero_1;

# Create a new table hero2

create table hero2 as
select a.`Date`, a.`close price`, a.Diff, b.Diff 'Diffp' , a.row , a.signal
from hero_1 a inner join hero_1 b on a.row = b.row-1;

select *
from hero2;

update hero2
set `signal` = 'Buy'
where Diff > 0 and Diffp <0 ;

select *
from hero2
where `signal` = 'buy';

update hero2
set `signal` = 'Sell'
where Diff < 0 and Diffp > 0 ;

select *
from hero2
where `signal` = 'sell' or `signal` = 'buy';

# Creating infosys1

create table infosys_1 
select `Date`, `Close Price`,
50_MA - 20_ma as 'Diff' , 
row_number() over () as 'Row'
from infosys1;

# Adding a signal column

alter table infosys_1
add column `Signal` varchar(6) default 'Hold';

# Checking table infosys_1
select * 
from infosys_1;

# Create a new table infosys2

create table infosys2 as
select a.`Date`, a.`close price`, a.Diff, b.Diff 'Diffp' , a.row , a.signal
from infosys_1 a inner join infosys_1 b on a.row = b.row-1;

select *
from infosys2;


update infosys2
set `signal` = 'Buy'
where Diff > 0 and Diffp <0 ;

select *
from infosys2
where `signal` = 'buy';

update infosys2
set `signal` = 'Sell'
where Diff < 0 and Diffp > 0 ;

select *
from infosys2
where `signal` = 'sell' or `signal` = 'buy';

# Creating TCS2

create table tcs_1 
select `Date`, `Close Price`,
50_MA - 20_ma as 'Diff' , 
row_number() over () as 'Row'
from tcs1;

# Adding a signal column 

alter table tcs_1
add column `Signal` varchar(6) default 'Hold';

select * 
from tcs_1;

# Create a new table tcs2

create table tcs2 as
select a.`Date`, a.`close price`, a.Diff, b.Diff 'Diffp' , a.row , a.signal
from tcs_1 a inner join tcs_1 b on a.row = b.row-1;

select *
from tcs2;

# Updating table

update tcs2
set `signal` = 'Buy'
where Diff > 0 and Diffp <0 ;

select *
from tcs2
where `signal` = 'buy';

update tcs2
set `signal` = 'Sell'
where Diff < 0 and Diffp > 0 ;

select *
from tcs2
where `signal` = 'sell' or `signal` = 'buy';

# Creating tvs2

create table tvs_1 
select `Date`, `Close Price`,
50_MA - 20_ma  as 'Diff' , 
row_number() over () as 'Row'
from tvs1;

# Adding a signal column

alter table tvs_1
add column `Signal` varchar(6) default 'Hold';

select * 
from tvs_1;

# Create a new table tvs2

create table tvs2 as
select a.`Date`, a.`close price`, a.Diff, b.Diff 'Diffp' , a.row , a.signal
from tvs_1 a inner join tvs_1 b on a.row = b.row-1;

select *
from tvs2;
update tvs2
set `signal` = 'Buy'
where Diff > 0 and Diffp <0 ;

select *
from tvs2
where `signal` = 'buy';

# Updating the table

update tvs2
set `signal` = 'Sell'
where Diff < 0 and Diffp > 0 ;

select *
from tvs2
where `signal` = 'sell' or `signal` = 'buy';

## # All tables have been created

# Now to create a User defined function

select `signal`
from bajaj2 where `date` = '2018-05-18';

create function result (d char(20))
returns char(10) deterministic
return 
(
select `signal`
from bajaj2 where `date` = d
);


# Testing

select `date`, result(`date`)
from bajaj2
where result(`date`) = 'buy';




