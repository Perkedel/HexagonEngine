extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Scroncher_body_entered(body):
	print("Body Out of Bound = " + body.name)
	body.free()
	pass # Replace with function body.


func _on_Scroncher_body_shape_entered(body_id, body, body_shape, area_shape):
	pass # Replace with function body.
