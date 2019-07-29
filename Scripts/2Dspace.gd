extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var ConThread2D
var a2DResource
export(PackedScene) var Your2DSpaceLevel
var Prev2DSpaceLevel

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func spawnTheScene(pathO):
	a2DResource = ResourceInteractiveLoader.load_interactive(Your2DSpaceLevel)
	if a2DResource == null:
		# Error 2D
		pass
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
