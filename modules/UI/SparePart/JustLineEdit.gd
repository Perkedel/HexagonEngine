tool
extends HBoxContainer

export(String) var VariableTitle:String = "Just a LineEdit"
export(String) var PrefilledWith:String
export(String) var PlaceHolderer:String = "Just a Placeholder"
export(float,0,1) var PlaceHoldererAlpha = .6
export(bool) var Secret:bool = false
export(String) var SecretChar:String = "*"
export(bool) var clearButton = false
export(bool) var enableContextMenu = true
export(bool) var enableShortcutKeys = true
export(bool) var enableSelecting = true
export(bool) var BlinkCaret = true
export(float) var BlinkCaretSpeed = .65
export(int) var BlinkCaretPosition = 0
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var TextIsItNow

signal TextChanged(text_new)
signal TextEntered(text_new)
signal TextCanceled()

func _syncParameter():
	$Label.text = VariableTitle
	$LineEdit.placeholder_text = PlaceHolderer
	$LineEdit.secret = Secret
	$LineEdit.secret_character = SecretChar
	$LineEdit.clear_button_enabled = clearButton
	$LineEdit.context_menu_enabled = enableContextMenu
	$LineEdit.shortcut_keys_enabled = enableShortcutKeys
	$LineEdit.selecting_enabled = enableSelecting
	$LineEdit.caret_blink = BlinkCaret
	$LineEdit.caret_blink_speed = BlinkCaretSpeed
	$LineEdit.caret_position = BlinkCaretPosition
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	$LineEdit.text = PrefilledWith
	_syncParameter()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# _syncParameter()
	pass


func _on_LineEdit_text_changed(new_text):
	TextIsItNow = new_text
	emit_signal("TextChanged",new_text)
	pass # Replace with function body.



func _on_LineEdit_text_change_rejected():
	emit_signal("TextCanceled")
	pass # Replace with function body.


func _on_LineEdit_text_entered(new_text):
	emit_signal("TextEntered", new_text)
	pass # Replace with function body.
