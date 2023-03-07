tool
extends EditorPlugin

var _menu = MenuButton.new()
var help
var about


func _enter_tree():
    add_custom_type("Balloon Text", "Control", preload("balloon.gd"), preload("assets/icon_balloon.png"))
    pass

func _exit_tree():
	remove_custom_type("Balloon Text")
	pass


func item_selected(id):
	var p = get_editor_interface().get_editor_viewport()
	match id:
		1:
			OS.shell_open("https://codepen.io/bitetti/full/MQmQqO/")
		2:
			OS.shell_open("https://codepen.io/bitetti/full/bLWLve/")
	

func handles(obj):
	if not obj.get('BALLOON_TRUE'):
		if _menu.is_inside_tree():
			_menu.get_parent().remove_child(_menu)
		return false
	
	if _menu.is_inside_tree():
		return true
		
	_menu.text = 'Balloon'
	var p = _menu.get_popup()
	if p.get_item_count()==0:
		_menu.icon = preload("res://addons/balloon/assets/icon_balloon.png")
		p.add_item(tr("Help"), 1)
		p.add_separator()
		p.add_item(tr("About"), 2)
		p.connect("id_pressed", self, "item_selected")
	add_control_to_container( CONTAINER_CANVAS_EDITOR_MENU, _menu )
	
	return true