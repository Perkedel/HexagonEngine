extends RigidBody2D

export (float) var BalonHP = 1
export (Vector2) var ArahJalan = Vector2(-1,0)
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal BalonMeletus

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# todo AddGameScore through SingletonerVirtual
func BalonMeletus():
	BalonHP -= 1
	if BalonHP <= 0:
		print("dor")
		var LoadParticle = load("res://GameDVDCardtridge/ParlorClassic/Tscene/DorMeletus.tscn")
		var Particled = LoadParticle.instance()
		var positioner = position
		Particled.position = positioner + Vector2(0,.5)
		$"..".add_child(Particled)
		$".".queue_free()
		pass
	else:
		pass
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	translate(ArahJalan)
	pass

func _input(event):
#	if event.is_action_pressed("ui_mouse_left"):
#		print("dor")
#		pass
	# BUG in Godot, Canvas layer blocks Node interaction. any node such as click mouse as in collision
	if event is InputEventMouseButton:
		var clickPos = Vector2(event.position.x, event.position.y)
		
		pass
	pass

func _on_Balon_input_event(viewport, event, shape_idx):
	#print(String(shape_idx))
#	if event.get_action_pressed():
#		#self.free()
#		print("Dor!")
#		self.queue_free()
#		pass
	if event is InputEventMouseButton:
		BalonMeletus()
		pass
	pass # Replace with function body.


func _on_Balon_body_entered(body):
	pass # Replace with function body.
