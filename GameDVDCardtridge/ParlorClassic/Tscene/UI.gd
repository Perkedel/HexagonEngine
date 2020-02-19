extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal SettingNow
signal AboutCreditNow
signal ChangeDVDNow

signal PlayNow
signal InstructionNow
signal ExitNow

signal ShopButton

func BehaveStartGaming():
	$MasterMindUI/MainMenu.hide()
	$MasterMindUI/GamePlayUI.show()
	$MasterMindUI/NextMenu.hide()
	pass

func BehaveStopGaming():
	$MasterMindUI/MainMenu.show()
	$MasterMindUI/GamePlayUI.hide()
	$MasterMindUI/NextMenu.hide()
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_SettingNow_pressed():
	emit_signal("SettingNow")
	pass # Replace with function body.


func _on_AboutCreditNow_pressed():
	emit_signal("AboutCreditNow")
	pass # Replace with function body.


func _on_ChangeDVDnow_pressed():
	emit_signal("ChangeDVDNow")
	pass # Replace with function body.


func _on_PlayNow_pressed():
	emit_signal("PlayNow")
	pass # Replace with function body.


func _on_InstructionNow_pressed():
	emit_signal("InstructionNow")
	pass # Replace with function body.


func _on_ShopButton_pressed():
	emit_signal("ShopButton")
	pass # Replace with function body.
