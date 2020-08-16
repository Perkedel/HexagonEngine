tool

extends HBoxContainer

export(Texture) var BackButtonIcon = load("res://Sprites/KembaliButton.png")
export(bool) var showBackButton = false
export(String) var TitleBar:String = "Darn Label"
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal letsGoBack

func _sync_parameter():
	$BackBacking.icon = BackButtonIcon
	$BackBacking.visible = showBackButton
	$Label.text = TitleBar
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	_sync_parameter()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_sync_parameter()
	pass


func _on_BackBacking_pressed():
	emit_signal("letsGoBack")
	pass # Replace with function body.
