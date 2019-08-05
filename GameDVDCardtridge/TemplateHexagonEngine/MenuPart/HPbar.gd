extends HBoxContainer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(float, 0,100) var HPvalue = 100
var HPformat
export(Color) var HPcolor = Color.blue

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _draw():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$TextureProgressLeft.value = HPvalue
	# https://docs.godotengine.org/en/3.1/getting_started/scripting/gdscript/gdscript_format_string.html
	HPformat = "%.0f" % round(HPvalue)
	$LabelPanel/HPLabel.text = HPformat
	$TextureProgressRight.value = HPvalue
	
	if HPvalue >= 0 and HPvalue < 25:
		HPcolor = Color.red
		pass
	elif HPvalue >= 25 and HPvalue < 50:
		HPcolor = Color.orange
		pass
	elif HPvalue >= 50 and HPvalue < 75:
		HPcolor = Color.yellow
		pass
	elif HPvalue >= 75 and HPvalue < 100:
		HPcolor = Color.green
		pass
	elif HPvalue >= 100:
		HPcolor = Color.blue
		pass
	
	$TextureProgressLeft.tint_progress = HPcolor
	$LabelPanel.self_modulate = HPcolor
	$TextureProgressRight.tint_progress = HPcolor
	pass
