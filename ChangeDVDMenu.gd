extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal ChangeDVD_Exec()
signal Shutdown_Exec()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

signal ShutdownButton

signal ShutdownHexagonEngineNow
func _on_JustWorkingAreYouSure_confirmed():
	emit_signal("ShutdownHexagonEngineNow")
	pass # Replace with function body.

func ShowMeSelf():
	show()
	$JustWorkingMenu.InitMeSelf()
	pass

func _on_JustWorkingMenu_PressShutDown():
	$JustWorkingAreYouSure.popup()
	pass # Replace with function body.

signal ItemClickEnter(Index)
func _on_JustWorkingMenu_ItemClickEnter(Index):
	emit_signal("ItemClickEnter",Index)
	print("Item Click Enter No. " + String(Index))
	pass # Replace with function body.

func _input(event):
	if visible:
		if event.is_action_pressed("ui_cancel"):
			print("Quito Introduce")
			$JustWorkingAreYouSure.popup()
			pass
		pass
	pass

func _notification(what): #add heurestic of changeDVD menu! check visible of change dvd menu
	if visible:
		if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
			if $JustWorkingAreYouSure.visible:
				$JustWorkingAreYouSure.hide()
				pass
			else:
				$JustWorkingAreYouSure.popup()
				pass
			pass
		if what == MainLoop.NOTIFICATION_WM_FOCUS_OUT && OS.get_name().nocasecmp_to("windows") != 0:
			pass
		pass
	pass
