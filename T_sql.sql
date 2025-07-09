
---פורצדורה להוספת תלמיד(רישום) לקבוצה
create or alter proc
AddStudToTeam1(@code int, @idStud varchar)
as
declare
@ageStud int,
@agecourMin int,
@agecourMax int,
@genderStud varchar,
@genderCourse varchar,
@chove int,
@countstud int,
@ans int,
@s int
select @ageStud=DATEDIFF (yy,s_dataBorn,GETDATE()) from Student where s_id=@idStud
select @agecourMin=cs_minAgeCust from Course where cs_code=@code
select @agecourMax=cs_maxAgeCust from Course where cs_code=@code
select @genderStud=s_gender  from Student where s_id=@idStud
select @genderCourse=cs_gender from Course where cs_code=@code
select @countstud=cs_misMinCust from Course where cs_code=@code 
select @s= t_code from Teams where @code=t_codeCour 
select @chove=s_chove  from Student where s_id=@idStud
begin
	if (@code is null)
		print  ('the course not found')
	else 
	if(@ageStud<=@agecourMin or @ageStud>=@agecourMax )
		print ('the age from stud is does not fit to the age course')
	else
		begin
			if  (@genderStud!=@genderCourse)
				print ('gender course not fit gender student')
			else 
				begin
					if  (@chove>1000)
						print ('pay your chove and try again later')
					else 
						begin
							if(@code not in (select t_codeCour from Teams  ))         
								begin
									insert into StandByList values(@idStud,@code) 
									print ('you now in standBy') 
									exec @ans=openInStandBy @code
								end
							if(@ans>=@countstud)
								print ('now you can open course'+@code)
							else
								begin 
									insert into StudTeam values (@s,@idStud )
								end
							end 
				end 
		end
	insert into Reashom values(@idStud,GETDATE(),@code,0)
	print ('the reashom add succesfully')
end
-- הוספת רישום שימוש בפורצדורה
declare 
@ans1 int
exec @ans1= AddStudToTeam1 100,'02047620'
select * from Reashom
select * from Student
select * from StudTeam
select * from Course
----- view שמציג למזכירה את שם התלמיד טלפון וכמה החוב שלו לגביה 
create view PayStud
as
select sum(s_chove)as 'chove' ,s_firstName+' '+s_lastName as name,s_tel
from Student where s_id in (select st_idStud from StudTeam) and s_chove>0
group by s_id ,s_firstName,s_lastName,s_tel
 
select * from PayStud
-- פורצדורה פתיחת קבוצה חדשה לחוג 
create or alter proc 
AddTeam(@codeCours int, @idTeach varchar,@t_daysPlay varchar,@t_hourOpen datetime)
as
declare
@genderTeach varchar,
@genderCours varchar,
@t_hourTeach datetime,
@t_hourDay varchar,
@countStusent int,
@misMinStud int,
@codeteam int
begin
select @genderTeach= t_gender from Teacher where t_id=@idTeach
select @genderCours=cs_gender from Course where cs_code=@codeCours
select @t_hourTeach= t_hourOpen from Teams where t_idTeacher=@idTeach
select @t_hourDay= t_daysPlay from Teams where t_idTeacher=@idTeach
select @countStusent= count(sb_idStud) from StandByList join Course on sb_codeCours=cs_code
where sb_codeCours=cs_code
select @misMinStud=cs_misMinCust from Course where cs_code=@codeCours
if (@genderTeach!=@genderCours)
	begin
		print ('the gender fron teacher not fit to the gender course')
		return 
end
if(@t_hourDay=@t_daysPlay and  @t_hourTeach=@t_hourOpen or(@t_hourTeach between @t_hourOpen and @t_hourOpen+1))
	begin	
		print ('this hour on this day busy')
		return
	end
if(@countStusent<@misMinStud)
	begin
		print ('Not enough student on the StandByList that want to learn this course')
		return
	end 
insert into Teams values(@codeCours,@idTeach,@t_daysPlay,@t_hourOpen)
select @codeteam = t_code from Teams where @codeCours=t_codeCour and @idTeach = t_idTeacher
       insert into StudTeam select @codeteam,sb_idStud from StandByList where @codeCours=sb_codeCours 
delete StandByList 
where @codeCours=sb_codeCours
print ('the teams add succesfully')
end

select * from StandByList
declare 
@ans int
exec @ans= AddTeam 100,'324653636','sunday','17:00:00'
select * from Teams


--לעשות פונ שמכניסה את התלמידים שבהמתנה לקבוצה הזו

--not important 
----אי אפשר להירשם יותר מפעם אחת לאותו חוג
----תנאי ב-T-SQLהאם יש תלמיד הנרשם לחוג מסוים יותר מפעם אחת
----אם כן תתדפיס הודעה ותעדכן שהוא נמחק
----הבעיה ששמוחק את כל הרישומים שלו בכלל
--use matnasDB_temp
--declare
--@idStud varchar (9),
--@cnt int
--select @idStud=r_id from Reashom where r_id in (select s_id from Student)
--select @cnt=COUNT(r_id) from Reashom where r_id in (select s_id from Student)
--print @idStud
--print @cnt

-- if(@cnt>1)
-- begin
-- delete from  Reashom
-- where r_id=@idStud
--  print @idStud

--end
--else
--print 'no distincts'
--select*
--from Reashom