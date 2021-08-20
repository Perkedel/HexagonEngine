extends Node

export (bool) var isPlayingGameNow
export (bool) var isGamePaused
var hereTakeThisLoadedResource
var andScronchMe
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (NodePath) var daLoadedDVD

# Singleton. Ahlinya Intinya inti, Core of the core. 

# Called when the node enters the scene tree for the first time.
func _ready():
	SceneLoader.connect("on_scene_loaded", self, "_BiosLoaded")
	#AutoSpeaker.stream = preload("res://Audio/EfekSuara/425728__moogy73__click01.wav")
	#AutoSpeaker.play()
	AutoSpeaker.playSFXNow(load("res://Audio/EfekSuara/425728__moogy73__click01.wav"))
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func assignLoadedDVD(thisThingRightHere:NodePath):
	daLoadedDVD = thisThingRightHere

func changeDVD():
	if daLoadedDVD:
		if daLoadedDVD.has_signal("ChangeDVD_Exec"):
			daLoadedDVD.emit_signal("ChangeDVD_Exec")
			pass
		pass

func shutdownNowDVD():
	if daLoadedDVD:
		if daLoadedDVD.has_signal("Shutdown_Exec"):
			daLoadedDVD.emit_signal("Shutdown_Exec")
			pass
		pass

func Nonaktifkan_Sistem():
	#AutoSpeaker.stream = preload("res://GameDVDCardtridge/GeogonPolymetryHaventDoneYetSalvage/Audio/Explosion bin cropped.wav")
	#AutoSpeaker.play()
	Kixlonzing.SaveKixlonz()
	Settingers.SettingSave()
	print("Quit Game!")
	#get_tree().queue_delete(get_tree())
	#get_tree().queue_free()
	#yield(AutoSpeaker, "finished")
	get_tree().quit()
	pass

func _exit_tree():
	pass

func PauseGameNow():
	get_tree().paused = true
	isGamePaused = true
	pass

func ResumeGameNow():
	get_tree().paused = false
	isGamePaused = false
	pass

func change_scene_with_resource(thisOne):
	var pleaseInstanceThis = thisOne.instance()
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
