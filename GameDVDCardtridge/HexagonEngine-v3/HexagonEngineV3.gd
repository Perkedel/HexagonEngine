extends Node

@export_subgroup('Main Navigation')
@onready var LevelSpace = $LevelSpace
@onready var UIplace = $UICanvas/UIplace
@onready var LevelSpacer = $LevelSpace
@export var PauseMainMenuFile: PackedScene
@export var GameplayHUDMenuFile: PackedScene
@export var JustPauseMenuFile: PackedScene
@export var InitLevelFile:PackedScene

@export_subgroup('Sub Navigation')
@export var SettingMenuFile:PackedScene

@export_subgroup('Startup')
@export var StartFromGameHUD: bool = true
@export_enum('MainMenu','Gameplay', 'Pause','Custom','CheckSaveMain', 'SaveMenu', 'LevelMenu', 'OOBE', 'Exit') var StartFromWhere:String = 'MainMenu'
var currentWhere:String = 'MainMenu'
var prevWhere:String = 'MainMenu'

@export_subgroup('Commands')
@export_enum("Go to gameplay", 'Select Level', 'Select Save') var PressPlayTo:String = 'Go to gameplay'

@export_subgroup('Parameters')
@export var useDedicatedPause:bool = false
@export var PausingWillFreeze:bool = false
@export var PausingWillLeadsTo:String = 'MainMenu' #or 'Pause' for dedicated
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var levelInstance:Node
var monitoredCharacter:Node

signal ChangeDVD_Exec()
signal Shutdown_Exec()
enum CanvasLayerMode {Usual = 1, Priority = 10}

func monitorThisCharacter(person:Node) -> Node:
	monitoredCharacter = person
	return person
	pass

func SaveEverythingFirst():
	# Save this DVD data
	
#	Kixlonzing.SaveKixlonz()
#	Settingers.SettingSave()
	pass

func ChangeTheDVDnow():
	print("Change Da DVD")
	SaveEverythingFirst()
	Singletoner.changeDVD()
	#emit_signal("ChangeDVD_Exec")

func ShutdownHexagonEngineNow():
	print("Shutdown da Hexagon Engine")
	SaveEverythingFirst()
	Singletoner.shutdownNow()
	#emit_signal("Shutdown_Exec")

func loadLevel(ofThis:PackedScene)->Node:
	levelInstance = ofThis.instantiate()
	LevelSpacer.add_child(levelInstance)
	return levelInstance
	pass

func changeMenu(to:String = 'MainMenu'):
	prevWhere = currentWhere
	UIplace.changeMenu(to)
	match(to):
		'MainMenu':
			pass
		'Gameplay':
			pass
		_:
			pass
	currentWhere = to
	Singletoner.currentMenu = currentWhere
	Singletoner.prevMenu = prevWhere
	if levelInstance.has_method('recheckMenu'):
		levelInstance.call('recheckMenu')
		pass
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	if PauseMainMenuFile:
		UIplace.preloadPauseMainMenu(PauseMainMenuFile)
	if GameplayHUDMenuFile:
		UIplace.preloadGameplayHUDMenu(GameplayHUDMenuFile)
	if JustPauseMenuFile:
		UIplace.preloadJustPauseMenu(JustPauseMenuFile)
	if InitLevelFile:
		loadLevel(InitLevelFile)
		pass
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if monitoredCharacter:
#		print('has monitor')
		var maxHP:float = 100
		if monitoredCharacter.has_method('getMaxHP'):
			maxHP = monitoredCharacter.call('getMaxHP')
			# damn, this could've been done with Interface. 
			#Interface has variable, implement to everything so that a Node can ensure to 
			#have those value defined on the interface. 
			#now here treat as type, every different type of class will have this variable.
			pass
		if monitoredCharacter.has_method('getHP'):
			# HP bar 0 to 100. Character can have more!
			var rawHP:float = monitoredCharacter.call('getHP')
			UIplace.setHP((rawHP/maxHP)*100)
			pass
		pass
	pass

func _input(event: InputEvent) -> void:
	if event is InputEvent:
		if Input.is_action_just_pressed("ui_pause"):
			
			pass
		
		if event.is_action_pressed('ui_pause'):
			match(currentWhere):
				'MainMenu':
					print('main Play')
					Singletoner.pressAMenuButton('Play')
				'Pause':
					Singletoner.pressAMenuButton('Play')
					pass
				'Gameplay':
					Singletoner.pressAMenuButton('Pause')
					pass
				_:
					pass
			pass
		elif event.is_action_pressed('ui_cancel'):
			match(currentWhere):
				'MainMenu':
					print('main Play')
					Singletoner.pressAMenuButton('Play')
				'Pause':
					Singletoner.pressAMenuButton('Play')
					pass
				'Gameplay':
					pass
				'ConfirmQuit':
					Singletoner.pressAMenuButton('CancelQuit')
					pass
				_:
					pass
			pass
		pass
	pass

func pressAMenuButton(whichIs:String='MainMenu',Argument:String=''):
	#print('Menu Press: ' + whichIs + ' ' + Argument)
	match(whichIs):
		'Play':
			print('Playe')
			match(PressPlayTo):
				'Go to gameplay':
					changeMenu('Gameplay')
					pass
				'Select level':
					pass
				'Select save':
					pass
				_:
					pass
			pass
		'Options':
			pass
		'Extras':
			pass
		'Exit':
			print('exit')
			#UIplace.changePauseMainMenuNavigator(1)
			changeMenu('ConfirmQuit')
			pass
		'Shutdown':
			ShutdownHexagonEngineNow()
		'ChangeDVD':
			ChangeTheDVDnow()
			pass
		'CancelQuit':
			print('Cancel Quit')
			#UIplace.changePauseMainMenuNavigator(0)
			changeMenu('MainMenu')
		'Pause':
			print('poaus')
			changeMenu(PausingWillLeadsTo)
			pass
		_:
			pass
	pass

func closeRequest():
	Singletoner.pressAMenuButton('Exit')
	pass

func _notification(what: int) -> void:
	match(what):
		_:
			pass
	pass

func _on_AreYouSureDialog_NoImNotSure():
	pass # Replace with function body.


func _on_AreYouSureDialog_YesImSure():
	pass # Replace with function body.


func _on_UIplace_doChangeDVD():
	ChangeTheDVDnow()
	pass # Replace with function body.


func _on_UIplace_doShutdown():
	ShutdownHexagonEngineNow()
	pass # Replace with function body.
