tool
extends EditorPlugin

enum EDIT_ACTIONS {
	NONE
	MOVE
	CONNECT_WIRE_FROM_OUTPUT
}

enum EDIT_MODES {
	NONE
	EDIT_SLOTS
	EDIT_WIRES
	CONNECT_SIGNAL
	REMOVE_SIGNAL
}

enum EDITING_NODES {
	
}

enum SLOT_TYPES {
	OUTPUT
	INPUT
}

var edit_action:int = 0
var edit_mode:int = EDIT_MODES.EDIT_WIRES
var is_drawing_slots:bool = false setget set_is_drawing_slots
var is_editing:bool = true setget set_is_editing
var is_mouse_over_slot:bool = false
var placing_slot_type = SLOT_TYPES.OUTPUT
var io_method:Array = []

var selected_node:Node
var selected_response_wire:Node
var selected_slot:Node

#Tool bar
var editing_mode_button:Node# = preload("res://addons/io_method/scenes/edit_mode_button/edit_mode_button.tscn").instance()
var editing_wires_button:Node# = preload("res://addons/io_method/scenes/edit_wires_button/edit_wires_button.tscn").instance()
var toggle_placing_slot_type:Node# = preload("res://addons/io_method/scenes/toggle_placing_slot_type/toggle_placing_slot_type.tscn").instance()

#Nodes
var popup_menu

func _enter_tree():
	connect( "scene_changed", self, "_on_scene_changed" )
	
	editing_mode_button = preload("res://addons/io_method/scenes/edit_mode_button/edit_mode_button.tscn").instance()
	add_control_to_container( CONTAINER_CANVAS_EDITOR_MENU, editing_mode_button )
#	editing_mode_button.connect( "toggled", self, "set_is_editing" )
	editing_mode_button.hide()
	
	editing_wires_button = preload("res://addons/io_method/scenes/edit_wires_button/edit_wires_button.tscn").instance()
	add_control_to_container( CONTAINER_CANVAS_EDITOR_MENU, editing_wires_button )
	editing_wires_button.connect( "toggled", self, "set_is_editing_wires" )
	editing_wires_button.show()
	
	toggle_placing_slot_type = preload("res://addons/io_method/scenes/toggle_placing_slot_type/toggle_placing_slot_type.tscn").instance()
	add_control_to_container( CONTAINER_CANVAS_EDITOR_MENU, toggle_placing_slot_type )
#	toggle_placing_slot_type.connect( "toggled", self, "_on_toggle_placing_slot_type" )
	toggle_placing_slot_type.hide()

func _exit_tree():
	if editing_mode_button != null:
		remove_control_from_container( CONTAINER_CANVAS_EDITOR_MENU, editing_mode_button )
		editing_mode_button.queue_free()
	
	if editing_wires_button != null:
		remove_control_from_container( CONTAINER_CANVAS_EDITOR_MENU, editing_wires_button )
		editing_wires_button.queue_free()
	
	if toggle_placing_slot_type != null:
		remove_control_from_container( CONTAINER_CANVAS_EDITOR_MENU, toggle_placing_slot_type )
		toggle_placing_slot_type.queue_free()
	
func _on_scene_changed( scene ) -> void:
	call_deferred( "set_is_drawing_slots", is_drawing_slots ) #Update slot drawing
	
func _on_toggle_placing_slot_type( toggled_on:bool ) -> void:
	if not toggled_on:
		placing_slot_type = SLOT_TYPES.OUTPUT
	else:
		placing_slot_type = SLOT_TYPES.INPUT
	
func _set_input_activation_method( method:String ) -> void:
	if selected_slot != null and selected_slot is InputSlot2D:
		selected_slot.activation_method = method
		
func _set_output_activation_signal( activation_signal:String ) -> void:
	if selected_slot != null and selected_slot is OutputSlot2D:
		selected_slot.activation_signal = activation_signal
	
func get_mouse_position_in_canvas() -> Vector2:
	var io_hubs:Array  = get_editor_interface().get_edited_scene_root().get_tree().get_nodes_in_group("io_hub_2d")
	if len(io_hubs) > 0:
		return io_hubs[0].get_global_mouse_position()
		
	return Vector2(0,0)
	
func forward_canvas_gui_input( event:InputEvent ) -> bool:
	var io_hubs:Array  = get_editor_interface().get_edited_scene_root().get_tree().get_nodes_in_group("io_hub_2d")
	if len(io_hubs) > 0 and selected_node != null:
		
		match edit_mode:
			EDIT_MODES.EDIT_WIRES:
				return handle_input_wire_mode( event )
					
			EDIT_MODES.EDIT_SLOTS:
				return handle_input_edit_mode( event )
			
	return false
	
func handle_input_edit_mode( event:InputEvent ) -> bool:
	"""
	Handle inputs for editing slots
	"""
	if event is InputEventMouseButton:
		var mouse_pos:Vector2 = get_mouse_position_in_canvas()
		
		#Get clicked slots
		var io_hubs = get_editor_interface().get_edited_scene_root().get_tree().get_nodes_in_group("io_hub_2d")
		var slot_within_range
		if io_hubs == []:
			return false
		for io_hub_2d in io_hubs:
			var clicked_slot = io_hub_2d.get_slot_within_range( mouse_pos )
			if clicked_slot != null:
				slot_within_range = clicked_slot
				break
		
		match edit_action:
			EDIT_ACTIONS.NONE:
				#Double click to edit slot
				if event.get_button_index() == BUTTON_LEFT and event.is_doubleclick():
					if slot_within_range is OutputSlot2D:
						open_edit_output_menu( slot_within_range )
					if slot_within_range is InputSlot2D:
						open_edit_input_menu( slot_within_range )
					return true
					
				#Single Pressed
				elif event.is_pressed():
					#Left clicked
					if event.get_button_index() == BUTTON_LEFT:
						
						#Add output slot
						if slot_within_range == null:
							if placing_slot_type == SLOT_TYPES.OUTPUT:
								selected_node.add_output( mouse_pos.snapped(Vector2(10,10)) )
							elif placing_slot_type == SLOT_TYPES.INPUT:
								selected_node.add_input( mouse_pos.snapped(Vector2(10,10)) )
						#Begin moving
						else:
							selected_slot = slot_within_range
							edit_action = EDIT_ACTIONS.MOVE
								
						return true
							
					#Right clicked
					if event.get_button_index() == BUTTON_RIGHT:
						#Delete output slot
						if slot_within_range != null:
							selected_node.remove_slot( slot_within_range )
						return true
			
			EDIT_ACTIONS.MOVE:
				#Left button
				if event.get_button_index() == BUTTON_LEFT:
					#Left button not clicked
					if not event.is_pressed():
						edit_action = EDIT_ACTIONS.NONE
						return true
				
	#Mouse motion
	elif event is InputEventMouseMotion:
		var mouse_pos:Vector2 = get_mouse_position_in_canvas()
		
		match edit_action:
			EDIT_ACTIONS.MOVE:
				#Drag slot
				if is_instance_valid(selected_slot):
					var move_to_pos:Vector2 = Vector2(0,0)
					move_to_pos.x = mouse_pos.x
					move_to_pos.y = mouse_pos.y
					selected_slot.set_global_position( move_to_pos.snapped(Vector2(10,10)) )
					selected_slot.call_deferred( "emit_signal", "dragged", selected_slot )
				else:
					edit_action = EDIT_ACTIONS.NONE
				return true
		
	return false
	
func handle_input_wire_mode( event:InputEvent ) -> bool:
	if event is InputEventMouseButton:
		var mouse_pos:Vector2 = get_mouse_position_in_canvas()
		
		#Get clicked slots
		var io_hubs = get_editor_interface().get_edited_scene_root().get_tree().get_nodes_in_group("io_hub_2d")
		var slot_within_range
		if io_hubs == []:
			return false
		for io_hub_2d in io_hubs:
			var clicked_slot = io_hub_2d.get_slot_within_range( mouse_pos )
			if clicked_slot != null:
				slot_within_range = clicked_slot
				break
								
		match edit_action:
			EDIT_ACTIONS.NONE:
				#Single Pressed
				if event.is_pressed():
					#Left click
					if event.get_button_index() == BUTTON_LEFT:
						#Start connecting
						if slot_within_range is OutputSlot2D:
							selected_slot = slot_within_range
							edit_action = EDIT_ACTIONS.CONNECT_WIRE_FROM_OUTPUT
						return true
						
					#Right click
					if event.get_button_index() == BUTTON_RIGHT:
						#Removee connections from output
						if slot_within_range is OutputSlot2D:
							slot_within_range.disconnect_all_slots()
							slot_within_range.update()
						#Removee connections from input
						if slot_within_range is InputSlot2D:
							for output in slot_within_range.connected_outputs:
								output.disconnect_slot( slot_within_range )
								output.update()
							slot_within_range.connected_outputs = []
						return true
					
			EDIT_ACTIONS.CONNECT_WIRE_FROM_OUTPUT:
				#Single Pressed
				if event.is_pressed():
					#Left click
					if event.get_button_index() == BUTTON_LEFT:
						#Connect output wire to clicked InputSlot2D
						if slot_within_range is InputSlot2D:
							selected_slot.connect_slot( slot_within_range )
							if "plugin_dragging" in selected_slot.custom_wires:
								selected_slot.custom_wires.erase("plugin_dragging")
							selected_slot.update()
							
						return true
							
					#Right click
					if event.get_button_index() == BUTTON_RIGHT:
						edit_action = EDIT_ACTIONS.NONE
						if "plugin_dragging" in selected_slot.custom_wires:
								selected_slot.custom_wires.erase("plugin_dragging")
								selected_slot.update()
								
						return true
					
	#Mouse motion
	elif event is InputEventMouseMotion:
		var mouse_pos:Vector2 = get_mouse_position_in_canvas()
		
		match edit_action:
			EDIT_ACTIONS.CONNECT_WIRE_FROM_OUTPUT:
				if selected_slot is OutputSlot2D:
					selected_slot.custom_wires["plugin_dragging"] = {"begin":selected_slot.get_global_position(), "end":mouse_pos}
					selected_slot.generate_wire( "plugin_dragging" )
					
	return false
	
func handles( object ) -> bool:
	#Allow slot edit mode
	if object is IOHub2D:
		on_focus_entered_io_hub_2d( object )
	elif selected_node is IOHub2D:
		on_focus_left_io_hub_2d( selected_node )
	if object.has_method( "get_children" ):
		selected_node = object
	return true
	
func on_focus_entered_io_hub_2d( io_hub:IOHub2D ) -> void:
	selected_node = io_hub
	edit_mode = EDIT_MODES.EDIT_SLOTS
	#Show/hide buttons
	if editing_wires_button != null:
		editing_wires_button.hide()
		editing_wires_button.set_pressed(false)
	if editing_mode_button != null:
		editing_mode_button.show()
	if toggle_placing_slot_type != null:
		toggle_placing_slot_type.show()
	#Disallow slot edit mode
	#Show slots
	set_is_drawing_slots( true )
		
func on_focus_left_io_hub_2d( selected_node:Node ) -> void:
	selected_node = selected_node
	edit_mode = EDIT_MODES.NONE
	#Show/hide buttons
	if editing_wires_button != null:
		editing_wires_button.show()
	if editing_mode_button != null:
		editing_mode_button.hide()
	if toggle_placing_slot_type != null:
		toggle_placing_slot_type.hide()
	#Disallow slot edit mode
	#Hide slots
	if edit_mode != EDITING_NODES.EDIT_WIRES:
		set_is_drawing_slots( false )
	
func on_focus_entered_response_wire_parent( parent:Node, response_wire:IOHub2D ) -> void:
	selected_node = parent
	selected_response_wire = response_wire
	for slot in selected_node.get_tree().get_nodes_in_group("slot_2d"):
		slot.is_drawing = true
		
	editing_mode_button.show()
	toggle_placing_slot_type.show()
	
func on_focus_left_response_wire_parent( selected_node:Node ) -> void:
#	if selected_response_wire == null:
	for output in selected_node.get_tree().get_nodes_in_group("slot_2d"):
		output.is_drawing = false
		
	editing_mode_button.hide()
	toggle_placing_slot_type.hide()
	
	selected_response_wire = null
	
func open_edit_input_menu( editing_input_slot ) -> void:
	var editor_control:Control = get_editor_interface().get_base_control()
	var edior_size = editor_control.get_size()
	
	popup_menu = load("res://addons/io_method/scenes/edit_input_popup/edit_input_popup.tscn").instance()
	var popup_pos:Vector2 = Vector2(0,0)
	popup_pos.x = (edior_size.x/2)-(popup_menu.get_size().x/2)
	popup_pos.y = (edior_size.y/2)-(popup_menu.get_size().y/2)
	popup_menu.set_position( popup_pos )
	popup_menu.connect( "method_changed", self, "_set_input_activation_method" )
	popup_menu.editing_input = editing_input_slot
	
	editor_control.add_child( popup_menu )
	popup_menu.popup()
	
func open_edit_output_menu( editing_output_slot ) -> void:
	var editor_control:Control = get_editor_interface().get_base_control()
	var edior_size = editor_control.get_size()
	
	popup_menu = load("res://addons/io_method/scenes/edit_output_popup/edit_output_popup.tscn").instance()
	var popup_pos:Vector2 = Vector2(0,0)
	popup_pos.x = (edior_size.x/2)-(popup_menu.get_size().x/2)
	popup_pos.y = (edior_size.y/2)-(popup_menu.get_size().y/2)
	popup_menu.set_position( popup_pos )
	popup_menu.connect( "signal_changed", self, "_set_output_activation_signal" )
	popup_menu.editing_output = editing_output_slot
	
	editor_control.add_child( popup_menu )
	popup_menu.popup()
	
func set_is_drawing_slots( value:bool ) -> void:
	is_drawing_slots = value
#	if selected_node.get_tree() != null:
#		selected_node.get_tree().set_group( "slot_2d", "is_drawing", is_drawing_slots )
	
func set_is_editing( value:bool ) -> void:
	is_editing = value
	edit_mode = 0
	
func set_is_editing_wires( value:bool ) -> void:
	edit_mode = EDIT_MODES.NONE
	#Show slots
	if value:
		edit_mode = EDIT_MODES.EDIT_WIRES
		set_is_drawing_slots( true )
#		get_editor_interface().get_edited_scene_root().get_tree().call_group( "slot_2d", "show" )
	#Hide slots
	elif not selected_node is IOHub2D:
		set_is_drawing_slots( false )
#		get_editor_interface().get_edited_scene_root().get_tree().call_group( "slot_2d", "hide" )
	
	
	
	
	
	
