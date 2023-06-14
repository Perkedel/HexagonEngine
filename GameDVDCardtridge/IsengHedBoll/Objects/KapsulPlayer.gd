extends RigidBody3D

@export var WanalogX:float = 0
@export var WanalogY:float = 0
@export var Cepatan:float = 20
var GayaLoncat = 0
@export var LoncatKuat:float = 5
@export var BisaPegang:bool = false
@export var PegangBola:bool = false
var ManaBola
@export var LemparArah:Vector3 = Vector3(10,10,0)
@export var TweenSetNow:bool = false
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

#func TweenStatus(what:bool):
#	match what:
#		true:
#			$TweenBola.interpolate_property(ManaBola,"global_translate", ManaBola.global_translate(Vector3(0,0,0)), $Tangan.global_translate(Vector3(0,0,0)), .5, Tween.TRANS_LINEAR, Tween.EASE_OUT)
#			$TweenBola.start()
#			pass
#		false:
#			$TweenBola.stop_all()
#			TweenSetNow = false
#			pass
#	pass

func immanageInputs():
#	WanalogX = clamp(Input.get_action_strength("AnalogKiri_x") - Input.get_action_strength("AnalogKiri_x-"), -1,1) 
	WanalogX = clamp(Input.get_axis("Jalan_Kiri","Jalan_Kanan"),-1,1)
#	WanalogY = clamp(Input.get_action_strength("AnalogKiri_y-") - Input.get_action_strength("AnalogKiri_y"), -1,1)
	WanalogY = clamp(Input.get_axis("Jalan_Belakang","Jalan_Depan"), -1,1)
#	print(String.num(WanalogX))
	#apply_central_impulse(Vector3(WanalogX,0,0))
	
	if Input.is_action_just_pressed("Melompat"):
		#apply_central_impulse(Vector3(0,LoncatKuat,0))
		GayaLoncat = LoncatKuat
		pass
	else:
		#GayaLoncat = 0
		pass
	
	if Input.is_action_just_pressed("Serang") or Input.is_action_just_pressed("clic_kiri"):
		if BisaPegang and ManaBola: #&&
			match PegangBola:
				true:
					if ManaBola:
						#TweenStatus(false)
						ManaBola.apply_central_impulse(LemparArah)
						pass
					PegangBola = false
					pass
				false:
					PegangBola = true
					pass
				
			
			pass
		else:
			pass
		pass
	
	pass

func ImmanageBola():
	if ManaBola:
		if PegangBola:
			#ManaBola.global_transform = $Tangan.global_transform
			#ManaBola.linear_velocity = linear_velocity
			var a = $Tangan.get_global_transform().origin
			var b = ManaBola.get_global_transform().origin
			ManaBola.set_linear_velocity(((a + Vector3(WanalogX/4,0,0))-b)*10)
			if ManaBola.get("timer") != null:
				ManaBola.timer = 0
				pass
#			if not TweenSetNow:
#				TweenStatus(true)
#				TweenSetNow = true
#				pass
			pass
		pass
	else:
		PegangBola = false
		pass
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.

func _physics_process(delta):
	ImmanageBola()
	apply_central_impulse(Vector3(WanalogX*Cepatan*delta,GayaLoncat,0))
	if GayaLoncat > 0:
		GayaLoncat = 0
		pass
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	immanageInputs()
	pass

func _input(event):
	if event is InputEventAction:
#		if event.is_action_pressed("Loncat"):
#			apply_central_impulse(Vector3(0,LoncatKuat,0))
#			pass
		pass
	pass


func _on_Tangan_body_entered(body):
	BisaPegang = true
	if body.name == "Bola":
		pass
	ManaBola = body
	pass # Replace with function body.


func _on_Tangan_body_exited(body):
	BisaPegang = false
	ManaBola = null
	pass # Replace with function body.
