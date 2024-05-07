extends AnimatableBody3D
class_name YetDoor

enum DoorOpensMode{Left,Right,Up,Down,Front,Back,AngleBackLeft,AngleBackRight,AngleBackUp,AngleBackDown,AngleFrontLeft,AngleFrontRight,AngleFrontUp,AngleFrontDown,}
var DoorOpensMeaning:Array[String] = ['left','right','up','down','front','back','angleBackLeft','angleBackRight','angleBackUp','angleBackDown','angleFrontLeft','angleFrontRight','angleFrontUp','angleFrontDown']

## is door open?
@export var state:bool = false
#	set(value):
#		if state:
#			close()
#		else:
#			open()
## How does the door opens to
@export var doorOpensTo:DoorOpensMode = DoorOpensMode.Left

@onready var collider = $CollisionShape3D
@onready var shapes = $Shapes
@onready var shapesList = shapes.get_children()

# Called when the node enters the scene tree for the first time.
func _ready():
	if state:
		open()
	else:
		close()
	pass # Replace with function body.

func playAnimation(named: StringName = "", custom_blend: float = -1, custom_speed: float = 1.0, from_end: bool = false
):
	for i in shapesList:
		if i.visible:
			if i.has_method('playAnimation'):
				i.call('playAnimation', named,custom_blend,custom_speed,from_end)
				pass
			else:
				printerr('Shape ' + i.name + ' wielded by ' + self.name + ' Lacks `playAnimation` function!!!')
				pass
			pass
		pass
	pass

func playAnimationBackwards(named="",custom_blend:float = -1):
	for i in shapesList:
		if i.visible:
			if i.has_method('playAnimationBackwards'):
				i.call('playAnimationBackwards', named,custom_blend)
				pass
			else:
				printerr('Shape ' + i.name + ' wielded by ' + self.name + ' Lacks `playAnimationBackwards` function!!!')
				pass
			pass
		pass
	pass

func open():
	playAnimation('open_'+DoorOpensMeaning[doorOpensTo])
	collider.disabled = true
	state = true
	pass

func close():
	playAnimationBackwards('open_'+DoorOpensMeaning[doorOpensTo])
	collider.disabled = false
	state = false
	pass

func toggle():
	if state:
		close()
	else:
		open()
	pass

func setTo(value:bool):
	state = value
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
