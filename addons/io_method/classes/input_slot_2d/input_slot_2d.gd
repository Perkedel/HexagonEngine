tool
extends BaseSlot2D
class_name InputSlot2D, "res://addons/io_method/classes/input_slot_2d/input_slot_2d.png"

export var activation_method:String = "_on_signal_wire_activated"

var connected_outputs:Array = []
var data:Dictionary = { "connected_outputs":[] }
var deffered_signal:Dictionary = {"signal_active":false, "signal_power":1, "force_update":false, "has_triggered":true}
var is_active:bool = false
var is_connected:bool = false
var power:float = 0

#Temporarilly holds the connected outputs after being removed from the tree.
#The connections are readded to the meta holder if the scene is changed.
var connected_outputs_hold:Array = [] 

func _enter_tree() -> void:
	#Read connections after being readded from deletion
	for output in connected_outputs_hold:
		if is_instance_valid(output):
			output.connect_slot( self )
	connected_outputs_hold = []
		
func _exit_tree() -> void:
	if is_inside_tree():
		data = get_data()
		if not "connected_outputs" in data:
			data["connected_outputs"] = []
			
		for output in data["connected_outputs"]:
			if output != null:
				connected_outputs_hold.append( output )
				output.disconnect_slot( self )
				output.update()
				
		data["connected_outputs"] = []
		set_data( data )

func _get_slot_type() -> String:
	return "input"

func _on_connected_to_output( connected_slot:Node ) -> void:
	for output in connected_outputs:
		output.disconnect_from_input_slot( self )
	data["connected_outputs"] = []
	data["connected_outputs"].append( connected_slot )
	
	set_data(data)

func _notification( what:int ) -> void:
	match what:
		NOTIFICATION_PATH_CHANGED:
			#Called whenever a parent's name is changed
			
			#Update input meta data
			for output in data["connected_outputs"]:
				var output_data:Dictionary = output.data
				output.set_data( output_data )
	
			#Remove old data reference from data-holder
			remove_meta_reference( old_holder_path )
	
			#Update meta data
			set_data( data )

func _on_disconnected_from_output( connected_slot:Node ) -> void:
	if "connected_outputs" in data and connected_slot in data["connected_outputs"]:
		data["connected_outputs"].erase( connected_slot )
		
	set_data(data)

func _ready() -> void:
	add_to_group( "input_slot_2d" )
#	update_wires_from_meta()
	
	if not Engine.editor_hint:
		yield( get_tree(), "idle_frame" )
		trigger_signal( false, 0, true )

func draw_slot():
	draw_circle( Vector2(0,0), 8, Color(0,0,1) )
	draw_circle( Vector2(0,0), 6, Color(0,0,0) )

func get_data() -> Dictionary:
	"""
	Get the meta data
	"""
	var owner_node:Node = get_data_holder()
	prints( 10 )
	if is_instance_valid(owner_node) and owner_node.has_meta( "io_" + _get_slot_type() ):
		var data_library:Dictionary = owner_node.get_meta( "io_" + _get_slot_type() )
		prints( 11, get_data_key() )
		if get_data_key() in data_library:
			#Convert paths to nodes
			var slot_data:Dictionary = { "connected_outputs":[] }
			if not "connected_outputs" in data_library[get_data_key()]:
				data_library[get_data_key()]["connected_outputs"] = []
			prints( 12 )
			for path in data_library[get_data_key()]["connected_outputs"]:
				var node:Node = meta_path_to_node(path)
				if node != null:
					slot_data["connected_outputs"].append( node )
			#Return
			return slot_data
		
	return {}

func has_connections() -> bool:
	return data["connected_outputs"] != []

func trigger_signal( signal_active:bool, signal_power:float, force_update:bool=false ) -> void:
	#Delay update if has already updated this frame
	if has_updated_in_frame:
		deffered_signal.signal_active = signal_active
		deffered_signal.signal_power = signal_power
		deffered_signal.force_update = force_update
		deffered_signal.has_triggered = false
		return

	is_connected = true
	if get_node("../../../") != null:
		#Upddate only when different
		if signal_power != power or is_active != signal_active or force_update:
			is_active = signal_active
			power = signal_power
			if get_node("../../../").has_method( activation_method ):
				set_has_updated_in_frame( true ) #Must be set before method is called, otherwise will never be set
				get_node("../../../").call(activation_method, is_active, power)
			else:
				printerr("Method " + activation_method + " does not exist in " + get_node("../../../").get_name() + ".")

func set_data( value:Dictionary ) -> void:
	var owner_node:Node = get_data_holder()
	if is_instance_valid(owner_node):
		#Get data library
		if not owner_node.has_meta( "io_" + _get_slot_type() ):
			owner_node.set_meta( "io_" + _get_slot_type(), {} )
		var data_library:Dictionary = owner_node.get_meta( "io_" + _get_slot_type() )
		#Inititialize data in libarary
		if not get_data_key() in data_library:
			data_library[get_data_key()] = {}
		data_library[get_data_key()]["connected_outputs"] = []
		#Set data
		for node in data["connected_outputs"]:
			if node.has_connections():
				data_library[get_data_key()]["connected_outputs"].append( node_to_meta_path(node) )
				
		#Confirm meta data
		owner_node.set_meta( "io_" + _get_slot_type(), data_library )
		clear_junk_meta()

func set_has_updated_in_frame( value:bool ) -> void:
	has_updated_in_frame = value

	if not has_updated_in_frame and not deffered_signal.has_triggered:
		trigger_signal( deffered_signal.signal_active, deffered_signal.signal_power, deffered_signal.force_update )
		deffered_signal.has_triggered = true
		set_has_updated_in_frame( true )
