-- Using Database
use HCAHPS
GO

-- Tables created by importing CSV files. 
GO

-- Altering tables
GO

-- Reports.
alter table Reports
alter column Release_Period char(7) not null
GO

alter table Reports
add constraint PK_Release_Period_tblReports primary key (Release_Period)
GO

-- States.
alter table States
alter column State char(2) not null
GO

alter table States
add constraint PK_State_tblStates primary key (State)
GO

alter table States
alter column State_Name varchar(50) not null
GO

alter table States
alter column Region varchar(25) not null
GO

-- Measure
alter table Measures
alter column Measure_ID varchar(25) not null
GO

alter table Measures
add constraint PK_Measure_ID_tblMeasures primary key (Measure_ID)
GO

alter table Measures
alter column Measure varchar(100) not null
GO

alter table Measures
alter column type varchar(25) not null
GO

-- Questions
alter table Questions
alter column Measure_ID varchar(25) not null
GO

alter table Questions
add constraint FK_Measure_ID_tblQuestions foreign key (Measure_ID) references [dbo].[Measures]([Measure_ID])
GO

alter table Questions
alter column Question varchar(250) not null
GO

alter table Questions
alter column Bottom_box_Answer varchar(50) null
GO

alter table Questions
alter column Middle_box_Answer varchar(50) null
GO

alter table Questions
alter column Top_box_Answer varchar(50) null
GO

-- National Results
alter table National_Results
alter column Release_Period char(7) not null
GO

alter table National_Results
add constraint FK_Release_Period_tblNational_Results foreign key(Release_Period) references [dbo].[Reports]([Release_Period])
GO

alter table National_Results
alter column Measure_ID varchar(25) not null
GO

-- State Results
alter table State_Results
alter column Release_Period char(7) not null
GO

alter table State_Results
add constraint FK_Release_Period_tblState_Results foreign key (Release_Period) references [dbo].[Reports]([Release_Period])
GO

alter table State_Results
alter column State char(2) not null
GO

alter table State_Results
add constraint FK_State_tblState_Results foreign key (State) references [dbo].[States]([State])
GO

alter table State_Results
alter column Measure_ID varchar(25) not null
GO

alter table State_Results
add constraint FK_Measure_ID_tblState_Results foreign key (Measure_ID) references [dbo].[Measures]([Measure_ID])
GO

-- Responses
alter table Responses
alter column Release_Period char(7) not null
GO

alter table Responses
add constraint FK_Release_Period_tblResponse foreign key (Release_Period) references [dbo].[Reports]([Release_Period])
GO

alter table Responses
alter column State char(2) not null
GO

alter table Responses
alter column Facility_ID int null
GO

alter table Responses
alter column Completed_Surveys varchar(50) null
GO

-- Select Statements
select * from Reports
select * from Measures
select * from Questions
select * from Responses
select * from National_Results
select * from State_Results
select * from States
GO

-- Exploratory Data Analysis - HCAHPS 
GO

-- 1) Average hospital response rate for the survey.
with Avg_Response_Rate as
(
	select AVG(Response_Rate) as Avg_Response_Rate -- average aggregate function to store the average overall response rate for all years.
	from Responses
)
select CONCAT(Avg_Response_Rate, '%') as Avg_Response_Rate from Avg_Response_Rate -- Used a CTE to store the average response rate and formatted the result to display the output with % sign using concat string function.
GO

-- 2) Average response rate for the survey for each consecutive year. Check whether the response rate has been increasing or decreasing each year.
with Avg_Response_Rate_Per_Year as -- CTE used to store the response year, avg response rate in each year along with an additional column which stores the previous years response rate.
(
	select RIGHT(Release_Period, 4) as Response_Year, AVG(Response_Rate) as Avg_Response_Rate, -- RIGHT string function used to extract the last 4 digits of release period to get the year.
	LAG(AVG(Response_Rate)) over(order by RIGHT(Release_Period, 4)) as Result -- LAG windows function used to store the previous years response rate in a new column called Result.
	from Responses
	group by RIGHT(Release_Period, 4) -- grouping the result by the release period (Year).
)
select Response_Year, concat(Avg_Response_Rate, '%') as Avg_Response_Rate,
case when Result is null then null
	 when Result > Avg_Response_Rate 
     then 'Lower avg response rate in' + SPACE(1) + Response_Year + SPACE(1) + 'than' + SPACE(1) + cast(Response_Year - 1 as varchar(20)) -- Case to convert response year int data type to varchar. Space string function to add spaces between text.
	 when Result = Avg_Response_Rate 
	 then 'Same avg response rate in' + SPACE(1) + Response_Year + SPACE(1) + 'and' + SPACE(1) +  cast(Response_Year - 1 as varchar(20))
	 when Result < Avg_Response_Rate
	 then 'Higher avg response rate in' + SPACE(1) + Response_Year + SPACE(1) + 'than' + SPACE(1) + cast(Response_Year - 1 as varchar(20))
	 end Result -- case when statement to check whether previous years avg response was greater than, euqal to or less than current years avg response rate. Displayed the output accordingly. 
from Avg_Response_Rate_Per_Year
order by Response_Year
GO
-- The above analysis show that the overall avg response rate dropped each year from 2015 to 2023 from 30% to 22% respectively.
GO

-- 3) Total Number of Facilities (Hospitals) registered within database for each state and total count of hospitals.
select  r.State, s.State_Name, COUNT(distinct Facility_ID) as Number_Of_Facilities -- count distinct used to count the total number of unique facilities.
from Responses r
inner join States s on r.State = s.State
group by r.State, s.State_Name -- grouping the state and state name to get the total number of facilities in each state.
order by Number_Of_Facilities desc
GO
-- Texas has the highest (467) number of hospitals who completed the survey, while Delaware have the lowest (7)

select COUNT(distinct facility_ID) as Total_Hospitals from Responses
GO

-- 4) Avg overall top box percentage in 2015 Vs 2023
with Avg_TBP_2015_2023 as -- CTE used to store the response year and avg top box percentage.
(
	select RIGHT(Release_Period, 4) as Response_Year, AVG(Top_box_Percentage) as Avg_Top_Box_Percentage
	from National_Results
	group by RIGHT(Release_Period, 4)
)
select Response_Year, concat(Avg_Top_Box_Percentage, '%') as Avg_Top_Box_Percentage
from Avg_TBP_2015_2023
where Response_Year in (2015, 2023) -- WHERE clause used with IN to filter out data only for the years 2015 and 2023.
GO
-- The above analysis proves that the overall positive responses received from patients at various hospital from 2015 to 2023 dropped by 2%.
GO

-- 5) Individual measure analysis. (National Results)
-- 5a) Top 3 Highest and lowest rated measures (Avg of top box poercentage)
with HighestLowest_Rated_Measure_NationalResults as
(
	select r.Measure_ID, m.Measure, AVG(r.Top_box_Percentage) as Avg_Top_Box_Percentage,
		   DENSE_RANK() over(order by AVG(r.Top_box_Percentage) desc) as Rnk -- used dense rank windows function to rank the measures.
	from National_Results r
	inner join Measures m on r.Measure_ID = m.Measure_ID
	group by r.Measure_ID, m.Measure
)
select Measure_ID, Measure, concat(Avg_Top_Box_Percentage, '%') as Avg_Top_Box_Percentage, 
case when Rnk between 1 and 3 then 'Highest Rated Measure' end Result -- Used case statement to add a Result column which mentions whether the measure was highly rated or not based on avg top box percentage.
from HighestLowest_Rated_Measure_NationalResults
where Rnk between 1 and 3 -- Filtering only for top 3 ranks.
union all -- merging both tables together into a single table.
select Measure_ID, Measure, concat(Avg_Top_Box_Percentage, '%') as Avg_Top_Box_Percentage, 
case when Rnk between 8 and 10 then 'Lowest Rated Measure' end Result
from HighestLowest_Rated_Measure_NationalResults
where Rnk >= 8
GO
-- The above analysis proves that communication with doctors and nurses along with discharge information was highly rated by patients while communication about medicines, quietness of hospital and care transition was least appreciated.

-- 5b) Cleanliness of hospital environment. Avg top box response rate from 2015 to 2023.
with H_CLEAN_HSP_Average as
(
	select RIGHT(r.Release_Period, 4) as Response_Year, m.Measure_ID, m.Measure, AVG(r.Top_box_Percentage) as Avg_Top_Box_Percentage
	from National_Results r
	inner join Measures m on r.Measure_ID = m.Measure_ID
	group by RIGHT(r.Release_Period, 4), m.Measure_ID, m.Measure
)
select Response_Year, Measure_ID, Measure, CONCAT(Avg_Top_Box_Percentage, '%') as Avg_Top_Box_Percentage 
from H_CLEAN_HSP_Average
where Measure_ID = 'H_CLEAN_HSP' 
GO
-- The above analysis shows that there was an initial increase in the positive response rate from 2015 (74%) to 2021 (76%) from patients regarding cleanliness of hospitals. However, this number dropped from 76% to 72% in just two years.
GO

-- 5c) Communication with Nurses. Avg top box response rate from 2015 to 2023.
with H_COMP_1_Average as
(
	select RIGHT(r.Release_Period, 4) as Response_Year, m.Measure_ID, m.Measure, AVG(r.Top_box_Percentage) as Avg_Top_Box_Percentage
	from National_Results r
	inner join Measures m on r.Measure_ID = m.Measure_ID
	group by RIGHT(r.Release_Period, 4), m.Measure_ID, m.Measure
)
select Response_Year, Measure_ID, Measure, CONCAT(Avg_Top_Box_Percentage, '%') as Avg_Top_Box_Percentage 
from H_COMP_1_Average
where Measure_ID = 'H_COMP_1' 
GO
-- 79% positive response as recorded in 2015. This number gradually increased to 81% over a 6 year period, post which it dropped back to 79% in 2023.
GO

-- 5d) Communication with Doctors. Avg top box response rate from 2015 to 2023.
with H_COMP_2_Average as
(
	select RIGHT(r.Release_Period, 4) as Response_Year, m.Measure_ID, m.Measure, AVG(r.Top_box_Percentage) as Avg_Top_Box_Percentage
	from National_Results r
	inner join Measures m on r.Measure_ID = m.Measure_ID
	group by RIGHT(r.Release_Period, 4), m.Measure_ID, m.Measure
)
select Response_Year, Measure_ID, Measure, CONCAT(Avg_Top_Box_Percentage, '%') as Avg_Top_Box_Percentage 
from H_COMP_2_Average
where Measure_ID = 'H_COMP_2' 
GO
-- Communication with doctors dropped slighly from 82% in 2015 to 79% in 2023. However, it is still one of the highest rated measures.
GO

-- 5e) Responsiveness of Hospital Staff. Avg top box response rate from 2015 to 2023.
with H_COMP_3_Average as
(
	select RIGHT(r.Release_Period, 4) as Response_Year, m.Measure_ID, m.Measure, AVG(r.Top_box_Percentage) as Avg_Top_Box_Percentage
	from National_Results r
	inner join Measures m on r.Measure_ID = m.Measure_ID
	group by RIGHT(r.Release_Period, 4), m.Measure_ID, m.Measure
)
select Response_Year, Measure_ID, Measure, CONCAT(Avg_Top_Box_Percentage, '%') as Avg_Top_Box_Percentage 
from H_COMP_3_Average
where Measure_ID = 'H_COMP_3' 
GO
-- Responsiveness from hospital staff dropped from 68% to 65% from 2015 to 2023 respectively. 
GO

-- 5f) Communication about Medicines. Avg top box response rate from 2015 to 2023.
with H_COMP_5_Average as
(
	select RIGHT(r.Release_Period, 4) as Response_Year, m.Measure_ID, m.Measure, AVG(r.Top_box_Percentage) as Avg_Top_Box_Percentage
	from National_Results r
	inner join Measures m on r.Measure_ID = m.Measure_ID
	group by RIGHT(r.Release_Period, 4), m.Measure_ID, m.Measure
)
select Response_Year, Measure_ID, Measure, CONCAT(Avg_Top_Box_Percentage, '%') as Avg_Top_Box_Percentage 
from H_COMP_5_Average
where Measure_ID = 'H_COMP_5' 
GO
-- Communication about medicines dropped from 65% to 61% from 2015 to 2023 respectively.
GO

-- 5g) Discharge information. Avg top box response rate from 2015 to 2023.
with H_COMP_6_Average as
(
	select RIGHT(r.Release_Period, 4) as Response_Year, m.Measure_ID, m.Measure, AVG(r.Top_box_Percentage) as Avg_Top_Box_Percentage
	from National_Results r
	inner join Measures m on r.Measure_ID = m.Measure_ID
	group by RIGHT(r.Release_Period, 4), m.Measure_ID, m.Measure
)
select Response_Year, Measure_ID, Measure, CONCAT(Avg_Top_Box_Percentage, '%') as Avg_Top_Box_Percentage 
from H_COMP_6_Average
where Measure_ID = 'H_COMP_6' 
GO
-- Discharge information was the highest recorded measure and remained stable at 86% from 2015 to 2023.
GO

-- 5h) Care transition. Avg top box response rate from 2015 to 2023.
with H_COMP_7_Average as
(
	select RIGHT(r.Release_Period, 4) as Response_Year, m.Measure_ID, m.Measure, AVG(r.Top_box_Percentage) as Avg_Top_Box_Percentage
	from National_Results r
	inner join Measures m on r.Measure_ID = m.Measure_ID
	group by RIGHT(r.Release_Period, 4), m.Measure_ID, m.Measure
)
select Response_Year, Measure_ID, Measure, CONCAT(Avg_Top_Box_Percentage, '%') as Avg_Top_Box_Percentage 
from H_COMP_7_Average
where Measure_ID = 'H_COMP_7' 
GO
-- Care transition was recorded to be the lowest measure in the survey. No imporvement was recorded from 2015 (52%) to 2023 (51%)
GO

-- 5i) Overall Hospital Rating. Avg top box response rate from 2015 to 2023.
with H_HSP_Rating_Average as
(
	select RIGHT(r.Release_Period, 4) as Response_Year, m.Measure_ID, m.Measure, AVG(r.Top_box_Percentage) as Avg_Top_Box_Percentage
	from National_Results r
	inner join Measures m on r.Measure_ID = m.Measure_ID
	group by RIGHT(r.Release_Period, 4), m.Measure_ID, m.Measure
)
select Response_Year, Measure_ID, Measure, CONCAT(Avg_Top_Box_Percentage, '%') as Avg_Top_Box_Percentage 
from H_HSP_Rating_Average
where Measure_ID = 'H_HSP_RATING' 
GO
-- Not much difference was seen in the overall hospital ratings from 2015 (71%) to 2023 (70%). 
GO

-- 5j) Quietness of Hospital Environment. Avg top box response rate from 2015 to 2023.
with H_QUIET_HSP_Average as
(
	select RIGHT(r.Release_Period, 4) as Response_Year, m.Measure_ID, m.Measure, AVG(r.Top_box_Percentage) as Avg_Top_Box_Percentage
	from National_Results r
	inner join Measures m on r.Measure_ID = m.Measure_ID
	group by RIGHT(r.Release_Period, 4), m.Measure_ID, m.Measure
)
select Response_Year, Measure_ID, Measure, CONCAT(Avg_Top_Box_Percentage, '%') as Avg_Top_Box_Percentage 
from H_QUIET_HSP_Average
where Measure_ID = 'H_QUIET_HSP' 
GO
-- Quietness of hospital enviroment remained more or less the same throughout all years from 2015 to 2023
GO

-- 5k) Willingness to Recommend the Hospital. Avg top box response rate from 2015 to 2023.
with H_RECMND_Average as
(
	select RIGHT(r.Release_Period, 4) as Response_Year, m.Measure_ID, m.Measure, AVG(r.Top_box_Percentage) as Avg_Top_Box_Percentage
	from National_Results r
	inner join Measures m on r.Measure_ID = m.Measure_ID
	group by RIGHT(r.Release_Period, 4), m.Measure_ID, m.Measure
)
select Response_Year, Measure_ID, Measure, CONCAT(Avg_Top_Box_Percentage, '%') as Avg_Top_Box_Percentage 
from H_RECMND_Average
where Measure_ID = 'H_RECMND' 
GO
-- Willingness to recommend a hospital dropped by 2% from 2015 to 2023.
GO

-- 6) Individual measure analysis. (State Results)
-- 6a) Average overall top box percentage for each state. (Top 5 based on dense rank)
with State_Average_TBP as
(
	select sr.State, s.State_Name, AVG(sr.Top_box_Percentage) as Avg_Top_Box_Percentage, 
	DENSE_RANK() over(order by AVG(sr.Top_box_Percentage) desc) as DenseRnk
	from State_Results sr
	inner join States s on sr.State = s.State
	group by sr.State, s.State_Name
)
select State, State_Name, CONCAT(Avg_Top_Box_Percentage, '%') as Avg_Top_Box_Percentage
from State_Average_TBP
where DenseRnk between 1 and 5
GO

-- 6b) Average overall top box percentage for each state. (Bottom 5 based on dense rank)
with State_Average_TBP as
(
	select sr.State, s.State_Name, AVG(sr.Top_box_Percentage) as Avg_Top_Box_Percentage, 
	DENSE_RANK() over(order by AVG(sr.Top_box_Percentage)) as DenseRnk
	from State_Results sr
	inner join States s on sr.State = s.State
	group by sr.State, s.State_Name
)
select State, State_Name, CONCAT(Avg_Top_Box_Percentage, '%') as Avg_Top_Box_Percentage
from State_Average_TBP
where DenseRnk between 1 and 5 -- filtering for ranks between 1 and 5
GO

-- 6c) State wise response rate.
with StateWise_Response_Rate as
(
	select r.State, s.State_Name, AVG(r.Response_Rate) as Avg_Response_Rate 
	from Responses r inner join States s on s.State = r.State
	group by r.State, s.State_Name
)
select State, State_Name, CONCAT(Avg_Response_Rate, '%') as Avg_Response_Rate
from StateWise_Response_Rate
order by Avg_Response_Rate desc
GO

-- 6d) Avg top box percentage for all states with all measures from 2015 to 2023
with avg_top_box_percentage_PerState_PerYear as
(
select RIGHT(sr.Release_Period, 4) as Response_Year, sr.State, s.State_Name, sr.Measure_ID, m.Measure,
	   AVG(sr.Top_box_Percentage) over(partition by sr.state, sr.Measure_ID order by RIGHT(sr.Release_Period, 4)) 
	   as Avg_Top_Box_Percentage -- Avg function with windows function to get the average postive response % for each state and measure ordered by year.
from State_Results sr
	inner join Measures m on m.Measure_ID = sr.Measure_ID
	inner join States s on sr.State = s.State
)
select Response_Year, State, State_Name, Measure_ID, Measure, CONCAT(Avg_Top_Box_Percentage, '%') as Avg_Top_Box_Percentage
from avg_top_box_percentage_PerState_PerYear 
where State_Name = 'Alaska' and Measure_ID = 'H_Clean_HSP' -- Filter to check the increase or decrease in avg postive responses for each state and measure for each year.
GO

