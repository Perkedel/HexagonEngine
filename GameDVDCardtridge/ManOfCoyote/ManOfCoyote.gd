extends Node

# Follow This tutorial
# https://youtu.be/1I3z5ZpBOmc Miziziziz
# Miziziz low poly cat thing https://opengameart.org/content/low-poly-cat-thing
# Script https://pastebin.com/7bVvEJwp
# Artindi's advise for Coyote time https://youtu.be/LeaaKRufdMc

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal ChangeDVD_Exec()
signal Shutdown_Exec()


# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("Tunda"):
		if not Singletoner.isGamePaused:
			$CanvasLayer/UIsoWe/PauseMenu.popup()
			Singletoner.PauseGameNow()
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			$CanvasLayer/UIsoWe/PauseMenu.hide()
			Singletoner.ResumeGameNow()
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			pass
		pass
	pass

func _input(event):
	
	pass


func _on_PauseMenu_ChangeDVDNow():
	emit_signal("ChangeDVD_Exec")
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	pass # Replace with function body.


func _on_PauseMenu_ShutdownNow():
	emit_signal("Shutdown_Exec")
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	pass # Replace with function body.


func _on_PauseMenu_OkButton():
#	Singletoner.ResumeGameNow()
#	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pass # Replace with function body.


func _on_PauseMenu_popup_hide():
	Singletoner.ResumeGameNow()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pass # Replace with function body.
