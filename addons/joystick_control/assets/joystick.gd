tool
extends Control

#emitted when pressed state changes
signal pressed(pressed)
#emitted when force changes
signal updated(force, pressed)

const DEBUG = false
const INACTIVE_IDX = -100

#distance from center to get to maximum force
export var radius:float = 64.0 setget _set_radius
#distances from center shorter than deadzone count as zero force
export var deadzone:float = 8.0 setget _set_deadzone
#maximum distance from center that accepts touches, should be a bit larger than radius
export var proximity:float = 96.0 setget _set_proximity
export var background_texture:Texture = preload("background.png") setget _set_bg_tex
export var ball_texture:Texture = preload("ball.png") setget _set_ball_tex

#action names to use for different axis
export var action_left:String = "ui_left"	# -X Axis
export var action_right:String = "ui_right"	# +X Axis
export var action_up:String = "ui_up"		# -Y Axis
export var action_down:String = "ui_down"	# +Y Axis

#background texture
var bg:TextureRect
#handle texture
var ball:Sprite

var touches:Array = []

var currentTouchIdx = INACTIVE_IDX

# For visualising in editor
const Circle = preload("circle.gd")
var radius_v:Circle
var deadzone_v:Circle
var proximity_v:Circle

func is_pressed() -> bool:
	return touches.size() > 0

func _init():
	var container:CenterContainer = CenterContainer.new();
	container.use_top_left = true
	add_child(container)
	
	bg = TextureRect.new()
	bg.texture = background_texture
	container.add_child(bg)
	
	ball = Sprite.new()
	ball.texture = ball_texture
	container.add_child(ball)
	
	if Engine.editor_hint: _setup_visual_hints(container)

func _set_radius(value:float):
	radius = value 
	if Engine.editor_hint: radius_v.radius = radius

func _set_deadzone(value:float):
	deadzone = value
	if Engine.editor_hint: deadzone_v.radius = value

func _set_proximity(value:float):
	proximity = value
	if Engine.editor_hint: proximity_v.radius = value

func _set_bg_tex(tex:Texture):
	background_texture = tex
	bg.texture = tex

func _set_ball_tex(tex:Texture):
	ball_texture = tex
	ball.texture = tex

func _input(event):
	if event is InputEventScreenTouch or event is InputEventScreenDrag:
		_process_input(make_input_local(event))

func _process_input(event):
	var idx = _get_event_idx(event)
	var down = _is_event_down(event)
	
	if idx == INACTIVE_IDX: return
	if down == null: return
	
	var captured = touches.has(idx)
	var was_pressed = is_pressed()
	
	if  down and not captured:
		touches.append(idx)
		captured = true
	elif not down and captured:
		touches.erase(idx)
	
	var pressed = is_pressed()
	if captured:
		if pressed:
			var in_dedzone:bool = event.position.length() <= deadzone
			var shift:Vector2 = event.position.clamped(radius)
			ball.position = shift
			_update_force(Vector2.ZERO if in_dedzone else shift/radius)
		elif was_pressed:
			ball.position = Vector2.ZERO
			_update_force(Vector2.ZERO)
	
	if was_pressed != pressed: emit_signal("pressed", pressed)

func _update_force(_force):
	if _force.x <= 0:
		Input.action_press(action_left, -_force.x)
		Input.action_release(action_right)
	
	if _force.x >= 0:
		Input.action_press(action_right, _force.x)
		Input.action_release(action_left)
	
	if _force.y >= 0:
		Input.action_press(action_down, _force.y)
		Input.action_release(action_up)
	
	if _force.y <= 0:
		Input.action_press(action_up, -_force.y)
		Input.action_release(action_down)
	
	emit_signal("updated", _force, is_pressed())
	
func _get_event_idx(event):
	if event is InputEventScreenTouch or event is InputEventScreenDrag:
		return event.index
	return INACTIVE_IDX

func _is_event_down(event):
	var in_proximity:bool = event.position.length() <= proximity
	if event is InputEventScreenTouch:
		return event.pressed and in_proximity
	elif event is InputEventScreenDrag:
		return in_proximity
	return null

func _setup_visual_hints(container):
	proximity_v = Circle.new(deadzone, Color("3370ff60"))
	radius_v = Circle.new(radius, Color("334050ff"))
	deadzone_v = Circle.new(deadzone, Color("33ff5040"))
	
	proximity_v.radius = proximity
	radius_v.radius = radius
	deadzone_v.radius = deadzone
	
	container.add_child(proximity_v)
	container.add_child(radius_v)
	container.add_child(deadzone_v)
