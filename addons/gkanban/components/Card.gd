@tool
extends PanelContainer

signal move_card_pressed(_card,_direction)
signal delete_card_pressed(_card)
signal menu_pressed(_card)
signal created(_card)
signal updated(_card)

var card = {
	"id":"",
	"title":"",
	"color":""
}


#@export (NodePath) var title_path:NodePath
@export var title_path:NodePath
@onready var title:RichTextLabel = get_node(title_path)

#@export (NodePath) var title_edit_path:NodePath
@export var title_edit_path:NodePath
@onready var title_edit:TextEdit = get_node(title_edit_path)

#@export (NodePath) var card_buttons_container_path:NodePath
@export var card_buttons_container_path:NodePath
@onready var card_buttons_container:HBoxContainer = get_node(card_buttons_container_path)

#@export (NodePath) var card_title_and_edit_container_path:NodePath
@export var card_title_and_edit_container_path:NodePath
@onready var card_title_and_edit_container:MarginContainer = get_node(card_title_and_edit_container_path)

#@export (NodePath) var card_title_container_path:NodePath
@export var card_title_container_path:NodePath
@onready var card_title_container:MarginContainer = get_node(card_title_container_path)

#@export (NodePath) var card_title_edit_container_path:NodePath
@export var card_title_edit_container_path:NodePath
@onready var card_title_edit_container:MarginContainer = get_node(card_title_edit_container_path)

#@export (NodePath) var buttons_bg_path:NodePath
@export var buttons_bg_path:NodePath
@onready var buttons_bg:PanelContainer = get_node(buttons_bg_path)

#@export (NodePath) var radio_default_btn_path:NodePath
@export var radio_default_btn_path:NodePath
@onready var radio_default_btn:CheckBox = get_node(radio_default_btn_path)

#@export (NodePath) var radio_green_btn_path:NodePath
@export var radio_green_btn_path:NodePath
@onready var radio_green_btn:CheckBox = get_node(radio_green_btn_path)

#@export (NodePath) var radio_red_btn_path:NodePath
@export var radio_red_btn_path:NodePath
@onready var radio_red_btn:CheckBox = get_node(radio_red_btn_path)

#@export (NodePath) var radio_yellow_btn_path:NodePath
@export var radio_yellow_btn_path:NodePath
@onready var radio_yellow_btn:CheckBox = get_node(radio_yellow_btn_path)

var selected :bool = false

var can_switch_to_quick_edit: bool = false

var quick_edit_on:bool = false

var card_color:= "default"

var colors:= {
	"default":{
		"normal": Color("#819aa9ff"),
		"hover": Color("#8da2afff")
	},
	"green":{
		"normal": Color("#21C063ff"),
		"hover": Color("#23D16Cff")
	},
	"red":{
		"normal": Color("#C1334Dff"),
		"hover": Color("#CC3E58ff")
	},
	"yellow":{
		"normal": Color("#2374ABff"),
		"hover": Color("#267FBAff")
	}
}


func _ready():
	edit_mode(false)

func start(_card_number):
	title.text = str("[Card #",_card_number,"]")
	card ={
		"title":title.text,
		"color":"default"
	}
	radio_default_btn.button_pressed = true
	emit_signal("created",self)

func setup_card(_card_data):
	card = _card_data
	title.text = _card_data.title
	card_color = _card_data.color

	radio_default_btn.button_pressed = true
	radio_red_btn.button_pressed = true
	radio_green_btn.button_pressed = true
	radio_yellow_btn.button_pressed = true

	match card_color:
		"default":
			radio_default_btn.button_pressed = true
		"green":

			radio_green_btn.button_pressed = true
		"red":
			radio_red_btn.button_pressed = true
		"yellow":
			radio_yellow_btn.button_pressed = true

func _process(delta):
	if selected:
#		get("custom_styles/panel").bg_color = Color("#ffdae2e7")
		get("theme_override_styles/panel").bg_color = Color("#dae2e7ff")
		card_buttons_container.modulate = Color(1,1,1,1)
#		buttons_bg.get("custom_styles/panel").bg_color = colors.get(card_color).hover
		buttons_bg.get("theme_override_styles/panel").bg_color = colors.get(card_color).hover
	else:
#		get("custom_styles/panel").bg_color = Color("#ffc9d5dc")
		get("theme_override_styles/panel").bg_color = Color("#c9d5dcff")
		card_buttons_container.modulate = Color(1,1,1,0)
#		buttons_bg.get("custom_styles/panel").bg_color = colors.get(card_color).normal
		buttons_bg.get("theme_override_styles/panel").bg_color = colors.get(card_color).normal
		#c9d5dc


func _input(event):
	if event is InputEventMouseMotion:
		var _left_boundary = global_position.x
		var _right_boundary = global_position.x + size.x
		var _top_boundary = global_position.y
		var _bottom_boundary = global_position.y + size.y

		if event.position.x > _left_boundary and event.position.x < _right_boundary and event.position.y > _top_boundary and event.position.y < _bottom_boundary:
			selected = true
		else:
			selected = false
			
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if !quick_edit_on and selected and can_switch_to_quick_edit:
				edit_mode(true)

			if !selected and quick_edit_on:
				edit_mode(false)

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ESCAPE:
			if quick_edit_on:
				edit_mode(false)

func edit_mode(_enable:bool):
	if _enable:
		quick_edit_on = true
		card_title_edit_container.show()
		card_title_container.hide()
		title_edit.text = title.text
		title_edit.select_all()
	else:
		quick_edit_on = false
		card_title_edit_container.hide()
		card_title_container.show()




func _on_EditCardButton_pressed():
	if quick_edit_on:
		return


func _on_DeleteCardButton_pressed():
	if quick_edit_on:
		return
	emit_signal("delete_card_pressed",self)


func _on_MoveCardUpButton_pressed():
	if quick_edit_on:
		return
	emit_signal("move_card_pressed",self, "up")


func _on_MoveCardDownButton_pressed():
	if quick_edit_on:
		return
	emit_signal("move_card_pressed",self, "down")


func _on_MoveCardLeftButton_pressed():
	if quick_edit_on:
		return
	emit_signal("move_card_pressed",self, "left")


func _on_MoveCardRightButton_pressed():
	if quick_edit_on:
		return
	emit_signal("move_card_pressed",self, "right")


func _on_CardMenuButton_pressed():
	if quick_edit_on:
		return
	emit_signal("menu_pressed",self)


func _on_CardTitleContainer_mouse_entered():
	can_switch_to_quick_edit = true


func _on_CardTitleContainer_mouse_exited():
	can_switch_to_quick_edit = false


func _on_CancelEditButton_pressed():
	edit_mode(false)


func _on_SaveChangesButton_pressed():
	title.text = title_edit.text
	card.title = title.text
	emit_signal("updated",self)
	edit_mode(false)

func _on_DefaultColorButton_pressed():
	card_color = "default"
	card.color = "default"
	emit_signal("updated",self)


func _on_GreenColorButton_pressed():
	card_color = "green"
	card.color = "green"
	emit_signal("updated",self)


func _on_RedColorButton_pressed():
	card_color = "red"
	card.color = "red"
	emit_signal("updated",self)


func _on_YellowColorButton_pressed():
	card_color = "yellow"
	card.color = "yellow"
	emit_signal("updated",self)
