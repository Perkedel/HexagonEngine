extends HBoxContainer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
@export_subgroup('Parameter')
@export_range(0,100) var HPvalue:float = 100 # (float, 0,100)
@export var HPcolor: Color = Color.BLUE
@export var useRawValue:bool = false
@export var HPRawValue:float = 100
var HPformat:String

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _redrawHPBar():
	$TextureProgressLeft.value = HPvalue
	# https://docs.godotengine.org/en/3.1/getting_started/scripting/gdscript/gdscript_format_string.html
	HPformat = "%.0f" % round(HPvalue) if not useRawValue else String.num(round(HPRawValue))
	$LabelPanel/HPLabel.text = HPformat
	$TextureProgressRight.value = HPvalue
	
	if HPvalue >= 0 and HPvalue < 25:
		HPcolor = Color.RED
		pass
	elif HPvalue >= 25 and HPvalue < 50:
		HPcolor = Color.ORANGE
		pass
	elif HPvalue >= 50 and HPvalue < 75:
		HPcolor = Color.YELLOW
		pass
	elif HPvalue >= 75 and HPvalue < 100:
		HPcolor = Color.GREEN
		pass
	elif HPvalue >= 100:
		HPcolor = Color.BLUE
		pass
	
	$TextureProgressLeft.tint_progress = HPcolor
	$LabelPanel.self_modulate = HPcolor
	$TextureProgressRight.tint_progress = HPcolor
	pass

func _draw():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_redrawHPBar()
	pass
