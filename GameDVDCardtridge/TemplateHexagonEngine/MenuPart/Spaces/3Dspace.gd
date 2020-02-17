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
var StartLoadSceneL = true
var SceneHasLoaded = true
var ConnectedSignal = false

signal TellHP(Level)
signal TellScore(value)

# These are easiner from that Background Loading document https://docs.godotengine.org/en/3.1/tutorials/io/background_loading.html

# Called when the node enters the scene tree for the first time.
func _ready():
	#ConnecStatusSignal()
	custom_Resource_Queue.start()
	Now3DSpaceLevel = LevelLoadRoot.get_child(0)
	Prev3DSpaceLevel = Now3DSpaceLevel
	pass # Replace with function body.



func spawnAScene(pathO):
	$Dummy3DLoad.hide()
	emit_signal("IncludeMeForYourLoading", true)
	if LevelLoadRoot.get_child(0):
		Prev3DSpaceLevel = LevelLoadRoot.get_child(0)
		pass
	DisconnecStatusSignalPrevious()
	clearTheScene()
	StartLoadSceneL = false
	SceneHasLoaded = false
	hasMeLoading = true
	Your3DSpaceLevel = pathO
	Raw3DSpaceLevelPath = pathO
	print("Queueing Scene " + Raw3DSpaceLevelPath)
	custom_Resource_Queue.queue_resource(Raw3DSpaceLevelPath)
	pass

func clearTheScene():
	#StartLoadSceneL = false
	#SceneHasLoaded = false
	if StartLoadSceneL:
		if Prev3DSpaceLevel:
			Prev3DSpaceLevel.queue_free()
			pass
		pass
	pass

func despawnTheScene():
#	if a3DResource:
#		Now3DSpaceLevel = LevelLoadRoot.get_child(0)
#		pass
#	else:
#		Now3DSpaceLevel = LevelLoadRoot.get_child(0)
#		pass
	# wat? no difference? why not emmerge?
	if LevelLoadRoot.get_child(0):
		Now3DSpaceLevel = LevelLoadRoot.get_child(0)
		pass
	else:
		printerr("Werror 3D Data Child")
		pass
	#DisconnecStatusSignal()
	if Now3DSpaceLevel:
		Now3DSpaceLevel.queue_free()
		pass
	SceneHasLoaded = false
	StartLoadSceneL = false
	$Dummy3DLoad.show()
	pass

signal hasLoadingCompleted
signal readyToPlayNow
func InitiateThatScene(scene_resource):
	a3DResource = scene_resource.instance()
	# https://docs.godotengine.org/en/3.1/tutorials/threads/thread_safe_apis.html#doc-thread-safe-apis
	#LevelLoadRoot.call_deferred("add_child", a3DResource)
	LevelLoadRoot.add_child(a3DResource)
	#Now3DSpaceLevel = LevelLoadRoot.get_child(0)
	#ConnecStatusSignal()
	# emit_signal("hasLoadingCompleted")
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

func DisconnecStatusSignal():
	if LevelLoadRoot.get_child(0):
		Now3DSpaceLevel = LevelLoadRoot.get_child(0)
		pass
	else:
		printerr("Werror 3D Data Child")
		pass
	
	if ConnectedSignal:
		if Now3DSpaceLevel:
	#		if Now3DSpaceLevel.is_connected("reportHP",self,"_EmitStatuso_HP"):
	#			Now3DSpaceLevel.disconnect("reportHP",self,"_EmitStatuso_HP")
	#			pass
	#		if Now3DSpaceLevel.is_connected("reportScore",self,"_EmitStatuso_Score"):
	#			Now3DSpaceLevel.disconnect("reportScore",self,"_EmitStatuso_Score")
	#			pass
	#		pass
			Now3DSpaceLevel.disconnect("reportHP",self,"_EmitStatuso_HP")
			Now3DSpaceLevel.disconnect("reportScore",self,"_EmitStatuso_Score")
			ConnectedSignal = false
			pass
		else:
			printerr("Werror 3D Disconnect")
			pass
		pass
	pass

func DisconnecStatusSignalPrevious():
	if ConnectedSignal:
		if Prev3DSpaceLevel:
			Prev3DSpaceLevel.disconnect("reportHP",self,"_EmitStatuso_HP")
			Prev3DSpaceLevel.disconnect("reportScore",self,"_EmitStatuso_Score")
			ConnectedSignal = false
			pass
		else:
			printerr("Werror 3D Disconnect")
			pass
		pass
	pass

func ConnecStatusSignal():
#	for ins in $Level3DCartridgeSlot.get_children():
##		ins.connect("reportHPLevel",self,"_EmitStatuso")
##		pass
	print("Connect Signal 3D")
	if LevelLoadRoot.get_child(0):
		Now3DSpaceLevel = LevelLoadRoot.get_child(0)
		pass
	else:
		printerr("Werror 3D Data Child")
		pass
	
	if !ConnectedSignal:
		if Now3DSpaceLevel:
#			if !Now3DSpaceLevel.is_connected("reportHP",self,"_EmitStatuso_HP"):
#				Now3DSpaceLevel.connect("reportHP",self,"_EmitStatuso_HP")
#				pass
#			if !Now3DSpaceLevel.is_connected("reportScore",self,"_EmitStatuso_Score"):
#				Now3DSpaceLevel.connect("reportScore",self,"_EmitStatuso_Score")
#				pass
			Now3DSpaceLevel.connect("reportHP",self,"_EmitStatuso_HP")
			Now3DSpaceLevel.connect("reportScore",self,"_EmitStatuso_Score")
			ConnectedSignal = true
			pass
		else:
			printerr("Werror 2D connect")
			pass
		pass
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if custom_Resource_Queue.is_ready(Raw3DSpaceLevelPath):
		SceneHasLoaded = true
		print("Queue is ready " + Raw3DSpaceLevelPath)
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
		emit_signal("hasLoadingCompleted")
		if not StartLoadSceneL:
			
			InitiateThatScene(custom_Resource_Queue.get_resource(Raw3DSpaceLevelPath))
			#ConnecStatusSignal()
			StartLoadSceneL = true
			hasMeLoading = false
			emit_signal("readyToPlayNow")
			pass
		pass
	
	emit_signal("a3D_Loading_ProgressBar", ProgressValue)
	pass
	

func _EmitStatuso_HP(HPleveli):
	emit_signal("TellHP",HPleveli)
	pass
func _EmitStatuso_Score(ScoreLeveli):
	emit_signal("TellScore",ScoreLeveli)
	pass

