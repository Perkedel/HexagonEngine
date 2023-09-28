class_name FloatSmooth
extends RefCounted
## Small class for smoothly modifying a float value.
##
## Due to the spring model requiring two tracked properties ([member value] and [member _velocity]), the options for implementing it in Godot were either to return an Array/Dictionary, or to track both in a dedicated class. This is the latter.[br][br]
## To use it, create a variable — this should be persistent, don't create a new one each time.
## [codeblock]
## var my_value := FloatSmooth.new(1.0)
## [/codeblock]
## [br]
## To smoothly modify [member value], use [member move_toward]. This returns [member value] for immediate use:
## [codeblock]
## func _process(delta: float) -> void:
##     var result := my_value.move_toward(10, delta)
##     print(result)
## [/codeblock]
## [br]
## For angles (in radians), use [member move_toward_angle]. Which will correctly wrap around [member GDScript.TAU]:
## [codeblock]
## var result := my_value.move_toward_angle(deg_to_rad(90), delta)
## [/codeblock]
## [br]
## Use [member set_instant] to change [member value] without smoothing. This clears the current [member velocity]:
## [codeblock]
## my_value.set_instant(0.0)
## [/codeblock]
## [br][br]
## [b]Developed with thanks to:[/b][br]
## Lowe, T. (2004). Critically damped ease-in/ease-out smoothing. In A, Kirmse (Ed.), [i]Game programming gems 4[/i] (pp. 95-101). Charles River Media, Inc.[br]
## [i](I added overshoot prevention after seeing it in Unity's implementation, though I'm not 100% sure that overshoot is actually possible.)[/i][br][br]


## The expected time to reach the target when at maximum velocity.
var smooth_time: float

## The current value. (Used as [code]from[/code] when calling [member move_toward].)
var value: float
var _velocity: float


func _init(smooth_time: float) -> void:
	self.smooth_time = smooth_time


## Moves [member value] toward [code]target[/code] using critically damped ease-in/ease-out smoothing.
func move_toward(target: float, delta: float) -> float:
	var omega := 2.0 / smooth_time
	var x := omega * delta
	var exp := 1.0 / (1.0 + x + 0.48 * pow(x, 2) + 0.235 * pow(x, 3))
	var change := value - target
	var temp := (_velocity + omega * change) * delta

	var result := target + (change + temp) * exp

	if result > target if target > value else result < target:
		_velocity = (target - value) / delta
		value = target

		return target

	value = result
	_velocity = (_velocity - omega * temp) * exp

	return value


## Moves [member value] toward [code]target[/code] (in radians) using critically damped ease-in/ease-out smoothing.[br][br]
## Similar to [method move_toward], but behaves correctly when the angles wrap around [member GDScript.TAU].
func move_toward_angle(target: float, delta: float) -> float:
	value = target - MathEx.angle(value, target) # Set value relative to target so target is actually reached, instead of a TAU multiple from it.
	return self.move_toward(target, delta)


## Sets [member value] instantly. Clears the current [member velocity].
func set_instant(value: float) -> void:
	self.value = value
	_velocity = 0.0
