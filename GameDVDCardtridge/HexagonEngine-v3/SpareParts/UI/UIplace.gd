extends Control

@onready var PauseMainMenuNode = $PauseMainMenu
@onready var GameplayHUDMenuNode = $GameplayHUDMenu
@onready var JustPauseMenuNode = $JustPauseMenu
@onready var AreYouSureDialog = $SystemDialogues/AreYouSureDialog
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal doChangeDVD
signal doShutdown
enum DialogConfirmsFor {Nothing = 0, ChangeDVD = 1, QuitGame = 2, LeaveLevel = 3}
@export var DialogSelectAction: DialogConfirmsFor

func preloadPauseMainMenu(scened:PackedScene):
	PauseMainMenuNode.add_child(scened.instantiate())
	for mes in PauseMainMenuNode.get_children():
		mes.connect("doChangeDVD", Callable(self, "_on_ChangeDVD_do"))
		mes.connect("doShutdown", Callable(self, "_on_Shutdown_do"))

func preloadGameplayHUDMenu(scened:PackedScene):
	GameplayHUDMenuNode.add_child(scened.instantiate())

func preloadJustPauseMenu(scened:PackedScene):
	JustPauseMenuNode.add_child(scened.instantiate())

func backToMainMenu():
	PauseMainMenuNode.show()
	PauseMainMenuNode.get_child(0).preAnimate()
	GameplayHUDMenuNode.hide()
	JustPauseMenuNode.hide()
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_ChangeDVD_do():
	emit_signal("doChangeDVD")

func _on_Shutdown_do():
	emit_signal("doShutdown")
