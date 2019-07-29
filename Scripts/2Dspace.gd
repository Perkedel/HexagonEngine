extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var ConThread2D
var a2DResource
export(PackedScene) var Your2DSpaceLevel
var Prev2DSpaceLevel
var Now2DSpaceLevel
var mutex
var semaphore
signal IncludeMeForYourLoading(MayI)
signal a2D_Loading_ProgressBar(valuet)
var ProgressValue
var wait_frames = 0
var hasMeLoading = false
var exit_thread
var time_max = 100 # msec

# Called when the node enters the scene tree for the first time.
func _ready():
	ProgressValue = 0
	mutex = Mutex.new()
	semaphore = Semaphore.new()
	exit_thread = false
	ConThread2D = Thread.new()
	
	var root = $Level2DCartridgeSlot
	Now2DSpaceLevel = root.get_child(0)
	Prev2DSpaceLevel = Now2DSpaceLevel
	pass # Replace with function body.

func show_error():
	pass

func spawnAScene(pathO):
	$Dummy2DLoad.hide()
	print("SpawnScene %s", pathO)
	Prev2DSpaceLevel = Now2DSpaceLevel
	a2DResource = ResourceLoader.load_interactive(pathO)
	if a2DResource == null:
		# Error 3D
		show_error()
		pass
	set_process(true)
	
	Now2DSpaceLevel.queue_free()
	
	emit_signal("IncludeMeForYourLoading", true)
	
	wait_frames = 1
	pass

func update_progress():
	var progress = float(a2DResource.get_stage()) / a2DResource.get_stage_count()
	ProgressValue = progress * 100
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if a2DResource == null:
		# no need to process anymore
		set_process(false)
		return
	
	if wait_frames > 0: # wait for frames to let the "loading" animation show up
		wait_frames -= 1
		hasMeLoading = true
		return
	
	var t = OS.get_ticks_msec()
	while OS.get_ticks_msec() < t + time_max: # use "time_max" to control for how long we block this thread
	# poll your loader
		var err = a2DResource.poll()
		if err == ERR_FILE_EOF: # Finished loading.
			var resource = a2DResource.get_resource()
			update_progress()
			a2DResource = null
			InitiateThatScene(resource)
			hasMeLoading = false
			break
		elif err == OK:
			update_progress()
			emit_signal("a2D_Loading_ProgressBar", ProgressValue)
		else: # error during loading
			show_error()
			a2DResource = null
			hasMeLoading = false
			break
		pass
	
	emit_signal("a2D_Loading_ProgressBar", ProgressValue)
	pass

signal hasLoadingCompleted
func InitiateThatScene(scene_resource):
	Now2DSpaceLevel = scene_resource.instance()
	# https://docs.godotengine.org/en/3.1/tutorials/threads/thread_safe_apis.html#doc-thread-safe-apis
	$Level2DCartridgeSlot.call_deferred("add_child",Now2DSpaceLevel)
	emit_signal("hasLoadingCompleted")
	pass
