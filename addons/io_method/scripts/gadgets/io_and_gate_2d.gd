extends Node2D

signal power_changed(power)

var input_a_power:float = 0
var input_b_power:float = 0
var is_input_a_active:bool = false
var is_input_b_active:bool = false

func _input_slot_a_triggered( is_active:bool, power:float ) -> void:
	input_a_power = power
	is_input_a_active = is_active
	check_and_gate()
	
func _input_slot_b_triggered( is_active:bool, power:float ) -> void:
	input_b_power = power
	is_input_b_active = is_active
	check_and_gate()
	
	
func check_and_gate() -> void:
	#Get output power
	var output_power:float = 0
	if is_input_a_active and is_input_b_active:
		#Get highest power of the inputs
		if abs(input_a_power) > abs(input_b_power):
			output_power = input_a_power
		else:
			output_power = input_b_power
	
	emit_signal( "power_changed", output_power )
