extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func toggleVisible():
	visible = not visible
	set_process(visible)
	$StaticBody3D/CollisionShape3D.disabled = not visible

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
