extends VBoxContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (bool) var DisplaySettingLoaded = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$FullScreen.ForceValue(OS.is_window_fullscreen())
	DisplaySettingLoaded = true
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_FullScreen_Statement(value1):
	if DisplaySettingLoaded:
		OS.set_window_fullscreen(value1)
		pass
	# Configuration load delay needed to sync with config file if so.
	pass # Replace with function body.
