
extends Node2D

signal power_changed(power)

var input_a_power:float = 0
var input_b_power:float = 0
var previous_value:float = 0

func _input_slot_a_triggered( is_active:bool, power:float ) -> void:
	input_a_power = power
	check_or_gate()
	
func _input_slot_b_triggered( is_active:bool, power:float ) -> void:
	input_b_power = power
	check_or_gate()
	
func check_or_gate() -> void:
	#Get output power
	var output_power:float = 0
	output_power = input_a_power + input_b_power
	if output_power != previous_value:
		previous_value = output_power
		emit_signal( "power_changed", output_power )
