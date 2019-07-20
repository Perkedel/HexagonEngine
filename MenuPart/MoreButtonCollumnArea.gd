extends CenterContainer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(String) var GoToMenuSceneOf
signal Button_Pressingated()
signal Button_Hoverated()
signal Button_Dehoverated()

# Called when the node enters the scene tree for the first time.
func _ready():
	#$Button/HoverLights.hide()
	#$Button/HoverLights.visible = false
	#$Button/HoverLights.set_process(false)
	$MoreButtonAnimationing.play("InitMoreButton")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Button_pressed():
	emit_signal("Button_Pressingated")
	pass # Replace with function body.

func _on_Button_mouse_entered():
	emit_signal("Button_Hoverated")
	#$Button/HoverLights.show();
	#$Button/HoverLights.visible = true
	#$Button/HoverLights.set_process(true)
	$MoreButtonAnimationing.play("BeingHovered")
	pass # Replace with function body.

func _on_Button_mouse_exited():
	emit_signal("Button_Dehoverated")
	#$Button/HoverLights.hide()
	#$Button/HoverLights.visible =false
	#$Button/HoverLights.set_process(false)
	$MoreButtonAnimationing.play("BeingDehovered")
	pass # Replace with function body.
