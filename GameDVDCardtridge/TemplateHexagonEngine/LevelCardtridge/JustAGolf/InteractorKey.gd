extends Area3D

@onready var ortu = get_parent()
# interactable
@export var is_ride = false
@export var being_rode = false
var activated : bool = true
@export var do_prerequisite = false
var prerequisite_done = false
@export var prerequisite_interact: NodePath
var prereq_watch: Node
@export var is_toggle = true
@export var is_goal = false
var has_Interacted = false
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func setYLaunch(value:float):
	ortu.setYLaunch(value)
	pass

func interaction_can_interact(interactionComponentParent : Node) -> bool:
	#$"../Speeker".play()
	return interactionComponentParent is HeroicPlayer

func interaction_interact(interactionComponentParent : Node) -> void:
	#$"../Speeker".play()
	
	if do_prerequisite and not prerequisite_done:
		return

	if has_Interacted:
		if is_toggle:
			#$CSGMesh.material = colorNotYet
			ortu.has_Interacted = false
		return

	# DO Something
	emit_signal("Interacted")
#	if is_ride:
#		if being_rode:
#			ortu.being_rode = false
#		else:
#			ortu.being_rode = true
#		pass
	ortu.puttPower = 10.0
	ortu.launchGolfBall()
	#ortu.being_rode = false
	#$CSGMesh.material = colorDid

	if is_goal:
		emit_signal("InteractGoaled")
		pass
	ortu.has_Interacted = true
	pass

func interaction_rideable(interactionComponentParent : Node, setRiding:bool) -> void:
	#$"../Speeker".play()
	if do_prerequisite and not prerequisite_done:
		return
	#ortu.being_rode = setRiding
	ortu.setBeingRode(setRiding)
#	if is_ride:
#		if being_rode:
#			ortu.being_rode = false
#		else:
#			ortu.being_rode = true
#		pass
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if ortu:
		is_ride = ortu.is_ride
		being_rode = ortu.being_rode
		#ortu.being_rode = being_rode
		activated = ortu.activated
		do_prerequisite = ortu.do_prerequisite
		prerequisite_done = ortu.prerequisite_done
		prerequisite_interact = prerequisite_interact
		is_toggle = ortu.is_toggle
		has_Interacted = ortu.has_Interacted
		is_goal = ortu.is_goal
	pass
