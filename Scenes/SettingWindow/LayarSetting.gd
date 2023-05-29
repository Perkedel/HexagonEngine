extends HBoxContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var LayarSettingLoaded = false

func reload():
	$FullSkren.button_pressed = ((get_window().mode == Window.MODE_EXCLUSIVE_FULLSCREEN) or (get_window().mode == Window.MODE_FULLSCREEN))
	$Vsync.button_pressed = (DisplayServer.window_get_vsync_mode() != DisplayServer.VSYNC_DISABLED)
#	$VsyncCompositor.button_pressed = OS.vsync_via_compositor
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
		get_window().mode = Window.MODE_EXCLUSIVE_FULLSCREEN if (button_pressed) else Window.MODE_WINDOWED
		#Settingers.SettingData.DisplaySetting.FullScreen = button_pressed
		Settingers.setDisplay("FullScreen",button_pressed)
	pass # Replace with function body.


func _on_Vsync_toggled(button_pressed):
	if LayarSettingLoaded:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED if (button_pressed) else DisplayServer.VSYNC_DISABLED)
		#Settingers.SettingData.DisplaySetting.Vsync = button_pressed
		Settingers.setDisplay("Vsync",button_pressed)
	pass # Replace with function body.


func _on_VsyncCompositor_toggled(button_pressed):
	if LayarSettingLoaded:
#		OS.vsync_via_compositor = button_pressed
		Settingers.setDisplay("Vsync_via_compositor",button_pressed)
	pass # Replace with function body.
