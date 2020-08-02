extends VBoxContainer

# This might sounds stupid. different script per category.
# well atleast it is separated, not emmerged into 1 like..
# Are you Coding son?

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (bool) var DisplaySettingLoaded = false

func reload():
	$FullScreen.ForceValue(OS.is_window_fullscreen())
	$Vsync.ForceValue(OS.vsync_enabled)
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
		OS.set_window_fullscreen(value1)
		Settingers.SettingData.DisplaySetting.FullScreen = value1
		#Settingers.SettingSave()
		pass
	# Configuration load delay needed to sync with config file if so.
	pass # Replace with function body.


func _on_Vsync_Statement(value1):
	if DisplaySettingLoaded:
		OS.vsync_enabled = value1
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
