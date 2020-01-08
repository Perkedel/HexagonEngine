extends Spatial

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var Speed = 12;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	pass

func _input(event):
	if event.is_action("ui_up"):
		translate(Vector3.FORWARD*get_process_delta_time()*Speed)
		pass
	if event.is_action("ui_down"):
		translate(Vector3.BACK*get_process_delta_time()*Speed)
		pass
	
	pass
