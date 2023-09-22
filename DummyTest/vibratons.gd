extends Control
# https://youtu.be/GLGkVae5TU4?si=qRovSjOdCkX6xGO6

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_vibrate_all_pressed() -> void:
	for i in Input.get_connected_joypads():
		Input.start_joy_vibration(i, 1, 1, 1)
		pass
	pass # Replace with function body.
