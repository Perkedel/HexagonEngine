tool
extends BaseSlot2D
class_name OutputSlot2D, "res://addons/io_method/classes/output_slot_2d/output_slot_2d.png"

export var activation_signal:String = "activate_output"

var data:Dictionary = { "connected_inputs":[] }
var deffered_actvation:Dictionary = {"value":false, "force_update":false, "has_triggered":true}
var is_active:bool = true
var persitent_data:bool = false
var sent_initial_signal:bool = false

#Temporarilly holds the connected inputs after being removed from the tree.
#The connections are readded to the meta holder if the scene is changed.
var connected_inputs_hold:Array = [] 

func _enter_tree() -> void:
	if connected_inputs_hold != []:
		connect_slots( connected_inputs_hold )
	else:
		update_wires_from_meta()
	connected_inputs_hold = []

func _exit_tree() -> void:
	if is_inside_tree():
		connected_inputs_hold = []
		for slot in data["connected_inputs"]:
			connected_inputs_hold.append( slot )
		disconnect_all_slots()
		update()

func _exited_tree() -> void:
	if has_data_holder(): #Returns meta data if meta holder is still reachable
		connect_slots( connected_inputs_hold )
		update()

func _notification( what:int ) -> void:
	match what:
		NOTIFICATION_PATH_CHANGED:
			#Called whenever a parent's name is changed
			
			#Update input meta data
			for input in data["connected_inputs"]:
				var input_data:Dictionary = input.data
				input.set_data( input_data )
	
			#Remove old data reference from data-holder
			remove_meta_reference( old_holder_path )
	
			#Update meta data
			set_data( data )

func _get_slot_type() -> String:
	return "output"

func _on_dragged( dragged_slot ) -> void:
	var path_to_dragged:NodePath = get_path_to(dragged_slot)
	#Self dragged
	if dragged_slot == self:
		for wire_name in custom_wires:
			var wire_info:Dictionary = custom_wires[wire_name]
			if "begin" in wire_info and "end" in wire_info:
				var wire_position_changed:bool = re_rig_wire( wire_name )

func _ready() -> void:
	._ready()
	set_z_index(1)
	add_to_group( "output_slot_2d" )
	
	if Engine.editor_hint:
		if not is_connected( "script_changed", self, "_on_script_changed" ):
			connect( "script_changed", self, "_on_script_changed" )
		if not is_connected( "tree_exited", self, "_exited_tree" ):
			connect( "tree_exited", self, "_exited_tree" )
	else:
		get_node("../../../").connect( activation_signal, self, "set_is_active" )
	
func _on_input_slot_dragged( dragged_slot ) -> void:
	var slot_path:String = get_data_holder().get_path_to(dragged_slot)
	if not slot_path in custom_wires:
		var slot = get_data_holder().get_node( slot_path )
		custom_wires[ slot_path ] = {"begin":get_global_position(), "end":slot.get_global_position(), "begin_node":get_data_holder().get_path_to(self), "end_node":slot_path}
	
	var input_position_changed:bool = re_rig_wire( slot_path )
	if input_position_changed:
		update()
	
func _on_script_changed() -> void:
	update_wires_from_meta()
	call_deferred( "update" )
	
func connect_slot( slot ) -> void:
	if slot != null:
		var slot_path:String = get_data_holder().get_path_to(slot)

		#Set in data
		data = get_data()
		if not "connected_inputs" in data:
			data["connected_inputs"] = []
		if not data["connected_inputs"].has( slot ):
			data["connected_inputs"].append( slot )
		slot._on_connected_to_output( self )
		
		set_data( data )
		clear_junk_meta()
		
		#Draw wire
		custom_wires[ slot_path ] = {"begin":get_global_position(), "end":slot.get_global_position(), "begin_node":get_data_holder().get_path_to(self), "end_node":slot_path}
		if slot.is_connected( "dragged", self, "_on_input_slot_dragged" ):
			slot.disconnect( "dragged", self, "_on_input_slot_dragged" )
		slot.connect( "dragged", self, "_on_input_slot_dragged" )
		generate_wire( slot_path, false )
	
func connect_slots( slots:Array ) -> void:
	for slot in slots:
		connect_slot( slot )
	
func disconnect_all_slots() -> void:
	for slot in data["connected_inputs"]:
		disconnect_slot( slot )
	custom_wires = {}
	data["connected_inputs"] = []
	set_data( data )
		
	
func disconnect_slot( slot ) -> void:
	if slot != null and data["connected_inputs"].has( slot ):
		data["connected_inputs"].erase( slot )
		set_data( data )
		#Draw wire
		var slot_path:NodePath = get_data_holder().get_path_to(slot)
		custom_wires.erase( slot_path )
		#Signals
		if slot.is_connected( "dragged", self, "_on_input_slot_dragged" ):
			slot.disconnect( "dragged", self, "_on_input_slot_dragged" )
		
		slot._on_disconnected_from_output( self )
	
func draw_slot() -> void:
	draw_circle( Vector2(0,0), 8, Color(1,0,0) )
	draw_circle( Vector2(0,0), 6, Color(0,0,0) )
	draw_circle( Vector2(0,0), 3, Color(1,0,0) )
	
func get_data() -> Dictionary:
	"""
	Get the meta data
	"""
	var owner_node:Node = get_data_holder()
	if is_instance_valid(owner_node) and owner_node.has_meta( "io_" + _get_slot_type() ):
		var data_library:Dictionary = owner_node.get_meta( "io_" + _get_slot_type() )
		if get_data_key() in data_library:
			#Convert paths to nodes
			var slot_data:Dictionary = { "connected_inputs":[] }
			if not "connected_inputs" in data_library[get_data_key()]:
				data_library[get_data_key()]["connected_inputs"] = []
			for path in data_library[get_data_key()]["connected_inputs"]:
				var node:Node = meta_path_to_node(path)
				if node != null:
					slot_data["connected_inputs"].append( node )
			#Return
			return slot_data
		
	return {}
	
func get_hub() -> Node:
	"""
	As oppose to git hub.
	"""
	return get_node("../../")
	
func has_connections() -> bool:
	return data["connected_inputs"] != []
	
func set_data( value:Dictionary ) -> void:
	var owner_node:Node = get_data_holder()
	if is_instance_valid(owner_node):
		if not owner_node.has_meta( "io_" + _get_slot_type() ):
			owner_node.set_meta( "io_" + _get_slot_type(), {} )
		var data_library:Dictionary = owner_node.get_meta( "io_" + _get_slot_type() )
		#Set connected inputs
		if not get_data_key() in data_library:
			data_library[get_data_key()] = {}
		data_library[get_data_key()]["connected_inputs"] = []
		for node in data["connected_inputs"]:
			if node.has_connections():
				data_library[get_data_key()]["connected_inputs"].append( node_to_meta_path(node) )
				
		#Confirm meta data
		owner_node.set_meta( "io_" + _get_slot_type(), data_library )
		clear_junk_meta()
	
func set_has_updated_in_frame( value:bool ) -> void:
	has_updated_in_frame = value
	
	if not value and not deffered_actvation.has_triggered:
		deffered_actvation.has_triggered = true
		set_is_active( deffered_actvation.value, deffered_actvation.force_update )
		has_updated_in_frame = true
	
func set_is_active( value:float, force_update:bool=false ) -> void:
	#Delay update if has already updated this frame
	if has_updated_in_frame:
		deffered_actvation.value = value
		deffered_actvation.force_update = force_update
		deffered_actvation.has_triggered = false
		return
	
	if force_update and sent_initial_signal:
		sent_initial_signal = true
		return
	else:
		sent_initial_signal = true
		
	if abs(value) >= .5:
		is_active = true
		if not highlight_wires:
			highlight_wires = true
			update()
	else:
		is_active = false
		if highlight_wires:
			highlight_wires = false
			update()
		
	var connected_input_slots:Array = data["connected_inputs"]
	set_has_updated_in_frame( true ) #Must be set before trigger signal is called, otherwise will never be set
	for slot in connected_input_slots:
#		if get_data_holder().has_node(slot_path):
		value = max(value, -1)
		value = min(value, 1)
		if slot != null:
			slot.trigger_signal( is_active, value, force_update )
			
func update_wires_from_meta() -> void:
	"""
	Redraw wires using data from IOHub2D's parent
	"""
	data = get_data()
	custom_wires = {}
	if not "connected_inputs" in data:
		data["connected_inputs"] = []
	connect_slots( data["connected_inputs"] )
	update()
