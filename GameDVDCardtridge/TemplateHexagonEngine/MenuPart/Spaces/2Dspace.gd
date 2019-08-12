extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var LevelLoadRoot = $Level2DCartridgeSlot
var a2DResource
export(PackedScene) var Your2DSpaceLevel
export(String) var Raw2DSpaceLevelPath
var Prev2DSpaceLevel
var Now2DSpaceLevel
# https://docs.godotengine.org/en/3.1/tutorials/io/background_loading.html
onready var custom_Resource_Queue = preload("res://Scripts/resource_queue.gd").new()
signal IncludeMeForYourLoading(MayI)
signal a2D_Loading_ProgressBar(valuet)
var ProgressValue
var hasMeLoading = false
var StartLoadScene = false
var SceneHasLoaded = false

# These are easiner from that Background Loading document https://docs.godotengine.org/en/3.1/tutorials/io/background_loading.html

# Called when the node enters the scene tree for the first time.
func _ready():
	custom_Resource_Queue.start()
	Now2DSpaceLevel = LevelLoadRoot.get_child(0)
	Prev2DSpaceLevel = Now2DSpaceLevel
	pass # Replace with function body.



func spawnAScene(pathO):
	$Dummy2DLoad.hide()
	emit_signal("IncludeMeForYourLoading", true)
	Prev2DSpaceLevel = LevelLoadRoot.get_child(0)
	clearTheScene()
	hasMeLoading = true
	Your2DSpaceLevel = pathO
	Raw2DSpaceLevelPath = pathO
	custom_Resource_Queue.queue_resource(Raw2DSpaceLevelPath)
	pass

func clearTheScene():
	StartLoadScene = false
	SceneHasLoaded = false
	if Prev2DSpaceLevel:
		Prev2DSpaceLevel.queue_free()
		pass
	pass

func despawnTheScene():
	if a2DResource:
		Now2DSpaceLevel = LevelLoadRoot.get_child(0)
		pass
	else:
		Now2DSpaceLevel = LevelLoadRoot.get_child(0)
	Now2DSpaceLevel.queue_free()
	$Dummy2DLoad.show()
	pass

signal hasLoadingCompleted
func InitiateThatScene(scene_resource):
	a2DResource = scene_resource.instance()
	# https://docs.godotengine.org/en/3.1/tutorials/threads/thread_safe_apis.html#doc-thread-safe-apis
	LevelLoadRoot.call_deferred("add_child", a2DResource)
	Now2DSpaceLevel = LevelLoadRoot.get_child(0)
	emit_signal("hasLoadingCompleted")
	pass

func show_error():
	pass

func update_progress_threaded():
	var progress = custom_Resource_Queue.get_progress(Raw2DSpaceLevelPath)
	ProgressValue = progress * 100
	#print(progress)
	pass

func fake_progress_100():
	ProgressValue = 100
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if custom_Resource_Queue.is_ready(Raw2DSpaceLevelPath):
		SceneHasLoaded = true
		
		pass
	else:
		
		
		pass
	#update_progress_threaded()
	if SceneHasLoaded:
		fake_progress_100()
		pass
	else:
		update_progress_threaded()
		pass
	
	if SceneHasLoaded:
		if not StartLoadScene:
			InitiateThatScene(custom_Resource_Queue.get_resource(Raw2DSpaceLevelPath))
			StartLoadScene = true
			hasMeLoading = false
			pass
		pass
	
	emit_signal("a2D_Loading_ProgressBar", ProgressValue)
	pass
