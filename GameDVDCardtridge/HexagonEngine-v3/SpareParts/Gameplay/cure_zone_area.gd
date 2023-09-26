extends Area3D

@export var curePower:float = 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_shape_entered(body_rid: RID, body: Node3D, body_shape_index: int, local_shape_index: int) -> void:
	pass # Replace with function body.


func _on_body_entered(body: Node3D) -> void:
	if body.has_method('heal'):
#		print('will Cuur')
		body.call('heal',curePower)
		pass
	pass # Replace with function body.


func _on_body_exited(body: Node3D) -> void:
	pass # Replace with function body.
