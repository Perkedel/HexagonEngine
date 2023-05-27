@tool

extends Button

var WhatOrientationIsNow
enum Orientationer {Internal, Vertical, Horizontal}
@export var MenuIcons: Texture2D
@export var MenuName: String
@export var ChooseOrientation: Orientationer = Orientationer.Vertical
@export var minHoriSize: float = 400.0


@onready var Vert = $VertImaging
@onready var VertIconer = $VertImaging/TextureRect
@onready var VertNamer = $VertImaging/Label

@onready var Hori = $HoriImaging
@onready var HoriIconer = $HoriImaging/TextureRect
@onready var HoriNamer = $HoriImaging/Label

@export var SoundsSpatially: bool = true
@export var buttonSounded: AudioStream = load("res://Audio/EfekSuara/448081__breviceps__tic-toc-click.wav")
@export var buttonHovered: AudioStream = load("res://Audio/EfekSuara/166186__drminky__menu-screen-mouse-over.wav")
@onready var buttonSpk = $ButtonSpeaker
@onready var buttonSpk2d = $ButtonSpeaker2D
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func _refreshStatusoid():
	VertIconer.texture = MenuIcons
	HoriIconer.texture = MenuIcons
	
	
	VertNamer.text = MenuName
	HoriNamer.text = MenuName
	
	custom_minimum_size.x = minHoriSize
	
	buttonSpk.stream = buttonSounded
	
	match ChooseOrientation:
		Orientationer.Horizontal:
			Vert.hide()
			Hori.show()
			
			icon = null
			text = ''
			pass
		Orientationer.Vertical:
			Vert.show()
			Hori.hide()
			
			icon = null
			text = ''
			pass
		Orientationer.Internal:
			Vert.hide()
			Hori.hide()
			
			icon = MenuIcons
			text = MenuName
			pass
		_:
			pass
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	_refreshStatusoid()
	buttonSpk.stream = buttonSounded
	buttonSpk2d.stream = buttonSounded
	pass # Replace with function body.

func _pressed():
	#buttonSpk.play()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_refreshStatusoid()
	pass


func _on_MenuButton_pressed():
	if SoundsSpatially:
#		buttonSpk2d.play()
		AutoSpeaker.playSFXNow(buttonSounded)
		pass
	else:
#		buttonSpk.play()
		AutoSpeaker.playSFXNow(buttonSounded)
		pass
	pass # Replace with function body.


func _on_MenuButton_button_down():
	pass # Replace with function body.


func _on_MenuButton_button_up():
	pass # Replace with function body.


func _on_MenuButton_toggled(button_pressed):
	pass # Replace with function body.


func _on_MenuButton_mouse_entered():
	if SoundsSpatially:
		AutoSpeaker.playSFXNow(buttonHovered)
		pass
	else:
		AutoSpeaker.playSFXNow(buttonHovered)
		pass
	pass # Replace with function body.
