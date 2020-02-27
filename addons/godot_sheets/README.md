# Godot-Sheets
Google Sheets to a Godot Node

**Note**: Currently all values in the object are just strings, you can use Godot's built in `str2var` function however to change that string into a variable. Say if you put `Vector2(1,1)` in a cell, you can use `str2var` to turn that into an actual `Vector2`

## Commands
All Commands must be in the first column, but they can be in any row

**FIELDNAMES** _:ROWS_ _:COLS_
This command sets up the variable names that will appear on your sheet object.

*Sheet1*
```
FIELDNAMES|var1|var2|var3
obj1      |val1|val2|val3
obj2      |val4|val5|val6
```
will create an object like this
```js
Sheet1 = {
  "obj1":{
    "var1":"val1",
    "var2":"val2",
    "var3":"val3"
  },
  "obj2":{
    "var1":"val4",
    "var2":"val5",
    "var3":"val6"
  }
}
```
You can also make it use columns like this
```
FIELDNAMES:COLS|obj1|obj2
var1           |val1|val4
var2           |val2|val5
var3           |val3|val6
```
which would produce the same object


**IGNORE**
this ignores the row. This is useful if you need to add comments or headers

**SUBSHEET** _:TITLE_
This allows you to create another sheet object in the same sheet, useful if you want to separate your data into chunks in one sheet so they can share the same field names and style.
