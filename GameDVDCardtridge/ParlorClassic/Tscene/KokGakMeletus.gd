extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func PlsMeletuslah():
	$".".queue_free()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_KokGakMeletus_input_event(viewport, event, shape_idx):
	pass # Replace with function body.


func _on_KokGakMeletus_body_entered(body):
	print("Pls Meletus " + body.name)
	PlsMeletuslah()
	pass # Replace with function body.


func _on_KokGakMeletus_body_shape_entered(body_id, body, body_shape, local_shape):
	PlsMeletuslah()
	pass # Replace with function body.
