extends Node

#class_name Singletoner

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

var currentMenu:String = 'MainMenu'
var prevMenu:String = 'MainMenu'

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

# Posess a character
func addPosess(forThisNode:Node,toWhom:int=0):
#	if Posesser:
#		return Posesser.addPosess(forThisNode,toWhom)
#	else:
#		return forThisNode
	pass

func replacePosess(withThisNode:Node,toWhom:int=0):
#		return Posesser.replacePosess(withThisNode,toWhom)
		pass

func clearPosess(toWhom):
#	Posesser.clearPosess(toWhom)
	pass

# monitor a character node for HUD
func monitorThisCharacter(person:Node) -> Node:
#	print('pls yo monitor')
	if dvdNode:
		if dvdNode.has_method('monitorThisCharacter'):
#			print('To monitor a character')
			return dvdNode.call('monitorThisCharacter',person)
			pass
		pass
	return person
	pass

# set icon for score meter
func setScoreIcon(into:Texture):
#	print_rich('[b]SET SCORE ICON[/b]')
	if dvdNode:
#		print_rich('[b]SET SCORE ICON[/b]')
		if dvdNode.has_method('setScoreIcon'):
#			print_rich('[b]SET SCORE ICON[/b]')
			dvdNode.call('setScoreIcon',into)
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
#	SceneLoader.connect("on_scene_loaded", Callable(self, "_BiosLoaded"))
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
#		Kixlonzing.SaveKixlonz()
		pass
	pass

func assignLoadedDVD(thisThingRightHere:Node):
	daLoadedDVD = thisThingRightHere

func changeDVD():
	if daLoadedDVD:
#		if daLoadedDVD.has_signal("ChangeDVD_Exec"):
#			daLoadedDVD.emit_signal("ChangeDVD_Exec")
#			pass
		pass
	
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

func change_scene_with_path(thisOne:String):
	# again, use Godot's way.
	_change_scene_with_path_deferred.call_deferred(thisOne)
	pass

func _change_scene_with_path_deferred(thisOne:String):
	get_tree().current_scene.free()
	var pleaseLoadThis: = ResourceLoader.load(thisOne) as PackedScene
	var pleaseInstanceThis: = pleaseLoadThis.instantiate()
	get_tree().current_scene = null
	get_tree().root.add_child(pleaseInstanceThis)
	get_tree().current_scene = pleaseInstanceThis
	pass

func change_scene_with_resource(thisOne:PackedScene):
#	var pleaseInstanceThis: = thisOne.instantiate()
#	get_tree().current_scene.free()
#	get_tree().current_scene = null
#	get_tree().root.add_child(pleaseInstanceThis)
#	get_tree().current_scene = pleaseInstanceThis
	# Yes pls Godot's way.
	_change_scene_with_resource_deferred.call_deferred(thisOne)
	pass

func _change_scene_with_resource_deferred(thisOne:PackedScene):
	get_tree().current_scene.free()
	var pleaseInstanceThis: = thisOne.instantiate()
	get_tree().current_scene = null
	get_tree().root.add_child(pleaseInstanceThis)
	get_tree().current_scene = pleaseInstanceThis
	pass

func change_scene_with_instance(thisOne:Node):
#	get_tree().current_scene.free()
#	get_tree().current_scene = null
#	get_tree().root.add_child(thisOne)
#	get_tree().current_scene = thisOne
	
	# from now on use Godot's Demo way of changing scene exclusively!
	_change_scene_with_instance_deferred.call_deferred(thisOne)
	pass

func _change_scene_with_instance_deferred(thisOne:Node):
	get_tree().current_scene.free()
	get_tree().current_scene = null
	get_tree().root.add_child(thisOne)
	get_tree().current_scene = thisOne
	pass

func ExclusiveBoot(theResource):
	if theResource != null:
		hereTakeThisLoadedResource = theResource
		#andScronchMe = hereTakeThisLoadedResource.instance()
	if hereTakeThisLoadedResource:
		if hereTakeThisLoadedResource is PackedScene:
			change_scene_with_resource(theResource)
		elif hereTakeThisLoadedResource is Node:
			change_scene_with_instance(theResource)
		elif hereTakeThisLoadedResource is String:
			change_scene_with_path(theResource)
		else:
			printerr('ExclusiveBoot: The resource type is invalid!!! Expected: PackedScene, Node / Instance, OR String / Path')
	else:
		printerr('ExclusiveBoot: Resource Fail to load / Invalid')
	pass
	

func ReturnToBios():
#	SceneLoader.load_scene("res://HexagonEngineCore.tscn", {hii = "Cool and good"})
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
			if dvdNode:
				if dvdNode.has_method('closeRequest'):
	#				dvdNode.closeRequest()
					dvdNode.call('closeRequest')
					pass
			pass
		_:
			pass
	pass
