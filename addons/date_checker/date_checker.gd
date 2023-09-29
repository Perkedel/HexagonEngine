extends Node


## Autoload to check dates validity.


## Determines is a year is leap.
func is_year_leap(year: int) -> bool:
	if (year % 4 == 0 and year % 100 != 0) or year % 400 == 0:
		return true
	return false


## Checks if a date is valid from its year, month and day as [code]int[/code]s.
## Returns [param OK] (0) if it is valid, [param FAILED] (1) otherwise.
func check_date(year: int, month: int, day: int) -> int:
	if month < 1 or month > 12:
		return FAILED
	if day < 1 or day > 31:
		return FAILED
	# 30 days months: April, June, September, November
	if month in [4, 6, 9, 11]:
		if day == 31:
			return FAILED
	# February
	elif month == 2:
		if is_year_leap(year):
			if day > 29:
				return FAILED
		else:
			if day > 28:
				return FAILED
	# 31 days months: January, March, May, July, Augost, October, December
	return OK


## Checks if a date is valid in ISO 8601 date string format (YYYY-MM-DD).
func check_date_string(date_string: String) -> int:
	var year: int
	var month: int
	var day: int
	var splitted: PackedStringArray = date_string.split("-")
	year = int(splitted[0])
	month = int(splitted[1])
	day = int(splitted[2])
	return check_date(year, month, day)


## Checks if a date is valid given a [code]Dictionary[/code].
func check_date_dict(date_dict: Dictionary) -> int:
	var year: int = date_dict["year"]
	var month: int = date_dict["month"]
	var day: int = date_dict["day"]
	return check_date(year, month, day)
