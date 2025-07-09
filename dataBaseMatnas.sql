drop database matnasDB_temp


create database matnasDB_temp
use matnasDB_temp
begin tran
create table Student
(
s_id varchar (9) not null primary key,
s_firstName varchar(10) not null,
s_lastName  varchar(10) not null,
s_adress varchar(15) not null,
s_city varchar(15) not null,
s_tel varchar(10) not null,
s_dataBorn date not null,
s_gender varchar(10) not null,
s_chove int
)
create table Teacher
(
t_id varchar (9) not null primary key,
t_firstName varchar(10) not null,
t_lastName  varchar(10) not null,
t_adress varchar(15) not null,
t_city varchar(15) not null,
t_phone varchar (10) not null,
t_gender varchar(10) not null,
)
create table category
(
cg_code  int identity (300,1) not null primary key,
cg_name varchar (10),
)
create table Course
(
cs_code  int identity (100,1) not null primary key,
cs_Name varchar (30),
cs_codeCtegory int not null foreign key references category(cg_code),
cs_gender varchar(10) not null,
cs_misMeet int not null,
cs_minAgeCust int not null,
cs_maxAgeCust int not null,
cs_price float not null,
cs_misMinCust  int not null,
cs_misMaxCust  int not null,
)
create table Reashom
(
r_code  int identity (1000,1) not null primary key,
r_id  varchar (9)  not null foreign key references Student(s_id), 
r_dataReashom date not null,
r_codeCours int not null foreign key references Course(cs_code),
r_status bit,
)
create table Teams
(
t_code  int identity (1100,1) not null primary key,
t_codeCour  int not null foreign key references Course(cs_code),
t_idTeacher varchar(9) not null foreign key references Teacher(t_id), 
t_daysPlay varchar (7) not null,
t_hourOpen datetime not null,
)
create table StudTeam
(
st_codeTeam int not null foreign key references Teams(t_code),
st_idStud varchar(9)  not null foreign key references Student(s_id)
) 

create table StandByList
(
sb_idStud varchar(9)  not null foreign key references Student(s_id),
sb_codeCours  int not null foreign key references Course(cs_code),
)

commit

insert into Student
values
('324653982','Rivki','Rubin', 'r akiva','BneiBrak','039088158','2008/01/04','female',0),('322696858','Pesi','cohen', 'r akiva','BneiBrak','039066158','2004/01/04','female',20),
('223888777','Malki','Swirtz', 'r akiva','BneiBrak','039177158','2002/10/06','female',10),('020407620','Esti','Waiss','r akiva','BneiBrak','039199158','2004/01/04','female',70),
('327987717','yosef','ley','ben zakai','Elad','036134747','2007/01/04','male',0),('039686525','yosef','coen','tor','Elad','039088168','2010/01/01','male',0)
,('039699925','yakov','hernman','yaear','Elad','036088168','2009/01/01','male',0)
select * from Student
insert into Teacher
values
('324653636','avigail','yerushalmi', 'ben kisma','Elad','0548408327','female'),('322692258','Pnina','cohen', 'r akiva','BneiBrak','0548488168','female'),
('238855557','Mali','Srim', 'rabin','Petach Tikva','0506955780','female'),('020507620','Esti','Eavg','Even Gvirol','Elad','0504118965','female'),
('327222717','chaim','levi','ben zakai','Elad','0504144917','male'),('040789652','Moshe','Mizrachi','La Gardia','Tel Aviv','0522441386','male')
select * from Teacher
insert into category
values
('swing'),('Excersie'),('bakery'),('Dance')
select distinct cg_name from category
insert into Course
values
('swing to start',300,'female',12,12,18,500.00,5,10),('swing to continu',301,'female',12,10,14,800.00,5,10)
select * from Course

--constraint
alter table StudTeam add constraint pkStudTeam primary key(st_codeTeam,st_idStud)
alter table StandByList add constraint pkStandByList primary key(sb_idStud,sb_codeCours)
alter table Course add constraint cs_misMeet check (cs_misMeet between 7 and 12)
alter table category add constraint cg_name check (cg_name in('swing','Excersie','bakery','Dance'))
alter table Teams add constraint t_daysPlay check (t_daysPlay in('Sunday ','Monday','Tuesday','Wednesday','Thursday'))
alter table Teams add constraint t_hourOpen check (t_hourOpen between '16:00:00' and '20:00:00')
alter table Course add constraint cs_price check (cs_price between 500.00 and 1000.00)


insert into Reashom
values
('324653982','2024/05/21',101,1),('322696858','2024/06/21',100,1), ('039699925','2024/03/21',101,1),('322696858','2024/06/21',101,1)
select * from Reashom
 insert into Teams
 values
 (101,'324653636','sunday','16:00:00'), (101,'322692258','sunday','16:00:00')
 select * from Teams
 insert into StudTeam
 values
 (1100,'324653982'), (1101,'322696858'), (1101,'223888777'),(1101,'324653982')
 select * from StudTeam
  insert into StandByList
 values
 ('324653982',101), ('322696858',101), ('039686525',101), ('039699925',101)    
select * from Reashom
