extends PopupPanel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal SettingButton()
signal ExtrasButton()
signal ShutdownButton()

func showMe():
	popup()
	pass

func hideMe():
	hide()
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_ChangeDVDpopupOption_about_to_show():
	pass # Replace with function body.


func _on_ChangeDVDpopupOption_popup_hide():
	pass # Replace with function body.

func _on_SettingButton_button_pressed():
	emit_signal("SettingButton")
	pass # Replace with function body.


func _on_ShutdownButton_button_pressed():
	emit_signal("ShutdownButton")
	pass # Replace with function body.


func _on_ExtrasButton_button_pressed():
	emit_signal("ExtrasButton")
	pass # Replace with function body.
