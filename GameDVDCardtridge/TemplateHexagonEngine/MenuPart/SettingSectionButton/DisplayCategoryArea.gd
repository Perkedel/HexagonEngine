extends VBoxContainer

# This might sounds stupid. different script per category.
# well atleast it is separated, not emmerged into 1 like..
# Are you Coding son?

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
@export (bool) var DisplaySettingLoaded = false

func reload():
	$FullScreen.ForceValue(((get_window().mode == Window.MODE_EXCLUSIVE_FULLSCREEN) or (get_window().mode == Window.MODE_FULLSCREEN)))
	$Vsync.ForceValue((DisplayServer.window_get_vsync_mode() != DisplayServer.VSYNC_DISABLED))
	DisplaySettingLoaded = true
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	reload()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_FullScreen_Statement(value1):
	if DisplaySettingLoaded:
		get_window().mode = Window.MODE_EXCLUSIVE_FULLSCREEN if (value1) else Window.MODE_WINDOWED
		Settingers.setDisplay("FullScreen",value1)
		#Settingers.SettingData.DisplaySetting.FullScreen = value1
		#Settingers.SettingSave()
		pass
	# Configuration load delay needed to sync with config file if so.
	pass # Replace with function body.


func _on_Vsync_Statement(value1):
	if DisplaySettingLoaded:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED if (value1) else DisplayServer.VSYNC_DISABLED)
		Settingers.setDisplay("Vsync",value1)
		Settingers.SettingData.DisplaySetting.Vsync = value1
		#Settingers.SettingSave()
		pass
	pass # Replace with function body.


func _on_FullScreen_visibility_changed():
	#DisplaySettingLoaded = false
	pass # Replace with function body.


func _on_Vsync_visibility_changed():
	#DisplaySettingLoaded = false
	#reload()
	pass # Replace with function body.


func _on_DisplayCategoryArea_visibility_changed():
	DisplaySettingLoaded = false
	reload()
	pass # Replace with function body.
