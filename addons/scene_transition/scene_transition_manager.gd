extends Node

var loading_scene:CanvasItem
var current_scene:Node
var time_to_load_scene:int
var local_thread:Thread 
var loading_scene_path
var semaphore:Semaphore
var semaphore_anim_fade:Semaphore
var mutex:Mutex
var play_start_anim:bool
var waiting_for_remove = false
var resource_loader = preload("res://addons/scene_transition/resource_loader.gd").new()

var node_wrapper = Node.new()

var exit_thread = false

func _enter_tree():
	#print("init>"+str(get_tree().get_root()));
	time_to_load_scene = OS.get_system_time_msecs()
	current_scene = detect_current_scene();
	if current_scene == null:
		print("no current scene detected!")
		return
	current_scene.connect("ready", self, "_listener_scene_complete_loaded")
	
func detect_current_scene():
	var rt = get_tree().get_root()
	for ch in rt.get_children():
		if ch.name != self.name:
			print("Startup scene:" + ch.name)
			return ch
	return null
	
func _init():
	local_thread = Thread.new()
	semaphore = Semaphore.new()
	semaphore_anim_fade = Semaphore.new()
	mutex = Mutex.new()
	resource_loader.start()
	local_thread.start(self, "thread_func", 0)
	loading_scene = load("res://addons/scene_transition/loading_scene.tscn").instance()
	loading_scene.connect("animation_finished", self, "_listener_animation_is_finished")
	
func _ready():
	node_wrapper.name = "Wrapper"
	get_tree().get_root().call_deferred("add_child", node_wrapper)
	get_tree().get_root().call_deferred("add_child", loading_scene)
#	loading_scene.fade_in()
	call_deferred("change_scene_to", current_scene.filename, false)
	
func _exit_tree():
	mutex.lock()
	exit_thread = true
	semaphore.post()
	resource_loader.stop()
	mutex.unlock()
	local_thread.wait_to_finish()
	
func change_scene_to(var scene, play_start_anim:bool = true)-> void:
	mutex.lock()
	self.play_start_anim = play_start_anim
	if loading_scene_path == null:
		loading_scene_path = scene
		semaphore.post()
	mutex.unlock()

func load_scene_bg():
	# this semaphore will release when change_scene_to is called
	semaphore.wait()
	# change_scene_to will set this var
	if loading_scene_path == null:
		return 
	
	# just debug purpouse
	time_to_load_scene = OS.get_system_time_msecs()
	# set loading_scene visible (and, of_course, block any touch in screen)
	
	# lock instance vars
	mutex.lock()
	if play_start_anim: 
		loading_scene.visible = true
		loading_scene.set_process(true)
		loading_scene.fade_out()
		# wait to fade_out finishes, 
		#before start loading new scene
		semaphore_anim_fade.wait()
	mutex.unlock()
	
	resource_loader.start_loading(loading_scene_path)
	current_scene = resource_loader\
						.get_resource()\
						.instance()
	if not current_scene:
		print ("Error loading scene: "+loading_scene_path)
		return
	mutex.lock()
	loading_scene_path = null
	mutex.unlock()
	
	current_scene.connect("ready", self, "_listener_scene_complete_loaded")
	node_wrapper.add_child(current_scene)
	
func thread_func(ignore):
	while(true):
		load_scene_bg()
		mutex.lock()
		if exit_thread:
			break
		mutex.unlock()

func _listener_scene_complete_loaded():
	# Called when scene is full loaded
	loading_scene.fade_in()
	var ms = OS.get_system_time_msecs() - time_to_load_scene
	print("Loaded new scene with: "+str(ms))

func _listener_animation_is_finished(var anim_name):
	if anim_name == "fade_in":
		loading_scene.visible = false
		loading_scene.set_process(false)
	if anim_name == "fade_out":
		# Only remove currente scene 
		# when fade_out is finished
		current_scene.queue_free()
		# release background thread, 
		# it is waiting fade out finishes
		semaphore_anim_fade.post()
		
func get_progress():
	if loading_scene_path:
		return resource_loader.get_progress()
