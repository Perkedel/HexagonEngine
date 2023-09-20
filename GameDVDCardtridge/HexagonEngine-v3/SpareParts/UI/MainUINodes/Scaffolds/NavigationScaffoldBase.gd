extends Control
class_name NavigationScaffold

@export var nextScaffoldScene:PackedScene
var nextScaffoldInstance:Control

func goToThisScaffold(here:PackedScene) -> Control:
	nextScaffoldInstance = here.instantiate()
	$ThisScaffold.hide()
	$NextScaffold.add_child(nextScaffoldInstance)
	return nextScaffoldInstance
	pass

func killThatNav():
	$NextScaffold.get_child(0).queue_free()
	$ThisScaffold.show()

func goBack():
	var parente = get_parent()
	if parente:
		parente.show()
		queue_free()
		pass

func _refreshCondition():
	if $NextScaffold.visible:
		pass
	else:
		if $ThisScaffold.visible:
			pass
		else:
			$ThisScaffold.show()
			pass
		pass
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
