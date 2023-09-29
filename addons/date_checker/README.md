## Godot-DateChecker

Autoload to check if a date is valid. `Time` singlenton methods do bad error handling in my opinion, for example `Time.get_unix_time_from_datetime_string` returns 0 if the date is invalid (but rigth format), but also if it recieves 1970-01-01. With this autoload, you can determine if the date is valid first before calling `Time` methods.

---

Methods:
- `is_year_leap`. Determines is a year is leap.
- `check_date`. Checks if a date is valid from its year, month and day as `int`s. Returns `OK` (0) if it is valid, `FAILED` (1) otherwise.
- `check_date_string`. Checks if a date is valid in ISO 8601 date string format (YYYY-MM-DD).
- `check_date_dict`. Checks if a date is valid given a `Dictionary`.

I made some discussions on Godot repositories:
- [Bad error handling](https://github.com/godotengine/godot/issues/80059#issue-1827963646).
- [Proposal](https://github.com/godotengine/godot-proposals/issues/7414#issue-1827970405) to implement what this addon does.

---

### Assets

All non-Godot icons has been downloaded form [Pictogrammers](https://pictogrammers.com/docs/general/license/).
