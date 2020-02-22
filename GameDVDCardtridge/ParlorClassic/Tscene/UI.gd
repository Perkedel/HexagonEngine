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

signal YesPlease
signal NoPlease

signal PausePlease
signal PrevWeponPlease
signal ReloadPlease
signal NextWeponPlease

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

func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		if $MasterMindUI.visible:
			if $MasterMindUI/AreYouSureDialog.visible:
				$MasterMindUI/AreYouSureDialog.hide()
				pass
			else:
				emit_signal("ExitNow")
				$MasterMindUI/AreYouSureDialog.SpawnDialogWithAppendSure("Quit Game")
				pass
			pass
		pass
	if what == MainLoop.NOTIFICATION_WM_FOCUS_OUT && OS.get_name().nocasecmp_to("windows") != 0:
		
		pass
	pass


func _on_SettingNow_pressed():
	emit_signal("SettingNow")
	pass # Replace with function body.


func _on_AboutCreditNow_pressed():
	emit_signal("AboutCreditNow")
	pass # Replace with function body.


func _on_ChangeDVDnow_pressed():
	emit_signal("ChangeDVDNow")
	$MasterMindUI/AreYouSureDialog.SpawnDialogWithAppendSure("Change DVD")
	pass # Replace with function body.

func _on_ExitNow_pressed():
	emit_signal("ExitNow")
	$MasterMindUI/AreYouSureDialog.SpawnDialogWithAppendSure("Quit Game")
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


func _on_AreYouSureDialog_NoImNotSure():
	emit_signal("NoPlease")
	pass # Replace with function body.


func _on_AreYouSureDialog_YesImSure():
	emit_signal("YesPlease")
	pass # Replace with function body.

func _on_GamePlayUI_NextWeponNow():
	emit_signal("NextWeponPlease")
	pass # Replace with function body.


func _on_GamePlayUI_PauseNow():
	emit_signal("PausePlease")
	pass # Replace with function body.


func _on_GamePlayUI_PrevWeponNow():
	emit_signal("PrevWeponPlease")
	pass # Replace with function body.


func _on_GamePlayUI_ReloadNow():
	emit_signal("ReloadPlease")
	pass # Replace with function body.
