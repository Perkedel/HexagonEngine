extends Spatial

onready var anPlayer = $ProsotipePlatformerGuy
onready var anPlayerPosInit = anPlayer.transform
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_JatuhAAA_area_entered(area):
	
	pass # Replace with function body.


func _on_JatuhAAA_body_entered(body):
	print("Someone Fell " + body.name)
	if(body == anPlayer):
		anPlayer.transform = anPlayerPosInit
		pass
	pass # Replace with function body.
