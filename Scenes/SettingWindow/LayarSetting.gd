extends HBoxContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var LayarSettingLoaded = false

func reload():
	$FullSkren.pressed = OS.is_window_fullscreen()
	$Vsync.pressed = OS.vsync_enabled
	LayarSettingLoaded = true
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	reload()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_LayarSetting_visibility_changed():
	LayarSettingLoaded = false
	reload()
	pass # Replace with function body.


func _on_FullSkren_toggled(button_pressed):
	if LayarSettingLoaded:
		OS.set_window_fullscreen(button_pressed)
		Settingers.SettingData.DisplaySetting.FullScreen = button_pressed
	pass # Replace with function body.


func _on_Vsync_toggled(button_pressed):
	if LayarSettingLoaded:
		OS.vsync_enabled = button_pressed
		Settingers.SettingData.DisplaySetting.Vsync = button_pressed
	pass # Replace with function body.
