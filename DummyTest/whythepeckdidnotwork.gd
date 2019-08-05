extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var ResourceQueueing
var StartLoadScene = false
var SceneHasLoaded = false
export(PackedScene) var ZoingLoad

# Called when the node enters the scene tree for the first time.
func _ready():
	ResourceQueueing = preload("res://Scripts/resource_queue.gd").new()
	ResourceQueueing.start()
	pass # Replace with function body.

func _input(event):
	if event.is_action_pressed("ui_accept"):
		ResourceQueueing.queue_resource("res://DummyTest/ZoingLevel.tscn", true)
		ResourceQueueing.start()
		StartLoadScene = true
		print("Retrue")
		pass
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if StartLoadScene:
		print("Start Load Scene")
		if ResourceQueueing.is_ready(ZoingLoad):
			$Spatial.add_child(ResourceQueueing.get_resource(ZoingLoad))
			pass
		else:
			$Control/ProgressBar.value = ResourceQueueing.get_progress(ZoingLoad) * 100
			print("Progressing %f" % $Control/ProgressBar.value)
			pass
		pass
	pass
