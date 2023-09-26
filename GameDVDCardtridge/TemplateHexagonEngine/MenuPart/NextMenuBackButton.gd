@tool
extends Button
class_name NextMenuBackButton

@export var textSay:String = 'Back'
@export var actionIcon:String = 'ui_cancel'
@export var UseTheme:bool = false
@export var iconImage:Texture = preload("res://Sprites/KembaliButton.png")

@onready var daLabel:Label = $HBoxContainer/Label
@onready var daIcon:TextureRect = $HBoxContainer/Icon
@onready var daControllerIcon:ControllerTextureRect = $HBoxContainer/controller_icons_textureRect

var isReady:bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	isReady = true
	_refreshLook()
	pass # Replace with function body.

func _refreshLook():
	if isReady:
		daLabel.text = textSay
		daControllerIcon.path = actionIcon
		daIcon.texture = iconImage
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _notification(what: int) -> void:
	match(what):
		NOTIFICATION_VISIBILITY_CHANGED:
			if visible:
				_refreshLook()
				pass
		_:
			pass
