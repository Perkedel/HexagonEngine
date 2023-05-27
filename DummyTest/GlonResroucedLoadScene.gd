extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var queue = []
var pause_menu

# Called when the node enters the scene tree for the first time.
func _ready():
	# Initialize.
	queue = preload("res://Scripts/resource_queue.gd").new()
	queue.start()
	
	# Suppose your game starts with a 10 second cutscene, during which the user can't interact with the game.
	# For that time, we know they won't use the pause menu, so we can queue it to load during the cutscene:
	queue.queue_resource("res://pause_menu.tres")
	start_cutscene()
	
	# Later, when the user presses the pause button for the first time:
	pause_menu = queue.get_resource("res://DummyTest/PausoDummy.tscn").instantiate()
	pause_menu.show()
	
	# when you need a new scene:
	queue.queue_resource("res://level_1.tscn", true) # Use "true" as the second argument to put it at the front
													 # of the queue, pausing the load of any other resource.
	
	# to check progress
	if queue.is_ready("res://level_1.tscn"):
		show_new_level(queue.get_resource("res://level_1.tscn"))
	else:
		update_progress(queue.get_process("res://level_1.tscn"))
	
	# when the user walks away from the trigger zone in your Metroidvania game:
	queue.cancel_resource("res://zone_2.tscn")
	pass

func show_new_level(WhatToLoad):
	add_child(WhatToLoad)
	pass

func update_progress(WhatToUpdate):
	
	pass

func start_cutscene():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
