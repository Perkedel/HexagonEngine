extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func SpawnDialog():
	set_visible(true)
	$Panel/VBoxContainer/ButtonConfirmations/No.grab_focus()
	pass

func SpawnDialogWithText(var TextDialog):
	$Panel/VBoxContainer/Label.text = TextDialog
	SpawnDialog()
	pass

func SpawnDialogWithAppendSure(TextAppend):
	var Formating = "Are you sure to %s ?"
	# https://docs.godotengine.org/en/3.1/getting_started/scripting/gdscript/gdscript_format_string.html
	$Panel/VBoxContainer/Label.text = Formating % [TextAppend]
	SpawnDialog()
	pass

signal YesImSure
func YesConfirm():
	emit_signal("YesImSure")
	set_visible(false)
	pass

signal NoImNotSure
func NoCancel():
	emit_signal("NoImNotSure")
	set_visible(false)
	pass


func _on_Yes_pressed():
	YesConfirm()
	pass # Replace with function body.


func _on_No_pressed():
	NoCancel()
	pass # Replace with function body.
