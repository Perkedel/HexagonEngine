extends Node2D

@export var NextLevelPath: PackedScene
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal reportHP(level)
signal reportScore(number)
signal reportNextLevel(cardWhich)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Singletoner.isGamePaused:
		$CanvasLayer/NextUI.hide()
		pass
	else:
		$CanvasLayer/NextUI.show()
		pass
	pass


func _on_LevelCompleteNow_pressed():
	$CanvasLayer/NextUI/LevelCompleteNow.hide()
	$CanvasLayer/YayComplete.PopThisDialogWith("Level Complete, cool and good!")
	pass # Replace with function body.


func _on_YayComplete_BackMenuButton():
	
	pass # Replace with function body.


func _on_YayComplete_NextLevelButton():
	emit_signal("reportNextLevel",NextLevelPath)
	pass # Replace with function body.


func _on_YayComplete_ResetButton():
	
	pass # Replace with function body.
