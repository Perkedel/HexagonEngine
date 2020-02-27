var thread
var mutex:Mutex
var sem:Semaphore
var finishing = false
var time_max = 100 # msec
var resource_loaded
var resource_path
var loader:ResourceInteractiveLoader

func start_loading(path):
	mutex.lock()
	resource_loaded = null
	resource_path = path
	# check if it is already loaded
	if ResourceLoader.has(path):
		var res = ResourceLoader.load(path)
		resource_path = res
	else:
		loader = ResourceLoader.load_interactive(path)
		# start loading file
		if loader:
			sem.post()
		else :
			var res = ResourceLoader.load(path)
			resource_loaded = res
	mutex.unlock()

func get_progress():
	mutex.lock()
	var ret = -1
	if loader:
		ret = float(loader.get_stage()) / float(loader.get_stage_count())
	elif resource_path:
		ret = 0
	else:
		ret = 1.0
	mutex.unlock()
	return ret

func _wait_for_resource():
	while resource_loaded == null:
		OS.delay_usec(16000) 
		if get_progress() == 1:
				break
	return resource_loaded
	


func get_resource():
	return _wait_for_resource()

func thread_process():
	sem.wait()
	if finishing:
		return
	while loader:
		var ret = loader.poll()
		if ret == ERR_FILE_EOF || ret != OK:
			resource_loaded = loader.get_resource()
			loader = null
			


func thread_func(u):
	while not finishing:
		thread_process()

func start():
	mutex = Mutex.new()
	sem = Semaphore.new()
	thread = Thread.new()
	thread.start(self, "thread_func", 0)
func stop():
	mutex.lock()
	finishing = true
	sem.post()
	mutex.unlock()
	thread.wait_to_finish()
