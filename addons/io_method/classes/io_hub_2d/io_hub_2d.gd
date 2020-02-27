tool
extends IOMethod2D
class_name IOHub2D, "res://addons/io_method/classes/io_hub_2d/io_hub_2d.png"

signal delete_meta

const CONNECTION_SIZE_RADIUS:int =  8

signal input_connections_changed
signal output_connections_changed

onready var par_old_name:String = get_parent().get_name()

#Container nodes
onready var inputs_container:Node2D = null
onready var outputs_container:Node2D = null

func _enter_tree() -> void:
	initialise_inputs_container()
	initialise_outputs_container()
	
	if not get_parent().is_connected( "renamed", self, "_on_parent_renamed" ):
		get_parent().connect( "renamed", self, "_on_parent_renamed" )

func _on_parent_renamed() -> void:
	pass
#	#For outputs
#	for output in get_outputs():
#		var output_data:Dictionary = output.data
#
#		#Update input meta data
#		for input in output_data["connected_inputs"]:
#			var input_data:Dictionary = input.data
#			input.set_data( input_data )
#
#		#Update meta data
#		output.set_data( output_data )
#
#	#For inputs
#	for input in get_inputs():
#		var input_data:Dictionary = input.data
#
#		#Update output meta data
#		for output in input_data["connected_outputs"]:
#			var output_data:Dictionary = output.data
#			output.set_data( output_data )
#
#		#Update meta data
#		input.set_data( input_data )
#
#	par_old_name = get_parent().get_name()
	
func _on_script_changed() -> void:
	par_old_name = get_parent().get_name()

func _ready() -> void:
	par_old_name = get_parent().get_name()
	if not is_connected( "script_changed", self, "_on_script_changed" ):
		connect( "script_changed", self, "_on_script_changed" )
	if Engine.editor_hint:
		add_to_group( "io_hub_2d" )

func add_input( slot_position:Vector2 ) -> void:
	var new_input = InputSlot2D.new()
	new_input.set_name( "Input" ) 

	new_input.set_owner( get_tree().get_edited_scene_root() )
	get_inputs_container().add_child(new_input)
	new_input.set_owner( get_tree().get_edited_scene_root() )

	new_input.set_global_position(slot_position)

func add_output( slot_position:Vector2 ) -> void:
	initialise_outputs_container()
	var new_output = OutputSlot2D.new()
	new_output.set_name( "Output" ) 

	new_output.set_owner( get_outputs_container().get_owner() )
	get_outputs_container().add_child(new_output)
	new_output.set_owner( get_outputs_container().get_owner() )

	new_output.set_global_position(slot_position)

func get_input_within_range( point:Vector2 ) -> InputSlot2D:
	for slot in get_inputs_container().get_children():
		if slot is InputSlot2D:
			var slot_pos_glb:Vector2 = slot.get_global_position()
			if slot_pos_glb.distance_to( point ) < CONNECTION_SIZE_RADIUS:
				return slot

	return null

func get_inputs_container() -> Node2D:
	if inputs_container == null:
		initialise_inputs_container()

	return inputs_container

func get_inputs() -> Array:
	var inputs:Array = []
	for child in get_inputs_container().get_children():
		if child is InputSlot2D:
			inputs.append(child)
			
	return inputs

func get_output_within_range( point:Vector2 ) -> OutputSlot2D:
	for output in get_outputs_container().get_children():
		if output is OutputSlot2D:
			var output_pos_glb:Vector2 = output.get_global_position()
			if output_pos_glb.distance_to( point ) < CONNECTION_SIZE_RADIUS:
				return output

	return null

func get_outputs_container() -> Node2D:
	if outputs_container == null:
		initialise_outputs_container()

	return outputs_container

func get_outputs() -> Array:
	var outputs:Array = []
	for child in get_outputs_container().get_children():
		if child is OutputSlot2D:
			outputs.append(child)
			
	return outputs

func get_slot_within_range( point:Vector2 ):
	"""
	Returns the output that is within range of point (For getting of clicked on)
	"""
	var return_slot = null
	return_slot = get_output_within_range( point )

	if return_slot == null:
		return_slot = get_input_within_range( point )

	return return_slot

func initialise_inputs_container():
	if has_node("Inputs"):
		inputs_container = get_node("Inputs")
	elif not is_instance_valid(inputs_container):
		inputs_container = Node2D.new()
		inputs_container.set_name( "Inputs" )
		add_child( inputs_container )
		inputs_container.set_owner( get_owner() )

func initialise_outputs_container():
	if has_node("Outputs"):
		outputs_container = get_node("Outputs")
	elif not is_instance_valid(outputs_container):
		outputs_container = Node2D.new()
		outputs_container.set_name( "Outputs" )
		add_child( outputs_container )
		outputs_container.set_owner( get_owner() )

func is_input_connected( input_index:int ):
	"""
	Get if input slot is connected to an output slot
	"""
	var inputs_container:Node2D = get_inputs_container()
	var input_slot:InputSlot2D = inputs_container.get_child( input_index )
	return input_slot.is_connected or len(input_slot.connected_outputs) > 0

func is_output_connected( output_index:int ):
	"""
	Get if output slot is connected to an input slot
	"""
	var outputs_container:Node2D = get_inputs_container()
	var output_slot:OutputSlot2D = outputs_container.get_child( output_index )
	return len(output_slot.get_connected_inputs()) > 0

func remove_slot( slot ) -> void:
	if slot is InputSlot2D and get_inputs_container().get_children().has(slot):
		slot.queue_free()
	if slot is OutputSlot2D and get_outputs_container().get_children().has(slot):
		slot.queue_free()



