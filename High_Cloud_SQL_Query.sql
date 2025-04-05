create database high_cloud;

use high_cloud;
select *
from maindata;

alter table maindata rename column`carrier_froup_id` to Carrier_Group_ID;
alter table maindata rename column `%Airline ID` to Airline_ID;  
ALTER TABLE Maindata RENAME COLUMN `Month (#)` to Month;
ALTER TABLE Maindata RENAME COLUMN `# Available Seats` to Available_Seats;
ALTER TABLE Maindata RENAME COLUMN `# Transported Passengers` to Transported_Passengers;
ALTER TABLE Maindata RENAME COLUMN `Carrier Name` to Carrier_Name;
ALTER TABLE Maindata RENAME COLUMN `# Departures Scheduled` to Departures_Scheduled;
ALTER TABLE Maindata RENAME COLUMN `# Departures Performed` to Departures_Performed;
ALTER TABLE Maindata RENAME COLUMN `From - To City` to From_To_City;
ALTER TABLE Maindata RENAME COLUMN `%Distance Group ID` to Distance_group_ID;
ALTER TABLE distance_groups RENAME COLUMN `ï»¿%Distance Group ID` to Distance_group_ID;
ALTER TABLE distance_groups RENAME COLUMN `Distance Interval` to Distance_interval;

---------------------------------------------------------------------------------------------------------------------
#Key Metrics

SELECT COUNT(DISTINCT Airline_ID) AS Total_Airlines FROM maindata;
SELECT SUM(Transported_Passengers) AS Total_Passengers FROM maindata;
SELECT COUNT(DISTINCT Destination_Country) AS Total_County FROM maindata;
SELECT COUNT(DISTINCT Origin_City) AS Total_City FROM maindata;
SELECT round(avg(transported_passengers)/avg(Available_Seats)*100,1) AS LoadFactor FROM maindata;

-- ALTER TABLE maindata
-- ADD COLUMN Load_Factor Float;

-- UPDATE maindata
-- SET Load_Factor = (Transported_Passengers/Available_Seats) * 100
-- WHERE Available_Seats >0;

-----------------------------------------------------------------------------------------------------------

ALTER TABLE Maindata ADD COLUMN Date_Field DATE;

UPDATE Maindata SET Date_Field = 
STR_TO_DATE(CONCAT(Year, '-', LPAD(Month, 2, '0'), '-', LPAD(Day, 2, '0')), '%Y-%m-%d');
-- here LPAD insure that month and day are alwasy 2 digit. for eg. 3 becomes 03 


select date_field 
from maindata;

## Q1.A. Year
SELECT Year(Date_Field) FROM Maindata;

# Q1.B. Month No
 SELECT Month(Date_Field) as Month_No 
 FROM Maindata;
 
 ## Q1.C Month Name
 SELECT Month, MONTHNAME(Date_Field) as Month_Name 
 FROM Maindata;
 
 ## Q1.D Quarter
 SELECT MONTHNAME(Date_Field) as Month_Name, QUARTER(Date_Field) as Quarter 
 FROM Maindata;
 
 ## Q1.E Year_Month (YYYY-MMM)
 SELECT DATE_FORMAT(Date_Field, '%Y-%b') AS YearMonth 
 FROM Maindata;
 
 ## Q1.F. WeekDaysNo. 
 SELECT DAYOFWEEK(Date_Field) as Weekday_No 
 FROM Maindata;
        
## Q1.G. Weekday Name
SELECT DAYNAME(Date_Field) as Weekday_name 
FROM Maindata;

## Q1.H. Financial Month
SELECT MONTHNAME(Date_Field),
CASE
    WHEN MONTH(Date_Field) >= 4 THEN MONTH(Date_Field) - 3
    ELSE MONTH(Date_Field) + 9
  END AS FinancialMonth
FROM Maindata;

## Q1.I Financial Quarter
SELECT MONTH(Date_Field),
  CASE
    WHEN MONTH(Date_Field) BETWEEN 4 AND 6 THEN 'Q1'
    WHEN MONTH(Date_Field) BETWEEN 7 AND 9 THEN 'Q2'
    WHEN MONTH(Date_Field) BETWEEN 10 AND 12 THEN 'Q3'
    ELSE 'Q4'
  END AS FinancialQuarter
FROM Maindata;


-- KPI 1 : 

SELECT Year, Month, Day, MONTHNAME(Date_Field), QUARTER(Date_Field), DATE_FORMAT(Date_Field, '%Y-%b') AS YearMonth,
		DAYOFWEEK(Date_Field), DAYNAME(Date_Field),
CASE
    WHEN MONTH(Date_Field) >= 4 THEN MONTH(Date_Field) - 3
    ELSE MONTH(Date_Field) + 9
  END AS FinancialMonth,
  CASE
    WHEN MONTH(Date_Field) BETWEEN 4 AND 6 THEN 'Q1'
    WHEN MONTH(Date_Field) BETWEEN 7 AND 9 THEN 'Q2'
    WHEN MONTH(Date_Field) BETWEEN 10 AND 12 THEN 'Q3'
    ELSE 'Q4'
  END AS FinancialQuarter
FROM Maindata;


---------------------------------------------------------------------------------------------------------------------

-- KPI 2 :
## Q2. Find the load Factor percentage on a yearly , Quarterly , Monthly basis 
-- ( Transported passengers / Available seats)

SELECT 
     year(date_field) AS Years,
	 round(avg(Transported_passengers),0) AS Transported_passengers,
     round(avg(available_seats),0) AS available_seats,
     round((avg(transported_passengers)/avg(available_seats)*100),1) AS load_factor_percentage
FROM maindata
GROUP BY Years;

SELECT 
    monthname(date_field) AS MonthName ,
    round(avg(Transported_passengers),0) AS Transported_passengers,
	round(avg(available_seats),0) AS available_seats,
    round((avg(transported_passengers)/avg(available_seats)*100),1) as load_factor_Percentage
FROM maindata
GROUP BY MonthName
ORDER BY load_factor_Percentage ASC;

SELECT
     quarter(date_field) as Quarters,
     round(avg(Transported_passengers),0) AS Transported_passengers,
     round(avg(available_seats),0) AS available_seats,
     round((avg(transported_passengers)/avg(available_seats)*100),1) AS load_factor_percentage
FROM maindata
GROUP BY Quarters
ORDER BY Quarters ASC;


-------------------------------------------------------------------------------------------------------------------

-- KPI 3 :
## Q3. The load Factor percentage on a Carrier Name basis 
-- ( Transported passengers / Available seats)

select carrier_name as carrier_name,
 (avg(transported_passengers)/avg(available_seats)*100) as load_factor_percentage
from maindata
group by carrier_name
order by load_factor_percentage desc 
limit 10 ;


---------------------------------------------------------------------------------------------------------------------

-- KPI 4 :
## Q4. Identify Top 10 Carrier Names based passengers preference 

SELECT Carrier_Name, Sum(Transported_Passengers) AS Total_Passangers
FROM maindata
GROUP BY Carrier_Name
ORDER BY Total_Passangers DESC
LIMIT 10;


---------------------------------------------------------------------------------------------------------------------

-- KPI 5 :
## Q5.  Display top Routes ( from-to City) based on Number of Flights.

SELECT City_To_City, Count(Departures_Performed) AS No_of_flights
FROM maindata
GROUP BY City_To_City
ORDER BY No_of_flights DESC 
LIMIT 10;


---------------------------------------------------------------------------------------------------------------------

-- KPI 6 :
## Q6. Identify the how much load factor is occupied on Weekend vs Weekdays.

select avg(Transported_Passengers) / avg( Available_Seats) * 100 as load_factor_percentage ,
case 
      when dayofweek(date_field) in (1,7) 
      then "weekend"
	else "weekday"
  end as Day_Type  
from maindata 
group by Day_Type ;


---------------------------------------------------------------------------------------------------------------------

-- KPI 7 : 
## Q7. Identify number of flights based on Distance groups

select * 
 from distance_groups;
 
 
select distance_interval ,count(airline_id) as airline_count
from distance_groups inner join maindata
on distance_groups.Distance_group_id = maindata.Distance_group_id
group by distance_interval 
limit 10 ;
