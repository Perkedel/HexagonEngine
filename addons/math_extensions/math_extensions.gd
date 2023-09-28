class_name MathEx
## Additional math helper functions and behaviors for manipulating angles and floats.


## Returns the shortest angle between [code]from[/code] and [code]to[/code] (in radians).
static func angle(from: float, to: float) -> float:
	var angle := fposmod(to - from, TAU)
	return angle if angle < PI else angle - TAU


## Moves [code]from[/code] toward [code]to[/code] (in radians) by the [code]delta[/code] value.[br][br]
## Similar to [method @GlobalScope.move_toward], but behaves correctly when the angles wrap around [member GDScript.TAU].
static func move_toward_angle(from: float, to: float, delta: float) -> float:
	var angle := angle(from, to)
	return to if absf(angle) <= delta else from + delta * signf(angle)
