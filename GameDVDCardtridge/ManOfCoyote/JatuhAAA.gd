extends Area3D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal PlayerDidFell()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _enter_tree():
	
	pass


func _on_JatuhAAA_body_entered(body):
	print("\nFell ", String(body.name))
	if body is HeroicPlayer:
		print(body.name, "is Heroic Player!\n")
		emit_signal("PlayerDidFell")
	pass # Replace with function body.
