extends StaticBody
class_name InteractMe

# Interact with Mitch Makes Things https://youtu.be/C_-faOyIuTQ

export var do_prerequisite = false
var prerequisite_done = false
export var prerequisite_interact: NodePath
var prereq_watch: Node
export var is_toggle = true
export var is_goal = false
var has_Interacted = false
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var colorNotYet: Material
export var colorDid: Material
export var colorNotPrerequisiteYet: Material

signal Interacted()
signal InteractGoaled()

# Called when the node enters the scene tree for the first time.
func _ready():
	#$CSGMesh.material = colorNotYet
	if prerequisite_interact:
		prereq_watch = get_node(prerequisite_interact)
	
	if do_prerequisite:
		$CSGMesh.material = colorNotPrerequisiteYet
		pass
	else:
		$CSGMesh.material = colorNotYet
	pass # Replace with function body.

func interaction_can_interact(interactionComponentParent : Node) -> bool:
	return interactionComponentParent is HeroicPlayer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if do_prerequisite:
		if prerequisite_done:
			return
		
		if prereq_watch.has_method("interaction_interact"):
			prerequisite_done = prereq_watch.has_Interacted
			
			if prerequisite_done:
				$CSGMesh.material = colorNotYet
			pass
		pass 

func interaction_interact(interactionComponentParent : Node) -> void:
	if do_prerequisite and not prerequisite_done:
		return
	
	if has_Interacted:
		if is_toggle:
			$CSGMesh.material = colorNotYet
			has_Interacted = false
		return
	
	# DO Something
	emit_signal("Interacted")
	$CSGMesh.material = colorDid
	
	if is_goal:
		emit_signal("InteractGoaled")
		pass
	has_Interacted = true
	
	#collision_layer = collision_layer ^ 8
