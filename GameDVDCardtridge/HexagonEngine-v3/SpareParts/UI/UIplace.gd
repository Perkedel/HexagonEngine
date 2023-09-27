extends Control

@onready var PauseMainMenuNode = $PauseMainMenu # Main Menu Pause combo
@onready var GameplayHUDMenuNode = $GameplayHUDMenu
@onready var JustPauseMenuNode = $JustPauseMenu # Dedicated Pause menu (not used in most Perkedel apps)
@onready var AreYouSureDialog = $SystemDialogues/AreYouSureDialog
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal doChangeDVD
signal doShutdown
signal doPressPlay
signal doPressSetting
signal doPressExtras
signal doPressExit
enum DialogConfirmsFor {Nothing = 0, ChangeDVD = 1, QuitGame = 2, LeaveLevel = 3}
@export var DialogSelectAction: DialogConfirmsFor
@export var StartFromWhere:String = 'MainMenu'

@export_group('Product Title')
@export var titleName:String = 'Hexagon Engine'
@export var titleIcon:Texture = preload("res://Sprites/HexagonEngineSymbolVeryLarge.png")

func setHP(value:float):
	setHPmeter(value)
	pass

func preloadPauseMainMenu(scened:PackedScene):
	var thisOne:= scened.instantiate()
	
	thisOne.titleName = titleName
	thisOne.titleIcon = titleIcon
	PauseMainMenuNode.add_child(thisOne)
	for mes in PauseMainMenuNode.get_children():
		mes.connect("doChangeDVD", Callable(self, "_on_ChangeDVD_do"))
		mes.connect("doShutdown", Callable(self, "_on_Shutdown_do"))

func preloadGameplayHUDMenu(scened:PackedScene):
	GameplayHUDMenuNode.add_child(scened.instantiate())

func preloadJustPauseMenu(scened:PackedScene):
	JustPauseMenuNode.add_child(scened.instantiate())

func changeMenu(to:String):
	for an in get_children():
		an.hide()
		pass
	match(to):
		'Gameplay':
			changeGameplayHUDMenuNavigator(0)
			pass
		'MainMenu':
			changePauseMainMenuNavigator(0)
			pass
		'Pause':
			# TODO: for dedicated pause menu!
			changePauseMainMenuNavigator(0)
			pass
		'CancelQuit':
			changePauseMainMenuNavigator(0)
			pass
		'ChangeDVD':
			pass
		'Shutdown':
			pass
		'ConfirmQuit':
			print('QUitio')
			changePauseMainMenuNavigator(1)
			pass
		_:
			pass
	pass

func backToMainMenu():
	Singletoner.setGamePaused(false)
	PauseMainMenuNode.show()
#	PauseMainMenuNode.get_child(0).preAnimate()
	GameplayHUDMenuNode.hide()
	JustPauseMenuNode.hide()
	pass

func resumeTheGame():
	PauseMainMenuNode.hide()
	GameplayHUDMenuNode.show()
	JustPauseMenuNode.hide()
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	match(StartFromWhere):
		'MainMenu':
			backToMainMenu()
			pass
		_:
			pass
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_ChangeDVD_do():
	emit_signal("doChangeDVD")

func _on_Shutdown_do():
	emit_signal("doShutdown")

func setHPmeter(to:float):
	# must be between 0 to 100. handle extra number calculation in the main DVD node!
	if GameplayHUDMenuNode.get_child(0):
		if GameplayHUDMenuNode.get_child(0).has_method('setHP'):
			GameplayHUDMenuNode.get_child(0).call('setHP',to)
			pass
		pass
	pass

func changePauseMainMenuNavigator(to:int = 0):
	#print('chagnene')
	PauseMainMenuNode.show()
	if PauseMainMenuNode.get_child(0):
		#print('adsfreg#')
		if PauseMainMenuNode.get_child(0).has_method("changeNavigator"):
			print('afsderg')
			#[as] pass
			PauseMainMenuNode.get_child(0).changeNavigator(to)
			pass
		pass
	pass

func changeGameplayHUDMenuNavigator(to:int = 0):
	GameplayHUDMenuNode.show()
	pass

func _notification(what: int) -> void:
	if visible:
		match(what):
			NOTIFICATION_WM_CLOSE_REQUEST:
				#pause game &
				#changePauseMainMenuNavigator(1)
				#Singletoner.pressAMenuButton('Shutdown')
				pass
			_:
				pass
		pass
	pass
