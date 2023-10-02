extends Node3D

class_name HexagonLevel
var whereMenuAreWe:String
var whereMenuAreWePrev:String

@export var mainPlayer:Node3D
@export var mainCamera:Node3D

@export_group('Features')
@export var excerciseActivateDeactivateMainNodes:bool = true

@export_group('Collecting')
@export var collectCoinGroup:String = 'coin'
@export var collectCoinIcon:Texture = preload("res://Sprites/MavrickleIcon.png")

var ponsInThisLevel:Array[Node3D]
var onCutscene:bool = false
var playerDeservesActive:bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#set score Icon
#	print_rich('[b]SET SCORE ICON[/b]')
	Singletoner.setScoreIcon.call_deferred(collectCoinIcon)
	
	# list all coins present in the level
	for i in get_children():
		if i.is_in_group(collectCoinGroup):
			ponsInThisLevel.append(i)
		pass
	
	if mainPlayer and mainCamera:
		if mainCamera.has_method('assignCamera'):
			mainCamera.call('assignCamera',mainPlayer)
			pass
		if mainPlayer.has_method('assignCamera'):
			mainPlayer.call('assignCamera',mainCamera)
			pass
		pass
	if mainPlayer:
		Singletoner.monitorThisCharacter(mainPlayer)
		pass
	recheckMenu()
	pass # Replace with function body.

func setActivateMainPlayerCam(to:bool=false,alsoMonitor:bool=true):
	if playerDeservesActive:
		if mainPlayer:
			if mainPlayer.has_method('setOwnActivate'):
				mainPlayer.call('setOwnActivate',to)
				pass
			if alsoMonitor:
				Singletoner.monitorThisCharacter(mainPlayer)
				pass
			pass
		if mainCamera:
			if mainCamera.has_method('setOwnActivate'):
				mainCamera.call('setOwnActivate',to)
				pass
			pass
	
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
#	super._process(delta)
	
	pass

func recheckMenu() -> String:
	
	whereMenuAreWe = Singletoner.currentMenu
	whereMenuAreWePrev = Singletoner.prevMenu
	match(Singletoner.currentMenu):
		'Gameplay':
			if excerciseActivateDeactivateMainNodes:
				setActivateMainPlayerCam(true)
				pass
			pass
		'MainMenu':
			if excerciseActivateDeactivateMainNodes:
				setActivateMainPlayerCam(false)
				pass
			pass
		_:
			pass
	return Singletoner.currentMenu

func _notification(what: int) -> void:
	match(what):
		_:
			pass
