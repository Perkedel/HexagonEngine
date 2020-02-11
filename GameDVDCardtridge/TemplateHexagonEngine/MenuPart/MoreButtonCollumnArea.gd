extends CenterContainer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(String) var callTheFunction
export(String) var GoToMenuSceneOf
export(String) var ButtonLabelName = "Label"
signal Button_Pressingated()
signal Button_Hoverated()
signal Button_Dehoverated()
export(NodePath) var FocusNextMenuCollumn
export(NodePath) var FocusPrevMenuCollumn

# Called when the node enters the scene tree for the first time.
func _ready():
	#$Button/HoverLights.hide()
	#$Button/HoverLights.visible = false
	#$Button/HoverLights.set_process(false)
	$MoreButtonAnimationing.play("InitMoreButton")
	
	pass # Replace with function body.

func GoToNextMenuOf():
	get_node("../../../../../").get_tree().change_scene(GoToMenuSceneOf)
	pass

func QuitButton():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#$Button.text = ButtonLabelName
	$Button/VBoxContainer/Label.text = ButtonLabelName
	if _on_MoreButtonCollumnArea_focus_entered():

		pass
	if Input.is_action_just_pressed("ui_left"):

		pass
	if Input.is_action_just_pressed("ui_right"):

		pass
	pass

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

func FocusMeThisButton():
	$Button.grab_focus()
	pass

func ResetAnimatione():
	$MoreButtonAnimationing.play("InitMoreButton")
	pass

func _on_MoreButtonCollumnArea_focus_entered():
	pass # Replace with function body.


func _on_MoreButtonCollumnArea_focus_exited():
	pass # Replace with function body.

# https://docs.godotengine.org/en/3.1/tutorials/gui/custom_gui_controls.html
func _draw():
	if has_focus():
		#draw_selected()
		pass
	else:
		#draw_normal()
		pass
	pass

func _on_Button_gui_input(event):

	if Input.is_action_just_pressed("ui_left"):

		pass
	if Input.is_action_just_pressed("ui_right"):
		pass
	pass # Replace with function body.


func _on_Button_focus_entered():
	#$MoreButtonAnimationing.play("BeingHovered")
	#$Button.grab_focus()
	pass # Replace with function body.


func _on_Button_focus_exited():
	#$MoreButtonAnimationing.play("BeingDehovered")
	pass # Replace with function body.
