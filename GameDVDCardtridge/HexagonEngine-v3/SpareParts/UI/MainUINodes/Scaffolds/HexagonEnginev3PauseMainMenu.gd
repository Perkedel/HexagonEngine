extends Control

@onready var tween = get_tree().create_tween()
@onready var thisScaffold = $KonMenu
@onready var titler = $KonMenu/TitleHeader
@onready var navigator = $KonMenu/MenuNavigation
@onready var menuContaining = $KonMenu/MenuNavigation/MainMenu/Sidren
@onready var MenuNavList = [
	$KonMenu/MenuNavigation/MainMenu,
	$KonMenu/MenuNavigation/ConfirmationDialog,
]
var MenuNavListActive:int = 0
@onready var nextScaffold = $NextScaffold
@export var howLong: float = .5
@export_enum("Go to gameplay", 'Select Level', 'Select Save') var playButtonWillDo:String = 'Go to gameplay' # What will Main Menu Play button do?
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal doChangeDVD
signal doShutdown
@onready var PortraitMode = false
var isPauseMenu:bool = false # for combo PauseMainMenu.
@export var nextScaffoldScene:PackedScene
var nextScaffoldInstance:Control

#@export_group('Scenes')

func preAnimate():
	var NavpositionBefore:Vector2 = navigator.position
	if tween:
		tween.kill()
	tween = get_tree().create_tween()
#	tween.interpolate_property(titler, "position", Vector2(0,-titler.size.y),Vector2.ZERO, howLong, Tween.TRANS_LINEAR, Tween.EASE_IN)
#	tween.interpolate_property(navigator, "position", Vector2(0,navigator.position.y+navigator.size.y),NavpositionBefore, howLong, Tween.TRANS_LINEAR, Tween.EASE_IN)
	
#	tween.start()
	
#	titler.position =  Vector2(0,-999)
#	navigator.position = Vector2(0,navigator.position.y*2)
	#tween.tween_property(titler,"position",Vector2.ZERO,howLong)
	#tween.tween_property(navigator,"position",NavpositionBefore,howLong)
	pass

func goToThisScaffold(here:PackedScene) -> Control:
	nextScaffoldInstance = here.instantiate()
	thisScaffold.hide()
	nextScaffold.add_child(nextScaffoldInstance)
	return nextScaffoldInstance
	pass

func _hideAllNavigator():
	for an in MenuNavList:
		an.hide()
		pass
	pass

func resetMenuNavList():
#	_hideAllNavigator()
#	MenuNavList[0].show()
	changeNavigator(0)
	pass

func askConfirm():
#	_hideAllNavigator()
#	MenuNavList[1].show()
	changeNavigator(1)
	pass

func changeNavigator(to:int=0):
	print('change nav to ' + String.num(to))
	_hideAllNavigator()
	MenuNavList[to].show()
	MenuNavListActive = to
#	for isThisButton in MenuNavList[to].get_child(0).get_children():
#		if isThisButton is Button:
#			isThisButton.grab_focus()
#			break
#			pass
#		else:
#			pass
#		pass
	pass

func changeMenu(to:String):
	match(to):
		'MainMenu':
			changeNavigator(0)
		_:
			pass
	pass

func killThatNav():
	nextScaffold.get_child(0).queue_free()
	thisScaffold.show()
	resetMenuNavList()
	pass

func goBack():
	killThatNav()
	pass

func preFocus():
#	menuContaining.get_child(0).grab_focus()
	pass

func _pressPlayButton():
	
	pass

func closePauseMenu():
	print('raye')
	Singletoner.pressAMenuButton('Play')
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	preAnimate()
	preFocus()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _input(event: InputEvent) -> void:
	if visible:
		#print('afafa')
		if event is InputEvent:
			if event.is_action_released('ui_cancel'):
				#print('aafa')
				match(MenuNavListActive):
					0:
						# on main menu
						# check we are actually on main menu, or just pause game, and if game is always ON like Niko
						# no no, uhh. if we're on main menu, get out to Press Start Button.
						#closePauseMenu()
						pass
					1:
						# on are you sure to quit
						pass
					_:
						pass
				pass
			elif event.is_action_released('ui_pause'):
				#print('rraa')
				match(MenuNavListActive):
					0:
						# on main menu
						#closePauseMenu()
						pass
					1:
						# on are you sure to quit
						pass
					_:
						pass
				pass
			else:
				pass
			pass
		pass
	pass

func _notification(what: int) -> void:
	match(what):
		NOTIFICATION_VISIBILITY_CHANGED:
			if visible:
				
				pass
			pass
		_:
			pass
	pass
