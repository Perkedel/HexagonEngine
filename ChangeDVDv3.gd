extends Node


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


func _on_ChangeDVDScaffold_PressMenuButton():
	$CanvasLayer/ChangeDVDpopupOption.showMe()
	pass # Replace with function body.


func _on_ChangeDVDpopupOption_ExtrasButton():
	pass # Replace with function body.


func _on_ChangeDVDpopupOption_SettingButton():
	pass # Replace with function body.

func _on_ChangeDVDpopupOption_ShutdownButton():
	$CanvasLayer/AreYouSureDialog.SpawnDialogWithAppendSure('Shutdown Hexagon Engine')
	pass # Replace with function body.


func _on_AreYouSureDialog_NoImNotSure():
	pass # Replace with function body.

func _on_AreYouSureDialog_YesImSure():
	emit_signal("Shutdown_Exec")
	pass # Replace with function body.
