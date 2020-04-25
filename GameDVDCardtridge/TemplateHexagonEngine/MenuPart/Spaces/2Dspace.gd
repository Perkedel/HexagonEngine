extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var LevelLoadRoot = $Level2DCartridgeSlot
var a2DResource
export(PackedScene) var Your2DSpaceLevel
export(String) var Raw2DSpaceLevelPath = ""
var Prev2DSpaceLevel
var Now2DSpaceLevel
# https://docs.godotengine.org/en/3.1/tutorials/io/background_loading.html
onready var custom_Resource_Queue = preload("res://Scripts/ExtraImportAsset/resource_queue.gd").new()
signal IncludeMeForYourLoading(MayI)
signal a2D_Loading_ProgressBar(valuet)
var ProgressValue
var hasMeLoading = false
var StartLoadScene = true
var SceneHasLoaded = true
var ConnectedSignal = false
signal TellHP(Level)
signal TellScore(value)

# These are easiner from that Background Loading document https://docs.godotengine.org/en/3.1/tutorials/io/background_loading.html

# Called when the node enters the scene tree for the first time.
func _ready():
	#ConnecStatusSignal()
	custom_Resource_Queue.start()
	Now2DSpaceLevel = LevelLoadRoot.get_child(0)
	Prev2DSpaceLevel = Now2DSpaceLevel
	pass # Replace with function body.



func spawnAScene(pathO):
	$Dummy2DLoad.hide()
	emit_signal("IncludeMeForYourLoading", true)
	if LevelLoadRoot.get_child(0):
		Prev2DSpaceLevel = LevelLoadRoot.get_child(0)
		pass
	DisconnecStatusSignalPrevious()
	clearTheScene()
	StartLoadScene = false
	SceneHasLoaded = false
	hasMeLoading = true
	Your2DSpaceLevel = pathO
	Raw2DSpaceLevelPath = pathO
	print("Queueing Scene " + Raw2DSpaceLevelPath)
	custom_Resource_Queue.queue_resource(Raw2DSpaceLevelPath)
	pass

func clearTheScene():
	#StartLoadScene = false
	#SceneHasLoaded = false
	if StartLoadScene:
		if Prev2DSpaceLevel:
			Prev2DSpaceLevel.queue_free()
			pass
		pass
	pass

func despawnTheScene():
#	if a2DResource:
#		Now2DSpaceLevel = LevelLoadRoot.get_child(0)
#		pass
#	else:
#		Now2DSpaceLevel = LevelLoadRoot.get_child(0)
#		pass
	if LevelLoadRoot.get_child(0):
		Now2DSpaceLevel = LevelLoadRoot.get_child(0)
		pass
	else:
		printerr("Werror 2D Data Child")
		pass
	#DisconnecStatusSignal()
	if Now2DSpaceLevel:
		Now2DSpaceLevel.queue_free()
		pass
	SceneHasLoaded= false
	StartLoadScene = false
	$Dummy2DLoad.show()
	pass

signal hasLoadingCompleted
signal readyToPlayNow
func InitiateThatScene(scene_resource):
	a2DResource = scene_resource.instance()
	# https://docs.godotengine.org/en/3.1/tutorials/threads/thread_safe_apis.html#doc-thread-safe-apis
	#LevelLoadRoot.call_deferred("add_child", a2DResource)
	LevelLoadRoot.add_child(a2DResource)
	#Now2DSpaceLevel = LevelLoadRoot.get_child(0)
	#ConnecStatusSignal()
	# emit_signal("hasLoadingCompleted")
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

func DisconnecStatusSignal():
	if LevelLoadRoot.get_child(0):
		Now2DSpaceLevel = LevelLoadRoot.get_child(0)
		pass
	else:
		printerr("Werror 2D Data Child")
		pass
	
	if ConnectedSignal:
		if Now2DSpaceLevel:
	#		if Now2DSpaceLevel.is_connected("reportHP",self,"_EmitStatuso_HP"):
	#			Now2DSpaceLevel.disconnect("reportHP",self,"_EmitStatuso_HP")
	#			pass
	#		if Now2DSpaceLevel.is_connected("reportScore",self,"_EmitStatuso_Score"):
	#			Now2DSpaceLevel.disconnect("reportScore",self,"_EmitStatuso_Score")
	#			pass
			Now2DSpaceLevel.disconnect("reportHP",self,"_EmitStatuso_HP")
			Now2DSpaceLevel.disconnect("reportScore",self,"_EmitStatuso_Score")
			ConnectedSignal = false
			pass
		else:
			printerr("Werror 2D Disconnect")
			pass
		pass
	pass

func DisconnecStatusSignalPrevious():
	if ConnectedSignal:
		if Prev2DSpaceLevel:
			Prev2DSpaceLevel.disconnect("reportHP",self,"_EmitStatuso_HP")
			Prev2DSpaceLevel.disconnect("reportScore",self,"_EmitStatuso_Score")
			ConnectedSignal = false
			pass
		else:
			printerr("Werror 2D Disconnect Previous")
			pass
		pass
	pass

func ConnecStatusSignal():
#	for ins in $Level2DCartridgeSlot.get_children():
#		ins.connect("reportHPLevel",self,"_EmitStatuso")
#		pass
	print("Connect Signal 2D")
	if LevelLoadRoot.get_child(0):
		Now2DSpaceLevel = LevelLoadRoot.get_child(0)
		pass
	else:
		printerr("Werror 2D Data Child")
		pass
	
	if !ConnectedSignal:
		if Now2DSpaceLevel:
#			if !Now2DSpaceLevel.is_connected("reportHP",self,"_EmitStatuso_HP"):
#				Now2DSpaceLevel.connect("reportHP",self,"_EmitStatuso_HP")
#				pass
#			if !Now2DSpaceLevel.is_connected("reportScore",self,"_EmitStatuso_Score"):
#				Now2DSpaceLevel.connect("reportScore",self,"_EmitStatuso_Score")
#				pass
			Now2DSpaceLevel.connect("reportHP",self,"_EmitStatuso_HP")
			Now2DSpaceLevel.connect("reportScore",self,"_EmitStatuso_Score")
#			ConnectedSignal = true
			pass
		else:
			printerr("Werror 2D connect")
			pass
		pass
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if custom_Resource_Queue.is_ready(Raw2DSpaceLevelPath):
		SceneHasLoaded = true
		print("Queue is ready " + Raw2DSpaceLevelPath)
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
		if not StartLoadScene:
			
			InitiateThatScene(custom_Resource_Queue.get_resource(Raw2DSpaceLevelPath))
			#ConnecStatusSignal()
			StartLoadScene = true
			hasMeLoading = false
			emit_signal("readyToPlayNow")
			pass
		pass
	
	emit_signal("a2D_Loading_ProgressBar", ProgressValue)
	pass


func _EmitStatuso_HP(HPleveli):
	emit_signal("TellHP",HPleveli)
	pass
func _EmitStatuso_Score(ScoreLeveli):
	emit_signal("TellScore",ScoreLeveli)
	#print("Score Leveli 2D = " + String(ScoreLeveli))
	pass
