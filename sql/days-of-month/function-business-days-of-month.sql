USE FinanceDB
GO

IF OBJECT_ID('dbo.fnBusinessDays') IS NOT NULL
	DROP FUNCTION dbo.fnBusinessDays
GO


CREATE FUNCTION dbo.fnBusinessDays ( @d DATE )
	RETURNS @tbl TABLE (
		date_value DATE
		,year_value INT
		,month_value INT
		,day_value INT
		,day_of_week INT
		,business_day_of_month INT
	)
AS
/*
summary:	>
			Takes an input of a date and returns a table
			with all of that month's dates, with
			various values related to those days.
			Primary Output Value: business_day_of_month
			Value Definition: Denotes the number of
			the business day of the month. When not
			a business day (i.e., weekend or holiday)
			the value is returned as 0.
Examples:
- Find Business Day of Month:
		DECLARE @m DATE = '2014-05-05';
		SELECT business_day_of_month
		FROM dbo.fnBusinessDays(@m)
		WHERE date_value=@m;
- Find Xth Business Date of Month:
		DECLARE @m DATE = '2014-05-01', @d INT = 3;
		SELECT date_value
		FROM dbo.fnBusinessDays(@m)
		WHERE business_day_of_month=@d;
Revisions:
- version 1:
		Modification: Initial script for GitHub
		Author: Zach Mueller
		Date: 2014-07-21
*/
BEGIN

DECLARE @y INT = YEAR(@d), @m INT = MONTH(@d)
DECLARE @d1 DATE = DATEADD(m,DATEDIFF(m,0,@d),0)

--	CTE to fill current month's days
;WITH cte AS (
	SELECT CAST(@d1 AS DATE) date_value
		,YEAR(@d1) year_value
		,MONTH(@d1) month_value
		,DAY(@d1) day_value
		,DATEPART(weekday, @d1) day_of_week
		--	If weekend or is a holiday, start at 0
		,CASE WHEN DATEPART(weekday, @d1) IN (1,7)
			OR dbo.fnIsHoliday(@d1)=1 THEN 0
			ELSE 1 END business_day_of_month	--	Else, start at 1
		,dbo.fnIsHoliday(@d1) holiday_flag
		
	UNION ALL
	
	SELECT DATEADD(d,1,date_value) date_value
		,YEAR(DATEADD(d,1,date_value))
		,MONTH(DATEADD(d,1,date_value))
		,DAY(DATEADD(d,1,date_value))
		,DATEPART(weekday,DATEADD(d,1,date_value))
		--	if weekend or holiday, do NOT increment
		,CASE WHEN DATEPART(weekday,DATEADD(d,1,date_value)) IN (1,7)
			OR dbo.fnIsHoliday(DATEADD(d,1,date_value))=1 THEN business_day_of_month
			ELSE business_day_of_month+1 END	--	else, add one to business_day_of_month
		
		,dbo.fnIsHoliday(DATEADD(d,1,date_value))
	FROM cte
	WHERE YEAR(DATEADD(d,1,date_value))=@y
	AND MONTH(DATEADD(d,1,date_value))=@m
) INSERT @tbl
SELECT date_value, year_value, month_value
	,day_value, day_of_week
	,CASE WHEN DATEPART(weekday, date_value)
		IN (1,7) OR holiday_flag=1 THEN 0
		ELSE business_day_of_month END business_day_of_month
FROM cte
RETURN

END

GO
