extends Node2D

signal power_changed( power )
	
func _on_signal_input_changed( is_active:bool, power:float ) -> void:
	prints("pre", power)
	power = wrapf( power+1, -1, 1 )
	prints("pro", power)
		
	emit_signal( "power_changed", power )
	
		
	