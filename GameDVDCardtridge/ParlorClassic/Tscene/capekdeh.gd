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


func _on_capekdeh_body_entered(body):
	$".".queue_free()
	print("hey")
	pass # Replace with function body.


func _on_capekdeh_area_entered(area):
	$".".queue_free()
	print("hay")
	pass # Replace with function body.
