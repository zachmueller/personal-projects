USE FinanceDB
GO

IF OBJECT_ID('dbo.fnIsHoliday') IS NOT NULL
	DROP FUNCTION dbo.fnIsHoliday
GO


CREATE FUNCTION dbo.fnIsHoliday ( @dateInput DATE )
	RETURNS BIT
AS
/*
summary:	>
			Takes an input of a date and returns whether
			the date is a holiday. Holiday list to
			include {New Year's Day, Memorial Day,
			July 4th, Labor Day, Thanksgiving,
			Christmas Day}.
			Return value of 0 - is not a holiday
			Return value of 1 - is a holiday
Revisions:
- version 1:
		Modification: Initial script for GitHub
		Author: Zach Mueller
		Date: 2014-07-21
*/
BEGIN
	--	variables to clean up CASE statement
	DECLARE @m INT = MONTH(@dateInput)
		,@d INT = DAY(@dateInput)
		,@w INT = DATEPART(weekday, @dateInput)
		,@rtn BIT
	
	--	
	SET @rtn = (
		SELECT CASE 
			--	New Year's Day (first day of January)
			WHEN @m=1 AND @d=1 THEN 1
			--	Memorial Day (last Monday of May)
			WHEN @m=5 AND @w=2 AND @d BETWEEN 25 AND 31 THEN 1
			--	July 4th
			WHEN @m=7 AND @d=4 THEN 1
			--	Labor Day (First Monday of September)
			WHEN @m=9 AND @w=2 AND @d BETWEEN 1 AND 7 THEN 1
			--	Thanksgiving (fourth Thursday of November)
			WHEN @m=11 AND @w=5 AND @d BETWEEN 22 AND 28 THEN 1
			--	Christmas (25th of December)
			WHEN @m=12 AND @d=25 THEN 1
			ELSE 0 END
	)
	
	RETURN @rtn
END

GO
