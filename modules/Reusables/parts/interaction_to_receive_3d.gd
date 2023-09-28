extends Area3D

# https://youtu.be/ajCraxGAeYU?si=hmEJ0ZDwCmMHHYMY
# https://youtu.be/yJpt9a_93Ag?si=VpxoCMElZcSPxLwP
# can you pls make it simpler?
@export var allowAllType:bool = false
@export var expectedGroup:String = 'player'
var theBodyOfThat:Node3D
signal receivedInteraction(from:StringName,command:String,argument:String)
signal receivedHoverInteraction(from:Node3D)
signal receivedUnhoverInteraction(from:Node3D)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func receiveInteraction(command:String='activate',argument:String=''):
	if theBodyOfThat:
		emit_signal('receivedInteraction',theBodyOfThat.name,command,argument)
	pass

func receiveHoverInteraction(from:Node3D):
	if from.is_in_group(expectedGroup) or allowAllType:
		theBodyOfThat = from
		emit_signal('receivedHoverInteraction',from)
		pass
	pass

func receiveUnhoverInteraction(from:Node3D):
	if (from.is_in_group(expectedGroup) or allowAllType) and theBodyOfThat == from:
		emit_signal('receivedUnhoverInteraction',from)
		theBodyOfThat = null
		pass
	pass


func _on_body_entered(body: Node3D) -> void:
	receiveHoverInteraction(body)
	pass # Replace with function body.


func _on_body_exited(body: Node3D) -> void:
	receiveUnhoverInteraction(body)
	pass # Replace with function body.
