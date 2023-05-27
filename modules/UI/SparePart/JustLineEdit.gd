@tool
extends HBoxContainer

@export var VariableTitle: String:String = "Just a LineEdit"
@export var PrefilledWith: String:String
@export var PlaceHolderer: String:String = "Just a Placeholder"
@export var PlaceHoldererAlpha = .6 # (float,0,1)
@export var Secret: bool:bool = false
@export var SecretChar: String:String = "*"
@export var clearButton: bool = false
@export var enableContextMenu: bool = true
@export var enableShortcutKeys: bool = true
@export var enableSelecting: bool = true
@export var BlinkCaret: bool = true
@export var BlinkCaretSpeed: float = .65
@export var BlinkCaretPosition: int = 0
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
	$LineEdit.caret_blink_interval = BlinkCaretSpeed
	$LineEdit.caret_column = BlinkCaretPosition
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
