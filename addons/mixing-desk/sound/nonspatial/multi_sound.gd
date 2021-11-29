extends Node

export var autoplay : bool
export(NodePath) var spawn_node

func _ready():
	for i in get_children():
		if spawn_node:
			if spawn_node in i:
				i.spawn_node = spawn_node
	if autoplay:
		play()

func play():
	for i in get_children():
		i.play()

func stop():
	for i in get_children():
		i.stop()
