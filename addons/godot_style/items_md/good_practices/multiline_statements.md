- When you have particularly long `if` statements or nested ternary expressions, wrap them over multiple lines to improve readability.  

- 2 indent levels should be used instead of one.  

- Use parentheses `()` or backslashes `\` (parentheses are favored since they make for easier refactoring)  

- Keywords - `else`, `and`/`or` - should be placed at the beginning of the line continuation, not at the end of the previous line.  

```
var angle_degrees := 135
var quadrant: String = (
		"northeast" if angle_degrees <= 90
		else "southeast" if angle_degrees <= 180
		else "southwest" if angle_degrees <= 270
		else "northwest"
)

var position := Vector2(250, 350)
if (
		position.x > 200 and position.x < 400
		and position.y > 300 and position.y < 400
):
	print("position is valid")
```
