#extends Control
extends Popup

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
@export var isSpawned: bool = false
@export var extraButton:bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	isSpawned = visible
	if extraButton:
		$Panel/VBoxContainer/ButtonConfirmations/Yes2.show()
	pass

func SpawnDialog():
	#set_visible(true)
	print($Panel/VBoxContainer/Label.text)
	popup_centered_clamped(Vector2(.2,.2))
	$Panel/VBoxContainer/ButtonConfirmations/No.grab_focus()
	pass

func SpawnDialogWithText(TextDialog):
	$Panel/VBoxContainer/Label.text = TextDialog
	SpawnDialog()
	pass

func SpawnDialogWithAppendSure(TextAppend):
	var Formating = "Are you sure to %s ?"
	# https://docs.godotengine.org/en/3.1/getting_started/scripting/gdscript/gdscript_format_string.html
	$Panel/VBoxContainer/Label.text = Formating % [TextAppend]
	SpawnDialog()
	pass

signal YesImSure(mode:int)
func YesConfirm(mode:int = 0):
	print("Yes I'm sure!")
	emit_signal("YesImSure",mode)
	YesOrNo(true,mode)
	set_visible(false)
	pass

signal NoImNotSure
func NoCancel():
	print("No I'm not sure!")
	emit_signal("NoImNotSure")
	YesOrNo(false)
	set_visible(false)
	pass

signal YesOrNoo(which:bool,at:int)
func YesOrNo(which:bool=false,at:int=0):
	emit_signal("YesOrNoo",which,at)
	pass


func _on_Yes_pressed():
	YesConfirm(0)
	pass # Replace with function body.


func _on_No_pressed():
	NoCancel()
	pass # Replace with function body.


func _on_yes_2_pressed() -> void:
	YesConfirm(2)
	pass # Replace with function body.
