@tool

extends Button

var WhatOrientationIsNow
enum Orientationer {Internal, Vertical, Horizontal}
enum TextHorizontalAlignMode {Left, Center, Right, Fill}
enum TextVerticalAlignMode {Top, Center, Bottom, Fill}

#@export_subgroup('Properties')
@export var MenuIcons: Texture2D
@export var MenuName: String = 'MenuButton'
@export var CommandName:String = MenuName.to_pascal_case()

@export_group('Properties')
@export_multiline var ArgumentSay:String = ''
@export var IgnoreTheCommand:bool = false
@export var ChooseOrientation: Orientationer = Orientationer.Vertical
@export var minHoriSize: float = 400.0
@export var fontSizer:int = 32
@export var textHorizontalAlignment:TextHorizontalAlignMode = TextHorizontalAlignMode.Left
@export var textVerticalAlignment:TextVerticalAlignMode = TextVerticalAlignMode.Top

#@export_subgroup('Nodes')
@onready var Vert = $VertImaging
@onready var VertIconer = $VertImaging/TextureRect
@onready var VertNamer = $VertImaging/Label

@onready var Hori = $HoriImaging
@onready var HoriIconer = $HoriImaging/TextureRect
@onready var HoriNamer = $HoriImaging/Label

@export_subgroup('Sounds')
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
	
	VertNamer.horizontal_alignment = textHorizontalAlignment
	VertNamer.vertical_alignment = textVerticalAlignment
	HoriNamer.horizontal_alignment = textHorizontalAlignment
	HoriNamer.vertical_alignment = textVerticalAlignment
	
	custom_minimum_size.x = minHoriSize
	
	buttonSpk.stream = buttonSounded
	
	VertNamer.add_theme_font_size_override("font_size",fontSizer)
	HoriNamer.add_theme_font_size_override("font_size",fontSizer)
	
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
#	_refreshStatusoid()
	pass

func soundTheButton(ofWhich:String = ''):
	var toPlay:AudioStream
	match(ofWhich):
		'hover':
			toPlay = buttonHovered
			pass
		'press':
			toPlay = buttonSounded
			pass
		_:
			toPlay = buttonHovered
			pass
	
	if SoundsSpatially:
		AutoSpeaker.playSFXNow(toPlay)
		pass
	else:
		AutoSpeaker.playSFXNow(toPlay)
		pass
	pass

func _on_MenuButton_pressed():
#	if SoundsSpatially:
##		buttonSpk2d.play()
#		AutoSpeaker.playSFXNow(buttonSounded)
#		pass
#	else:
##		buttonSpk.play()
#		AutoSpeaker.playSFXNow(buttonSounded)
#		pass
	soundTheButton('press')
	
	Singletoner.pressAMenuButton(CommandName,ArgumentSay)
	pass # Replace with function body.


func _on_MenuButton_button_down():
	pass # Replace with function body.


func _on_MenuButton_button_up():
	pass # Replace with function body.


func _on_MenuButton_toggled(button_pressed):
	pass # Replace with function body.


func _on_MenuButton_mouse_entered():
	soundTheButton('hovered')
	pass # Replace with function body.

func _notification(what: int) -> void:
	match(what):
		NOTIFICATION_DRAW:
			_refreshStatusoid()
		NOTIFICATION_EDITOR_PRE_SAVE:
			_refreshStatusoid()
		_:
			pass
	pass


func _on_focus_entered() -> void:
	soundTheButton('hover')
	pass # Replace with function body.
