extends VBoxContainer

export (int) var NumbersOfButton = 5
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal resetBarrelgame
signal SendButtonNumbers(HowMany)

func showAreYouSureReset():
	$AreYouSureToReset.show()
	$Sdrup.hide()
	$AreYouSureTimer.start()
	pass

func hideAreYouSureReset():
	$AreYouSureToReset.hide()
	$Sdrup.show()
	$AreYouSureTimer.stop()
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	hideAreYouSureReset()
	emit_signal("SendButtonNumbers", NumbersOfButton)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Sdrup/HowManyTheseShouldBe/Counter.text = String(NumbersOfButton)
	$AreYouSureToReset/CountLabel.text = String(NumbersOfButton)
	pass

func _on_AreYouSureTimer_timeout():
	hideAreYouSureReset()
	pass # Replace with function body.


func _on_YES_pressed():
	hideAreYouSureReset()
	emit_signal("resetBarrelgame")
	pass # Replace with function body.


func _on_NO_pressed():
	hideAreYouSureReset()
	pass # Replace with function body.


func _on_ResetButton_pressed():
	showAreYouSureReset()
	pass # Replace with function body.


func _on_SpinBox_value_changed(value):
	NumbersOfButton = value
	# not a good idea to emit signal in Process I think. cause lag maybe..
	emit_signal("SendButtonNumbers", value)
	pass # Replace with function body.
