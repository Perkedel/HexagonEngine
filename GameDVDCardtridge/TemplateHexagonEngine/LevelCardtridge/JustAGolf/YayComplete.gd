tool

extends PopupDialog


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal BackMenuButton
signal ResetButton
signal NextLevelButton
export var ContentWindow = "Yay, you've completed just golf! congrats"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func PopThisDialogWith(var sayWha:String):
	setDialogText(sayWha)
	popup()
	pass

func setDialogText(var sayWha:String):
	ContentWindow = sayWha
	#$Contains/Say.text = sayWha
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Contains/Say.text = ContentWindow
	pass


func _on_BackMenu_pressed():
	emit_signal("BackMenuButton")
	hide()
	pass # Replace with function body.


func _on_Reset_pressed():
	emit_signal("ResetButton")
	hide()
	pass # Replace with function body.


func _on_NextLevel_pressed():
	emit_signal("NextLevelButton")
	hide()
	pass # Replace with function body.
