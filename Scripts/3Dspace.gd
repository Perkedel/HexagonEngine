extends Spatial

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var wait_frames = 0
var hasMeLoading = false
var SemaThreadCounter = 0
var ConThread3D
var mutex
var semaphore
var exit_thread = false
var a3DResource
signal IncludeMeForYourLoading(MayI)
signal a3D_Loading_ProgressBar(valuet)
var ProgressValue
export(PackedScene) var Your3DSpaceLevel
var Now3DSpaceLevel
var Prev3DSpaceLevel
var time_max = 100 # msec

# These are easiner from that Background Loading document https://docs.godotengine.org/en/3.1/tutorials/io/background_loading.html
func _lock(caller):
	mutex.lock()
	pass

func _unlock(caller):
	mutex.unlock()
	pass

func _post(caller):
	semaphore.post()
	pass

func _wait(caller):
	semaphore.wait()
	pass
# end easiner

# Called when the node enters the scene tree for the first time.
func _ready():
	mutex = Mutex.new()
	semaphore = Semaphore.new()
	exit_thread = false
	ConThread3D = Thread.new()
	
	var root = $Level3DCartridgeSlot
	Now3DSpaceLevel = root.get_child(get_child_count()-1)
	Prev3DSpaceLevel = Now3DSpaceLevel
	pass # Replace with function body.

func ThreadingSpawnScene(pathO):
	ConThread3D.start(self, "_thread_function", pathO)
	pass

#ADATA is brand. avoid unecessary brand mention!
func _thread_function(bData):
	while true:
		_wait("_thread_function") # Wait until posted.
		_lock("_thread_function")
		spawnAScene(bData)
		var should_exit = exit_thread # Protect with Mutex.
		_unlock("_thread_function")
		if should_exit:
			break
			pass
		_lock("_thread_function")
		SemaThreadCounter += 1 # Increment counter, protect with Mutex.
		_unlock("_thread_function")
	pass

func increment_counter():
	semaphore.post() # Make the thread process.
	pass

func get_counter():
	mutex.lock()
	# Copy counter, protect with Mutex.
	var counter_value = SemaThreadCounter
	mutex.unlock()
	return counter_value

# Thread must be disposed (or "joined"), for portability.
func _exit_tree():
	# Set exit condition to true.
	mutex.lock()
	exit_thread = true # Protect with Mutex.
	mutex.unlock()
	
	# Unblock by posting.
	semaphore.post()
	
	# Wait until it exits.
	ConThread3D.wait_to_finish()
	
	# Print the counter.
	print("SemaThreadCounter is: ", SemaThreadCounter)
	pass

func spawnAScene(pathO):
	Prev3DSpaceLevel = Now3DSpaceLevel
	a3DResource = ResourceInteractiveLoader.load_interactive(Your3DSpaceLevel)
	if a3DResource == null:
		# Error 3D
		show_error()
		pass
	set_process(true)
	
	
	Now3DSpaceLevel.queue_free()
	
	emit_signal("IncludeMeForYourLoading", true)
	
	wait_frames = 1
	pass

signal hasLoadingCompleted
func InitiateThatScene(scene_resource):
	Now3DSpaceLevel = scene_resource.instance()
	# https://docs.godotengine.org/en/3.1/tutorials/threads/thread_safe_apis.html#doc-thread-safe-apis
	$Level3DCartridgeSlot.call_deferred("add_child",Now3DSpaceLevel)
	emit_signal("hasLoadingCompleted")
	pass

func show_error():
	pass

func update_progress():
	var progress = float(a3DResource.get_stage()) / a3DResource.get_stage_count()
	ProgressValue = progress
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if a3DResource == null:
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
		var err = a3DResource.poll()
		if err == ERR_FILE_EOF: # Finished loading.
			var resource = a3DResource.get_resource()
			a3DResource = null
			InitiateThatScene(resource)
			hasMeLoading = false
			break
		elif err == OK:
			update_progress()
			emit_signal("a3D_Loading_ProgressBar", ProgressValue)
		else: # error during loading
			show_error()
			a3DResource = null
			hasMeLoading = false
			break
		pass
	
	#emit_signal("a3D_Loading_ProgressBar", ProgressValue)
	pass
