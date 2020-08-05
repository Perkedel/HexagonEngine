extends Control

onready var PauseMainMenuNode = $PauseMainMenu
onready var GameplayHUDMenuNode = $GameplayHUDMenu
onready var JustPauseMenuNode = $JustPauseMenu
onready var AreYouSureDialog = $SystemDialogues/AreYouSureDialog
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal doChangeDVD
signal doShutdown
enum DialogConfirmsFor {Nothing = 0, ChangeDVD = 1, QuitGame = 2, LeaveLevel = 3}
export(DialogConfirmsFor) var DialogSelectAction

func preloadPauseMainMenu(scened:PackedScene):
	PauseMainMenuNode.add_child(scened.instance())
	for mes in PauseMainMenuNode.get_children():
		mes.connect("doChangeDVD", self, "_on_ChangeDVD_do")
		mes.connect("doShutdown", self, "_on_Shutdown_do")

func preloadGameplayHUDMenu(scened:PackedScene):
	GameplayHUDMenuNode.add_child(scened.instance())

func preloadJustPauseMenu(scened:PackedScene):
	JustPauseMenuNode.add_child(scened.instance())

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
