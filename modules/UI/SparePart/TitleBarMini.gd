@tool

extends HBoxContainer

const fellbackBackButtonImage:Texture2D = preload("res://Sprites/KembaliButton.png")

@export var BackButtonIcon: Texture2D = fellbackBackButtonImage: set = set_back_button_icon
@export var showBackButton: bool = false: set = set_show_back_button
@export var TitleBar: String:String = "Darn Label": set = set_title_bar
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal letsGoBack

func set_back_button_icon(withTexture:Texture2D = fellbackBackButtonImage):
	BackButtonIcon = withTexture
	_sync_parameter()

func set_show_back_button(into:bool):
	showBackButton = into
	_sync_parameter()

func set_title_bar(withSay:String):
	TitleBar = withSay
	_sync_parameter()

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
#	_sync_parameter() # don't put in process! the update status spinner will keep spinning & it's not funny!
	pass

func _on_BackBacking_pressed():
	emit_signal("letsGoBack")
	pass # Replace with function body.
