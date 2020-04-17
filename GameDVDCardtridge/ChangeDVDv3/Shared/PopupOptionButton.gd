tool
extends Button

export(String) var ButtonLabel = "Menu Button"
export(Texture) var ButtonIcon = load("res://Sprites/MavrickleIcon.png")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$HBoxContainer/IconBenefactor/Icon.texture = ButtonIcon
	$HBoxContainer/Label.text = ButtonLabel
	pass

signal button_pressed()
func _on_PopupOptionButton_pressed():
	emit_signal("button_pressed")
	pass # Replace with function body.
