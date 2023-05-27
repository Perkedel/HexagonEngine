extends VBoxContainer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

@export var MenuAnimating: NodePath
signal Press_Play_Button()
signal Hover_MoreMenu_Button()
signal Hover_Play_Button()
@export var MoreMenuSelectFirst: NodePath

# Called when the node enters the scene tree for the first time.
func _ready():
	#$PlayButton/LightHighSelected.hide()
	$PlayButton.grab_focus()
	if Input.is_action_just_pressed("ui_down"):
		#get_parent().get_parent().get_node("MoreMenu/HBoxContainer" + MoreMenuSelectFirst).call("RedirectFocus")
		pass
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func FocusPlayButtonNow():
	$PlayButton.grab_focus()
	pass


func _on_MoreButton_mouse_entered():
	emit_signal("Hover_MoreMenu_Button")
	pass # Replace with function body.


func _on_PlayButton_pressed():
	emit_signal("Press_Play_Button")
	pass # Replace with function body.

func _on_PlayButton_mouse_entered():
	emit_signal("Hover_Play_Button")
	#$PlayButton/LightHighSelected.show()
	pass # Replace with function body.


func _on_PlayButton_mouse_exited():
	#$PlayButton/LightHighSelected.hide()
	pass # Replace with function body.


func _on_PlayButton_focus_entered():
	#$PlayButton/LightHighSelected.show()
	pass # Replace with function body.


func _on_PlayButton_focus_exited():
	#$PlayButton/LightHighSelected.hide()
	pass # Replace with function body.
