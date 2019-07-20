extends VBoxContainer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export(NodePath) var MenuAnimating
signal Press_Play_Button()
signal Hover_MoreMenu_Button()
signal Hover_Play_Button()

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_MoreButton_mouse_entered():
	emit_signal("Hover_MoreMenu_Button")
	pass # Replace with function body.


func _on_PlayButton_pressed():
	emit_signal("Press_Play_Button")
	pass # Replace with function body.

func _on_PlayButton_mouse_entered():
	emit_signal("Hover_Play_Button")
	pass # Replace with function body.
