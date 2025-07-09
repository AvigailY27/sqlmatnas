create  database matnasDB_temp
use matnasDB_temp


declare
@cnt int
select @cnt=COUNT(st.st_codeTeam) from  StudTeam st join Teams t on t.t_code=st.st_codeTeam
print @cnt
select * from StudTeam where COUNT(st_codeTeam)>=@cnt


-- המחזירה את כמות התלמידים המחכים לפתיחת חוג  x   פונקציה

CREATE FUNCTION openInStandBy(@codeCourse int)
returns int 
AS
begin
declare
@cnt int
set @cnt=(select COUNT(sb_codeCours) 
from StandByList where sb_codeCours=@codeCourse 
group by sb_codeCours)
return @cnt
END;

select cs_code,cs_Name,COUNT(st_codeTeam) from Course c 
join Teams on t_codeCour=cs_code join StudTeam on st_codeTeam=t_code
where st_codeTeam=t_code and t_codeCour=cs_code
group by st_idStud,cs_Name,cs_code

--  בפורצדורה שימוש
declare
@ans int,
@code int
select @code=cs_code from Course 
join StandByList 
on cs_code=sb_codeCours group by cs_code, sb_codeCours ,cs_misMinCust
having count(sb_codeCours) >=cs_misMinCust
 exec @ans= openInStandBy @code
print 'count waiting for course'
 print @code 
 print @ans 

--שאילתה המציגה לכל תלמיד את החוגים שלו *
select name= s_firstName+' '+ s_lastName, cs_Name from Reashom join Student 
on s_id=r_id  and r_status=1 
join Course on cs_code=r_codeCours 
order by s_id

--  המעדכנת את החוב של  התלמיד בהתאם למחיר החוג פורצדורה
create or alter proc
updatePrice(@price int, @idStud varchar(9))
as
begin
update Student 
set s_chove=s_chove+@price where s_id in(select r_id from Reashom where r_status=1)
end
-- (trigger) שמעדכן אוטומטית את החוב כאשר תלמיד נכנס לקבוצה פעם נוספת יהיה לו הנחה של 10%  **

CREATE trigger update_chove on Reashom for insert 
AS
update  Student
set s_chove=0.9*s.s_chove from
 Student s , inserted as i
where
s.s_chove!=0  and s_id=i.r_id and r_status=1


--שאילתה המציגה לחוג Tfira to continu  את התלמידים  בקבוצה הרשומים בו

select s_firstName as 'תלמיד בחוג תפירה מתקדם'from  Teams 
join StudTeam on t_code=st_codeTeam join Student  on s_id=st_idStud
where t_code=st_codeTeam and t_codeCour= 101
--מספר מקומות פנוי בקבוצה*

select cs_Name,MisPlaceEmpty =cs_misMaxCust- COUNT(st.st_codeTeam) 
from Teams t join StudTeam st on t.t_code=st.st_codeTeam
join  Course cs on cs_code=t.t_codeCour 
where t.t_code=st.st_codeTeam 
group by  cs_Name,t.t_code,cs_misMaxCust

-- (trigger) שמעדכן אוטומטית את הסטטוס כאשר תלמיד עובר לקבוצה פעילה
CREATE trigger update_tStutus on StudTeam for insert 
AS
update Reashom set r_status=1
from Reashom r , StudTeam st
where
r_status=0 and st. st_idStud=r_id 

--   שאילתה המציגה את התלמידים שחריגים-נמצאים בשתי קבוצות באותו יום ושעה 
select * from StudTeam s where st_idStud in 
(select st_idStud from StudTeam 
where st_codeTeam!=s.st_codeTeam
and st_codeTeam in (select t_code from Teams where t_daysPlay =
(select t_daysPlay from Teams where st_codeTeam!=t_code)))
select * from StudTeam join Teams on t_code=st_codeTeam
