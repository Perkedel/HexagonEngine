extends Node2D

signal power_changed( power )
	
func _on_signal_input_changed( is_active:bool, power:float ) -> void:
	power = wrapf( power+1, -1, 1 )
	
	if abs(power) < .5:
		$Sprite.set_modulate( Color(1,1,1) )
	else:
		$Sprite.set_modulate( Color(.5,.5,.5) )
		
	emit_signal( "power_changed", power )
	
		
	
