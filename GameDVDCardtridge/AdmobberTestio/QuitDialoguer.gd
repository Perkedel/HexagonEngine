extends VBoxContainer

export (String) var EversionNumber = "v1.0 Prototype"
export (String) var IntroText = "AdMobber Testio v1.0\nPrototype For Business Demonstration: Advertisement that compensate you for being annoying!."
enum StatusLED {LED_OFF, LED_OK, LED_FAILED}
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal ChangeDVDPls
signal ShutdownSixLittleNightmarePls

# Called when the node enters the scene tree for the first time.
func _ready():
	printDebugMessage("QuitDialoguer " + EversionNumber)
	printDebugMessage(IntroText)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func printDebugMessage(what):
	$"Stage1-BUttonQuit/VBoxContainer/DebugLabelText".bbcode_text += ("[code]"+str(what)+"[/code]\n")
	pass

func BestowQuitDialog():
	$TimerOutNoQuit.start()
	$"Stage1-BUttonQuit".hide()
	$"Stage2-SelectQuit".show()
	pass

func UnBestowQuitDialog():
	$"Stage1-BUttonQuit".show()
	$"Stage2-SelectQuit".hide()
	pass

func TransmitShutdown():
	$TimerOutNoQuit.stop()
	emit_signal("ShutdownSixLittleNightmarePls")
	UnBestowQuitDialog()
	pass

func TransmitChangeDVD():
	$TimerOutNoQuit.stop()
	emit_signal("ChangeDVDPls")
	UnBestowQuitDialog()
	pass


func _on_Button_pressed():
	BestowQuitDialog()
	pass # Replace with function body.


func _on_ButtonCHange_pressed():
	TransmitChangeDVD()
	pass # Replace with function body.


func _on_ButtonShutdown_pressed():
	TransmitShutdown()
	pass # Replace with function body.


func _on_ButtonNo_pressed():
	UnBestowQuitDialog()
	pass # Replace with function body.


func _on_TimerOutNoQuit_timeout():
	UnBestowQuitDialog()
	pass # Replace with function body.
