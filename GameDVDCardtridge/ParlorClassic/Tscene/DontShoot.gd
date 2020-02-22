extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal PlayerHitMe

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_DontShoot_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		#print("Bekgron Clicc")
		if event.pressed:
			#emit_signal("PlayerHitMe")
			#print("Player hit Bekgron")
			pass
		pass
	pass # Replace with function body.


func _on_DontShoot_body_entered(body):
	#emit_signal("PlayerHitMe")
	#print("Player Hit bekgrond")
	pass # Replace with function body.
