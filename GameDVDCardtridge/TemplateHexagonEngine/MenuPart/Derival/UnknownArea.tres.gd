extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func FocusWhatDoYouWantNow():
	$EditMe.grab_focus()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if visible:
		if Input.is_action_just_pressed("ui_cancel"):
			LeaveTheEditorNow()
			pass
		pass
	pass

signal LeaveAndBackToMenu
func LeaveTheEditorNow():
	emit_signal("LeaveAndBackToMenu")
	pass


func _on_SaveKey_pressed():
	#Todo: save this file
	pass # Replace with function body.
