extends Node

# JOELwindows7: this is empty node just to make sure everything loads first
# then go to the main node.
export(PackedScene) var LoadThis:PackedScene = load("res://HexagonEngineCore.tscn")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func justStart():
	yield(get_tree().create_timer(5), "timeout")
	Singletoner.ExclusiveBoot(LoadThis)
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	justStart()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
