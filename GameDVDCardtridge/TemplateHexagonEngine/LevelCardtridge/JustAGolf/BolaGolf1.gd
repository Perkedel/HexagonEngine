extends RigidBody3D

@onready var puttPower = 0.0
@onready var isPullingPutt = false
@onready var pullRelativeScreenPos = Vector2.ZERO
@onready var pushRotation = 0
@onready var amIwalking = false
@export (Material) var PowerMeterRelax = load("res://GameDVDCardtridge/TemplateHexagonEngine/LevelCardtridge/JustAGolf/PowerMeterRelax.tres")
@export (Material) var PowerMeterStress = load("res://GameDVDCardtridge/TemplateHexagonEngine/LevelCardtridge/JustAGolf/PowerMeterStress.tres")
@export (AudioStream) var PuttSound = load("res://Audio/EfekSuara/425728__moogy73__click01.wav")
@onready var virtualCountdownCompensate = 1
var virtualTimer = 1

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
signal stroked
signal noLongerWalking
signal entered_goal


# Called when the node enters the scene tree for the first time.
func _ready():
	$PowerMeter.material = PowerMeterRelax
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_ride:
		activated = true if being_rode else false
	else:
		activated = true
	
	
	pass

func setBeingRode(what):
	$Speeker.play()
	being_rode = what

func gotStroke():
	emit_signal("stroked")
	amIwalking = true
	pass

func launchGolfBall():
	
	if !amIwalking:
		print("WEEEEEEEEEEEEEEEEEEEEE!!!!")
		$Speeker.play()
		$PowerMeter.material = PowerMeterStress
		apply_central_impulse(Vector3(sin(pushRotation)*-puttPower,0,cos(pushRotation)*-puttPower))
		
		emit_signal("stroked")
		amIwalking = true
		pass
	pass

func okIamStopped():
	if amIwalking:
		print("OK I am done.")
		$PowerMeter.material = PowerMeterRelax
		
		emit_signal("noLongerWalking")
		amIwalking = false
		pass
	pass

func setYLaunch(value:float):
	#print("set Y rotation ", value)
	pushRotation = value
	$PowerMeter.global_rotate(Vector3.UP,pushRotation)
	pass

func _input(event):
	
	if activated:
		if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
			if !isPullingPutt and event.pressed:
				pullRelativeScreenPos = event.position
				isPullingPutt = true
				print("Mouse Click at ", pullRelativeScreenPos)
				pass
			if isPullingPutt and !event.pressed:
				print("Launch Golf Ball for ", puttPower , " N")
				launchGolfBall()
				puttPower = 0
				pullRelativeScreenPos = Vector2.ZERO
				isPullingPutt = false
				print("Mouse Drop at ", event.position)
				pass
			pass
		if event is InputEventMouseMotion:
			
			if isPullingPutt:
				puttPower = (event.position.y - pullRelativeScreenPos.y) / 10
				puttPower = clamp(puttPower, 0, 10)
				$PowerMeter.scale.z = puttPower
				pass
			pass
		pass
	
	if being_rode:
		
		pass
	pass

func _physics_process(delta):
	
	if amIwalking:
		if virtualTimer > 0:
			virtualTimer -= get_physics_process_delta_time()
			pass
		else:
			virtualTimer = virtualCountdownCompensate
			if linear_velocity == Vector3(0.00,0.00,0.00) and angular_velocity == Vector3(0.00,0.00,0.00):
				if amIwalking:
					okIamStopped()
					# amIwalking = false
					pass
				pass
			pass
		pass
	else:
		virtualTimer = virtualCountdownCompensate
		pass
	pass

#func interaction_can_interact(interactionComponentParent : Node) -> bool:
#	return interactionComponentParent is HeroicPlayer
#
#func interaction_interact(interactionComponentParent : Node) -> void:
#	if do_prerequisite and not prerequisite_done:
#		return
#
#	if has_Interacted:
#		if is_toggle:
#			#$CSGMesh.material = colorNotYet
#			has_Interacted = false
#		return
#
#	# DO Something
#	emit_signal("Interacted")
#	#$CSGMesh.material = colorDid
#
#	if is_goal:
#		emit_signal("InteractGoaled")
#		pass
#	has_Interacted = true
#	pass


func _on_BolaGolf1_body_entered(body):
	# if it is golf club then consider it stroke
	pass # Replace with function body.


func _on_InteractorKey_body_entered(body):
	pass # Replace with function body.
