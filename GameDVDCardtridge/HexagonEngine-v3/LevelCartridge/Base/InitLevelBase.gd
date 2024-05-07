extends Node3D

class_name HexagonLevel
var whereMenuAreWe:String
var whereMenuAreWePrev:String

@export var mainPlayer:Node3D
@export var mainCamera:Node3D
@export var mainPlayer2D:Node2D
@export var mainCamera2D:Node2D
@export var mainPhantomCamera:Camera3D
@export var usualPhantomCameraName:String = 'MainCamera3DPhantomed'

@export_group('Features')
@export var excerciseActivateDeactivateMainNodes:bool = true
@export var usePhantomCamera:bool = true

@export_group('Collecting')
@export var collectCoinGroup:String = 'coin'
@export var collectCoinIcon:Texture = preload("res://Sprites/MavrickleIcon.png")

var ponsInThisLevel:Array[Node3D]
var onCutscene:bool = false
var playerDeservesActive:bool = true
@onready var phantomCamera3D:PhantomCamera3D = $PhantomCamera3D
@onready var phantomCamera2D:PhantomCamera2D = $"2DSpace/PhantomCamera2D"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#super()
	#set score Icon
#	print_rich('[b]SET SCORE ICON[/b]')
	Singletoner.setScoreIcon.call_deferred(collectCoinIcon)
	
	# attempt to obtain phantomed camera
	#mainPhantomCamera = owner.get_node('%'+usualPhantomCameraName)
	
	# list all coins present in the level
	for i in get_children():
		if i.is_in_group(collectCoinGroup):
			ponsInThisLevel.append(i)
		pass
	
	if mainPlayer:
		if mainCamera:
			if mainCamera.has_method('assignCamera'):
				mainCamera.call('assignCamera',mainPlayer)
				pass
		
		if mainPlayer.has_method('assignCamera'):
			mainPlayer.call('assignCamera',mainCamera)
			pass
		if mainPhantomCamera:
			if mainPlayer.has_method('assignPhantomCamera'):
				mainPlayer.call('assignPhantomCamera',mainPhantomCamera)
				pass
		pass
		
		if phantomCamera3D:
			phantomCamera3D.set_follow_target(mainPlayer)
		Singletoner.monitorThisCharacter(mainPlayer)
		pass
	if mainPlayer2D:
		if phantomCamera2D:
			phantomCamera2D.set_follow_target(mainPlayer2D)
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
			if not usePhantomCamera:
				if mainCamera.has_method('setOwnActivate'):
					mainCamera.call('setOwnActivate',to)
					pass
			pass
		if mainPhantomCamera:
			if usePhantomCamera:
				
				pass
		if phantomCamera3D:
			
			pass
		if phantomCamera2D:
			pass
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
#	super._process(delta)
	
	pass

func loadLevel(thisThing:PackedScene):
	
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
	if mainPlayer:
		if mainPlayer.has_method('recheckMenu'):
			mainPlayer.call('recheckMenu')
	if mainPlayer2D:
		if mainPlayer2D.has_method('recheckMenu'):
			mainPlayer2D.call('recheckMenu')
	return Singletoner.currentMenu

func _notification(what: int) -> void:
	match(what):
		_:
			pass
