extends Spatial

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var LevelLoadRoot = $Level3DCartridgeSlot
var hasMeLoading = false
var a3DResource
# https://docs.godotengine.org/en/3.1/tutorials/io/background_loading.html
onready var custom_Resource_Queue = preload("res://Scripts/resource_queue.gd").new()
signal IncludeMeForYourLoading(MayI)
signal a3D_Loading_ProgressBar(valuet)
var ProgressValue
export(PackedScene) var Your3DSpaceLevel
export(String) var Raw3DSpaceLevelPath
var Now3DSpaceLevel
var Prev3DSpaceLevel
var StartLoadSceneL = false
var SceneHasLoaded = false

# These are easiner from that Background Loading document https://docs.godotengine.org/en/3.1/tutorials/io/background_loading.html

# Called when the node enters the scene tree for the first time.
func _ready():
	custom_Resource_Queue.start()
	Now3DSpaceLevel = LevelLoadRoot.get_child(0)
	Prev3DSpaceLevel = Now3DSpaceLevel
	pass # Replace with function body.



func spawnAScene(pathO):
	StartLoadSceneL = false
	SceneHasLoaded = false
	$Dummy3DLoad.hide()
	emit_signal("IncludeMeForYourLoading", true)
	Prev3DSpaceLevel = LevelLoadRoot.get_child(0)
	clearTheScene()
	hasMeLoading = true
	Your3DSpaceLevel = pathO
	Raw3DSpaceLevelPath = pathO
	custom_Resource_Queue.queue_resource(Raw3DSpaceLevelPath)
	pass

func clearTheScene():
	#StartLoadSceneL = false
	#SceneHasLoaded = false
	if Prev3DSpaceLevel:
		Prev3DSpaceLevel.queue_free()
		pass
	pass

func despawnTheScene():
	if a3DResource:
		Now3DSpaceLevel = LevelLoadRoot.get_child(0)
		pass
	else:
		Now3DSpaceLevel = LevelLoadRoot.get_child(0)
	Now3DSpaceLevel.queue_free()
	$Dummy3DLoad.show()
	pass

signal hasLoadingCompleted
func InitiateThatScene(scene_resource):
	a3DResource = scene_resource.instance()
	# https://docs.godotengine.org/en/3.1/tutorials/threads/thread_safe_apis.html#doc-thread-safe-apis
	LevelLoadRoot.call_deferred("add_child", a3DResource)
	Now3DSpaceLevel = LevelLoadRoot.get_child(0)
	emit_signal("hasLoadingCompleted")
	pass

func show_error():
	pass

func update_progress_threaded():
	var progress = custom_Resource_Queue.get_progress(Raw3DSpaceLevelPath)
	ProgressValue = progress * 100
	#print(progress)
	pass

func fake_progress_100():
	ProgressValue = 100
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if custom_Resource_Queue.is_ready(Raw3DSpaceLevelPath):
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
		if not StartLoadSceneL:
			InitiateThatScene(custom_Resource_Queue.get_resource(Raw3DSpaceLevelPath))
			StartLoadSceneL = true
			hasMeLoading = false
			pass
		pass
	
	emit_signal("a3D_Loading_ProgressBar", ProgressValue)
	pass
