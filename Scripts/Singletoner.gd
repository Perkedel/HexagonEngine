extends Node

@export var isPlayingGameNow:bool = false
@export var isGamePaused:bool = false
@export var activateBackButton:bool = true
var hereTakeThisLoadedResource
var andScronchMe
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
@export var daLoadedDVD:Node
@export var mainNode:Node
@export var dvdNode:Node

# Singleton. Ahlinya Intinya inti, Core of the core. 

# Set main Node. Therefore softwares can refer through this singletoner if they want to call Hexagon Engine Core stuffs
func iAmTheMainNode(theThing:Node):
	mainNode = theThing
	pass

func thisIsDvdNode(theThing:Node):
	dvdNode =  theThing
	pass

func unloadDVDNode():
	dvdNode = null
	pass

# Press a Menu on a DVD
func pressAMenuButton(whichIs:String='MainMenu',Argument:String=''):
	#print("adguuuuuuuuuuuuuuuuuuuuu")
	if dvdNode:
		if dvdNode.has_method('pressAMenuButton'):
			dvdNode.pressAMenuButton(whichIs,Argument)
			pass
		pass
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	SceneLoader.connect("on_scene_loaded", Callable(self, "_BiosLoaded"))
	#AutoSpeaker.stream = preload("res://Audio/EfekSuara/425728__moogy73__click01.wav")
	#AutoSpeaker.play()
	AutoSpeaker.playSFXNow(load("res://Audio/EfekSuara/425728__moogy73__click01.wav"))
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func saveEverythingFirst():
	if Engine.has_singleton("Settinger"):
		Settingers.SettingSave()
		pass
	if Engine.has_singleton("Kixlonzing"):
		Kixlonzing.SaveKixlonz()
		pass
	pass

func assignLoadedDVD(thisThingRightHere:Node):
	daLoadedDVD = thisThingRightHere

func changeDVD():
#	if daLoadedDVD:
#		if daLoadedDVD.has_signal("ChangeDVD_Exec"):
#			daLoadedDVD.emit_signal("ChangeDVD_Exec")
#			pass
#		pass
	
	pass

func shutdownNowDVD():
#	if daLoadedDVD:
#		if daLoadedDVD.has_signal("Shutdown_Exec"):
#			daLoadedDVD.emit_signal("Shutdown_Exec")
#			pass
#		pass
	
	Nonaktifkan_Sistem()
	pass

func shutdownNow():
	shutdownNowDVD()

func Nonaktifkan_Sistem():
	#AutoSpeaker.stream = preload("res://GameDVDCardtridge/GeogonPolymetryHaventDoneYetSalvage/Audio/Explosion bin cropped.wav")
	#AutoSpeaker.play()
	saveEverythingFirst()
	print("Quit Game!")
	#get_tree().queue_delete(get_tree())
	#get_tree().queue_free()
	#yield(AutoSpeaker, "finished")
	get_tree().quit()
	pass

func _exit_tree():
	pass

func setGamePaused(to:bool):
	get_tree().paused = to
	isGamePaused = to
	pass

func PauseGameNow():
	setGamePaused(true)
	pass

func ResumeGameNow():
	setGamePaused(false)
	pass

func change_scene_with_resource(thisOne):
	var pleaseInstanceThis = thisOne.instantiate()
	get_tree().current_scene.free()
	get_tree().current_scene = null
	get_tree().root.add_child(pleaseInstanceThis)
	get_tree().current_scene = pleaseInstanceThis
	pass

func change_scene_with_instance(thisOne:Node):
	get_tree().current_scene.free()
	get_tree().current_scene = null
	get_tree().root.add_child(thisOne)
	get_tree().current_scene = thisOne

func ExclusiveBoot(theResource):
	if theResource != null:
		hereTakeThisLoadedResource = theResource
		#andScronchMe = hereTakeThisLoadedResource.instance()
	if hereTakeThisLoadedResource:
		change_scene_with_resource(theResource)
	pass
	

func ReturnToBios():
	SceneLoader.load_scene("res://HexagonEngineCore.tscn", {hii = "Cool and good"})
	pass

func _BiosLoaded(scene):
	hereTakeThisLoadedResource = null
	print(scene.path)
	print(scene.instance.name)
	print(scene.props.hii)
	
	change_scene_with_instance(scene.instance)
	pass

func _notification(what: int) -> void:
	match(what):
		NOTIFICATION_WM_GO_BACK_REQUEST:
			# PECKING FINALLY BACK BUTTON!!!
			if activateBackButton:
#				var a = InputEventAction.new()
#				a.action = "ui_cancel"
#				a.button_pressed = true
#				Input.parse_input_event(a)
				pass
			pass
		NOTIFICATION_WM_CLOSE_REQUEST:
			# Press Close
			if dvdNode.has_method('closeRequest'):
				dvdNode.closeRequest()
				pass
			pass
		_:
			pass
	pass
