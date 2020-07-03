extends AcceptDialog


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal ChangeDVDNow()
signal ShutdownNow()
signal OkButton()

# Called when the node enters the scene tree for the first time.
func _ready():
	#add_cancel("Close")
	add_button("Change DVD", false, "ChangeDVD")
	add_button("Shutdown", false, "Shutdown")
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if visible:
		if Input.is_action_just_pressed("Tunda"):
			pass
		pass
	pass


func _on_PauseMenu_custom_action(action):
	match action:
		"ChangeDVD":
			emit_signal("ChangeDVDNow")
			pass
		"Shutdown":
			emit_signal("ShutdownNow")
			pass
		_:
			pass
	pass # Replace with function body.


func _on_PauseMenu_confirmed():
	emit_signal("OkButton")
	pass # Replace with function body.
