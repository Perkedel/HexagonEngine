tool
extends IOMethod2D
class_name BaseSlot2D, "res://addons/io_method/classes/base_slot_2d/base_slot_2d.png"

signal dragged( dragging_slot )

var custom_wires:Dictionary = {} setget set_custom_wires
var global_drawer:GlobalDrawer
var has_updated_in_frame:bool = false setget set_has_updated_in_frame #A flag to remember if this slot has been updated in this frame
var highlight_wires:bool = false
var old_holder_path:String = ""
var wire_generation:Dictionary = {}

export var is_drawing:bool = true setget set_is_drawing

func _draw() -> void:
	if is_drawing:
		draw_set_transform( Vector2(0,0), -get_global_rotation(), Vector2(1/get_global_scale().x,1/get_global_scale().y) )
		draw_slot()

		for wire_name in custom_wires:
			draw_wire( wire_name )

func _enter_tree() -> void:
	old_holder_path = node_to_meta_path( self )
		
func _get_slot_type() -> String:
	return "base"
		
func _notification( what:int ) -> void:
	match what:
		NOTIFICATION_PATH_CHANGED:
			old_holder_path = node_to_meta_path( self )
		NOTIFICATION_TRANSFORM_CHANGED:
			emit_signal( "dragged", self )
			update()
		
func _on_dragged( dragging_slot ) -> void:
	pass

func _on_idle_frame() -> void:
	set_has_updated_in_frame( false )

func _ready():
	add_to_group( "slot_2d" )
	set_notify_transform( true )
	
	if Engine.editor_hint:
		if not is_connected( "dragged", self, "_on_dragged" ):
			connect( "dragged", self, "_on_dragged" )
	else:
		is_drawing = true
		if not get_tree().is_connected( "idle_frame", self, "_on_idle_frame" ):
			get_tree().connect( "idle_frame", self, "_on_idle_frame" )
			
	old_holder_path = node_to_meta_path( self )
	
func clear_junk_meta() -> void:
	var owner_node:Node = get_data_holder()
	
	#Clear output data
	if owner_node.has_meta( "io_output" ):
		var output_meta = owner_node.get_meta( "io_output" )
		if output_meta != null:
			for key in output_meta:
				var data:Dictionary = output_meta[key]
				if len(data["connected_inputs"]) == 0:
					output_meta.erase( key )
			if len(output_meta) == 0:
				output_meta = null
			owner_node.set_meta( "io_output", output_meta )
	
	#Clear input data
	if owner_node.has_meta( "io_input" ):
		var input_meta = owner_node.get_meta( "io_input" )
		if input_meta != null:
			for key in input_meta:
				var data:Dictionary = input_meta[key]
				if len(data["connected_outputs"]) == 0:
					input_meta.erase( key )
			if len(input_meta) == 0:
				input_meta = null
			owner_node.set_meta( "io_input", input_meta )
	
func create_wire_curve( begin:Vector2, end:Vector2 ) -> PoolVector2Array: #Overridable
	begin = Vector2(begin.x-get_global_position().x, begin.y-get_global_position().y)
	end = Vector2(end.x-get_global_position().x, end.y-get_global_position().y)

	var curve:Curve2D = Curve2D.new() 
	var point_diff:Vector2 = Vector2(end.x-begin.x, end.y-begin.y )
	curve.set_bake_interval( 16 )#point_diff.length()/20 )

	#Begin point weight
	var begin_weight:Vector2 = Vector2(0,0)
	if abs(point_diff.x) > abs(point_diff.y):
		begin_weight.x = point_diff.x/4
	else:
		begin_weight.y = point_diff.y/4
	#Add begin point to curve
	curve.add_point( begin, begin_weight, begin_weight )

	#End point weight
	var end_weight:Vector2 = Vector2(0,0)
	if abs(point_diff.x) > abs(point_diff.y):
		end_weight.x = -point_diff.x/4
	else:
		end_weight.y = -point_diff.y/4
	#Add end point to curve
	curve.add_point( end, end_weight, end_weight )

	return curve.get_baked_points()

func delete_data() -> void:
	"""
	Removes the connected inputs meta data from the ResponseWire's parent's owner
	"""
	var owner_node:Node = get_data_holder()
	if is_instance_valid(owner_node):
		var data:Dictionary = owner_node.get_data()
		if get_data_key() in data:
			data[get_data_key()].queue_free()
			owner_node.set_data( data )

func draw_slot() -> void: #Overridable
	draw_circle( Vector2(0,0), 8, Color(1,1,1) )
	
func draw_wire( wire_name ) -> void: #Overridable
	if wire_name in custom_wires:
		var wire_info:Dictionary = custom_wires[wire_name]
		if wire_name in wire_generation:
			
			var should_draw:bool = true
			if "begin_node" in wire_info:
				if not get_data_holder().has_node(wire_info["begin_node"]):
					should_draw = false
			if "end_node" in wire_info:
				if not get_data_holder().has_node(wire_info["end_node"]):
					should_draw = false
				
			if should_draw:
				if highlight_wires:
					draw_polyline( wire_generation[wire_name], Color(1,1,1,.75), 3 )
				else:
					draw_polyline( wire_generation[wire_name], Color(1,0,0,.5), 2 )
				#Draw dot at end of line
				var dot_pos:Vector2 = wire_info["end"]
				dot_pos.x -= get_global_position().x
				dot_pos.y -= get_global_position().y
				draw_circle( dot_pos, 3, Color(1,0,0) )
	
func generate_wire( wire_name, render_on_completion:bool=true ) -> void:
	if wire_name in custom_wires:
		var wire_info:Dictionary = custom_wires[wire_name]
		wire_generation[wire_name] = create_wire_curve( wire_info["begin"], wire_info["end"] )
		if render_on_completion:
			update()
			
func get_data() -> Dictionary:
	"""
	Get the meta data related slots
	"""
	var owner_node:Node = get_data_holder()
	if is_instance_valid(owner_node) and owner_node.has_meta( "io_" + _get_slot_type() ):
		var type_data:Dictionary = owner_node.get_meta( "io_" + _get_slot_type() )
		if get_data_key() in type_data:
			return type_data[get_data_key()] 
		
	return {}
			
func get_data_holder() -> Node:
	"""
	Returns the node that holds the meta data for this OutputSlot
	"""
	var ret:Node = get_node("../../../../")
	return ret
		
func get_data_key() -> String:
	"""
	Get the meta name for the inputed variable
	"""
	var parent_owner = get_data_holder()
	if is_instance_valid( parent_owner ):
		return str( parent_owner.get_path_to(self) )
	return ""
	
func has_data_holder() -> bool:
	return has_node( "../../../../" )
	
func meta_path_to_node( path:String ) -> Node:
	if get_data_holder().has_node(path):
		return get_data_holder().get_node( path )
	else:
		return null
	
func node_to_meta_path( node:Node ) -> String:
	if has_data_holder():
		return String(get_data_holder().get_path_to( node ))
	else:
		return ""
	
func re_rig_wire( wire_path ) -> bool:
	"""
	Rigs wire points to wire's begin_node and end_nodes (Returns if changed)
	"""
	var wire_info:Dictionary = custom_wires[wire_path]
	var is_changed:bool = false
	if "begin" in wire_info and "begin_node" in wire_info:
		if get_data_holder().has_node( wire_info["begin_node"] ):
			var begin_node:Node = get_data_holder().get_node( wire_info["begin_node"] )
			if begin_node != null and wire_info["begin"] != begin_node.get_global_position():
				wire_info["begin"] = begin_node.get_global_position()
				is_changed = true
	if "end" in wire_info and "end_node" in wire_info:
		if get_data_holder().has_node( wire_info["end_node"] ):
			var end_node:Node = get_data_holder().get_node(wire_info["end_node"])
			if end_node != null and wire_info["end"] != end_node.get_global_position():
				wire_info["end"] = end_node.get_global_position()
				is_changed = true

	set_custom_wires( custom_wires )
	#Generate new wire
	generate_wire( wire_path )
			
	return is_changed
	
func remove_meta_reference( reference_path:String, slot_key:String="" ) -> void:
	"""
	Removes the reference_path from the data-holder's slot data
	"""
	
	if slot_key == "":
		slot_key = "io_" + _get_slot_type()
		
	if get_data_holder().has_meta( slot_key ):
		var meta_data:Dictionary = get_data_holder().get_meta( slot_key )
		if reference_path in meta_data:
			meta_data.erase( reference_path )
		get_data_holder().set_meta( slot_key, meta_data )
	
func set_custom_wires( value:Dictionary ) -> void:
	custom_wires = value
	
func set_data( value:Dictionary ) -> void:
	var owner_node:Node = get_data_holder()
	if is_instance_valid(owner_node):
		if not owner_node.has_meta( "io_" + _get_slot_type() ):
			owner_node.set_meta( "io_" + _get_slot_type(), {} )
		var data:Dictionary = owner_node.get_meta( "io_" + _get_slot_type() )
		data[get_data_key()] = value
		owner_node.set_meta( "io_" + _get_slot_type(), data )
	
func set_has_updated_in_frame( value:bool ) -> void:
	has_updated_in_frame = value
	
func set_is_drawing( value:bool ) -> void:
	is_drawing = value
	update()
	
func is_a_signals_connected( signal_array:Array, connected_to:Node, method:String ) -> bool:
	for signal_info in signal_array:
		if method == signal_info["method"] and signal_info["target"] == connected_to:
			return true
			
	return false
			
			
			

	

	

	

