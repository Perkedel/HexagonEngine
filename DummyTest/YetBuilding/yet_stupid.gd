extends CharacterBody3D
class_name YetStupid

# Godot provided the template!
# pls yoink View from https://github.com/KenneyNL/Starter-Kit-3D-Platformer
enum OnDeathMode{RespawnNow,HideThis,StayThere,RestartLevel,GameOver}
enum InteractPerspectiveMode{Direct,Broad}

@export_group('Properties')
@export var HP:float = 100
@export var PON:float = 10
@export var SPEED:float = 300.0
@export var SPEED_EXTRA:float = 300.0
@export var JUMP_VELOCITY:float = 4.5
@export var enforceMaxHP:bool = true
@export var onDeath:OnDeathMode = OnDeathMode.RespawnNow
@export var onDeathActsIn:float = 5
@export var onDeathDelayAwaitAnimation:bool = true
var currentPon:float = PON
var currentHP:float = HP
var currentSpeed:float = SPEED
var currentJumpVelocity:float = 4.5
var isSprinting:bool = false

# use Kenney's digital audios
# & qubodup's wood collission
# https://freesound.org/people/qubodup/sounds/54850/
@export_group('Sounds')
#@export var jumpSound:AudioStream = preload("res://Audio/EfekSuara/344500__jeremysykes__jump05.wav")
#@export var jumpSound:AudioStream = preload("res://addons/kenney digital audio/phase_jump_1.ogg")
#@export var landedSound:AudioStream = preload('res://Audio/EfekSuara/WoodCollision-01.wav')
#@export var hurtSound:AudioStream = preload("res://Audio/EfekSuara/341243__sharesynth__hurt02.wav")
#@export var cureSound:AudioStream = preload('res://modules/Reusables/AudioRandomizer/cure_SoundRandom.tres')
@export var cureSound:AudioStream = preload('res://modules/Reusables/AudioRandomizer/cure_SoundRandom.tres')
@export var jumpSound:AudioStream = preload("res://modules/Reusables/AudioRandomizer/jump_SoundRandom.tres")
@export var landedSound:AudioStream = preload("res://modules/Reusables/AudioRandomizer/landed_SoundRandom.tres")
@export var hurtSound:AudioStream = preload("res://modules/Reusables/AudioRandomizer/hurt_SoundRandom.tres")
@export var deathSound:AudioStream = preload("res://modules/Reusables/AudioRandomizer/death-funnyExplode_SoundRandom.tres")
# https://freesound.org/people/jeremysykes/sounds/344500/ wait, this is my jump?! yeah guess..
# yeah confirmed, that's my jump.

@export_group('Camera')
@export var currentCameraRig:Node3D
@export var usePhantomCamera:bool = true
@export var currentPhantomCameraLogic:PhantomCamera3D
@export var currentPhantomCamera:Camera3D 
@export var minCamPitch: float = -89.9
@export var maxCamPitch: float = 50
@export var minCamYaw: float = 0
@export var maxCamYaw: float = 360

@export_group("Zoom")
@export var zoom_minimum = 1.5
@export var zoom_maximum = 20
@export var zoom_speed = .5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var init_pos:Vector3 = position # checkpoint position

@export_group('Jump')
@export var extraJumpTokens:int = 1
@export var offFloorJumpPenalty:bool = true
@export var disableJump:bool = false
@export var jumpButtonBufferTime:float = .1
var currentJumpTokens:int = extraJumpTokens
var jumpedAlready:bool = false
var jumpBufferTimer:float = .1
var jumpBufferStarted:bool = false

@export_group('Interaction')
@export var interactionPerspectiveMode = InteractPerspectiveMode.Broad

@export_group('Falling')
@export var fallLimit:bool = true
@export var fallLimitInY:float = -10
@export var fallHPPenalty:bool = false
@export var fallHPDecrease:float = 5
@export var coyoteTimeCompensateIn:float = .5 #second
var coyoteTimer:float = .5

@export_group('Keymap')
@export var moveLeftKey:String = 'Jalan_Kiri'
@export var moveRightKey:String = 'Jalan_Kanan'
@export var moveBackKey:String = 'Jalan_Belakang'
@export var moveFrontKey:String = 'Jalan_Depan'
@export var sprintHoldKey:String = 'Jalan_Tambah_Cepat'
@export var jumpKey:String = 'Melompat'
@export var interactKey:String = 'Valve_Interaksi_alt'
@export var cameraLeftKey:String = 'Kamera_Kiri'
@export var cameraRightKey:String = 'Kamera_Kanan'
@export var cameraDownKey:String = 'Kamera_Bawah'
@export var cameraUpKey:String = 'Kamera_Atas'
@export var cameraZoomInKey:String = 'Kamera_Perbesar'
@export var cameraZoomOutKey:String = 'Kamera_Perkecil'
@export var cameraMouseCaptureKey:String = 'Kamera_Tangkap_Tetikus'

@export_group('Controller')
@export var onePlayerOnly:bool = true
@export var expectedPlayer:int = 0
@export var mouseSensitivity:float = 0.05

@onready var feetSpeaker = $FeetSpeaker
@onready var centerSpeaker = $CenterSpeaker
@onready var forms:=$Forms
@onready var formsList:=forms.get_children()
@onready var onDeathTimer:=$OnDeathTimer
var ownActive:bool = false
var captureMouse:bool = false
var alive:bool = true
var rotation_direction:float
var direction:Vector3
var moveAxes:Array[float]=[0,0,0,0]
var moveCamAxes:Array[float]=[0,0,0,0]
var zoomAxes:Array[float]=[0,0]
var inputer:Vector3
var wasFloored:bool = true
var interactibleBody:Node3D

# TODO: form installer & uninstaller with signal management

func _ready() -> void:
	currentPhantomCamera = owner.get_node("%MainCamera3DPhantomed")
	currentPhantomCameraLogic = owner.get_node("%PhantomCamera3D")
	pass

func teleportToInit():
	position = init_pos
	pass

func setOwnActivate(to:bool):
	ownActive = to
	pass

func respawn():
	alive = true
	currentHP = HP
	playAnimation('RESET')
	teleportToInit()
	if not visible:
		show()
		pass
	pass

func getHP() -> float:
	return currentHP
	pass

func getMaxHP() -> float:
	return HP
	pass

func getPon() -> float:
	return currentPon

func getCamRig() -> Node3D:
	return currentCameraRig
	pass

func _death():
	if alive:
		print('Eik Serkat: ' + self.name)
		playAnimation('death')
		vibrateo(1,1,2)
		_centerSound(deathSound)
		emitParticleForm()
		onDeathTimer.start(onDeathActsIn)
		alive = false
	pass

func _onDeathActs():
	match onDeath:
		OnDeathMode.RespawnNow:
			respawn()
			pass
		OnDeathMode.HideThis:
			hide()
			pass
		OnDeathMode.StayThere:
			# do nothing
			pass
		_:
			pass
	pass

func damage(howMuch:float):
	if howMuch < 0:
		printerr('Damage '+ self.name +' for '+ String.num(howMuch)+': howMuch cannot be less than 0.0!!')
		return
	currentHP -= howMuch
	if currentHP < 0:
		currentHP = 0
	if currentHP <= 0:
		_death()
	else:
		playAnimation('hurt')
		print('OUCH HP ' + String.num(currentHP))
		_centerSound(hurtSound)
		vibrateo(1,1,.25)
		squishForm(Vector3.RIGHT/2)
		
	pass

func heal(howMuch:float):
	if howMuch < 0:
		printerr('Heal '+ self.name +' for '+ String.num(howMuch)+': howMuch cannot be less than 0.0!!')
		return
	currentHP += howMuch
	if enforceMaxHP:
		if currentHP > HP:
			# max HP only
			currentHP = HP
	squishForm(Vector3.DOWN/4)
	_centerSound(cureSound)
	pass

func checkpoint(newPos:Vector3):
	init_pos = newPos

func collectItem(colliding:Node3D, what:String = 'Pon', amount:float = 1,argument:String=''):
	match(what):
		'Pon','Coin':
			currentPon+=amount
			pass
		'Health':
			heal(amount)
			pass
		'Poison':
			damage(amount)
			pass
		'Checkpoint':
			checkpoint(colliding.position)
			pass
		_:
			pass
	if colliding.has_method('acknowledge'):
		colliding.call('acknowledge',self)
	pass

func collectItemNode(colliding:Node3D):
	if colliding:
		match(colliding.collectType):
			_:
				pass
		pass
	pass

func pushJump():
	velocity.y = currentJumpVelocity
	_feetSound(jumpSound)
	jumpedAlready = true
	coyoteTimer = 0
	jumpBufferStarted = false
	jumpBufferTimer = jumpButtonBufferTime
	
	vibrateo(.25,0,.15)
	squishForm(Vector3.UP/2)
	pass

func resetJump():
	currentJumpTokens = extraJumpTokens
	jumpedAlready = false
	coyoteTimer = coyoteTimeCompensateIn
	pass

func manageJump():
	if not disableJump:
		if (is_on_floor() or coyoteTimer > 0 or not offFloorJumpPenalty) and not jumpedAlready:
#			print('jump 1st ' + ('is Floor' if is_on_floor else 'is Aired') + ' Coyote ' + String.num(coyoteTimer) + ' & ' + ('already jumped' if jumpedAlready else 'not yet jumped'))
			pushJump()
			pass
		else:
			if currentJumpTokens > 0:
#				print('jump 2nd' + ('is Floor' if is_on_floor else 'is Aired') + ' Coyote ' + String.num(coyoteTimer) + ' & ' + ('already jumped' if jumpedAlready else 'not yet jumped'))
				pushJump()
				currentJumpTokens -= 1
				playAnimation('jump_subsequent')
				pass
			else:
				# out of everything. save to buffer
				jumpBufferStarted = true
				pass
#		jumpedAlready = true
#		coyoteTimer = 0
	move_and_slide()
	pass

func assignCamera(withMe:Node):
	currentCameraRig = withMe
	pass

func assignPhantomCamera(withMe:Camera3D):
	currentPhantomCamera = withMe
	pass

func meMove(axes:Vector2 = Vector2.ZERO):
#	print('moveing ')
	direction = (transform.basis * Vector3(axes.x, 0, axes.y)).normalized()
	move_and_slide()
	pass

func doWillFlooring():
	if not wasFloored:
		_feetSound(landedSound)
		# if there is a jump buffer, jump!
		if jumpBufferStarted:
			resetJump()
			manageJump()
			pass
		
		vibrateo(0,.15,.05)
		squishForm(Vector3.UP/2)
		wasFloored = true
	pass

func _updateInRangeInteractible():
	
	pass

func interactNow(command:String = 'activate', argument:String = ''):
	# send interact command to object. default command is activate
	# there may also
	# - special
	# - pickup
	# - destroy
	# - throw
	# - kick
	# - etc.
	# object will receive & repond to matching command.
	if interactibleBody:
		if interactibleBody.has_method('receiveInteraction'):
			interactibleBody.call('receiveInteraction',command,argument)
		pass
	pass

func hoverInteract(me:CharacterBody3D):
	if interactionPerspectiveMode == InteractPerspectiveMode.Direct:
		if interactibleBody:
			if interactibleBody.has_method('hoverInteract'):
				interactibleBody.call('hoverInteract',me)
	pass

func unhoverInteract():
	if interactionPerspectiveMode == InteractPerspectiveMode.Direct:
		if interactibleBody:
#			print('RECMOOOOOOOOOOOOOOOOOVE')
			if interactibleBody.has_method('unhoverInteract'):
				interactibleBody.call('unhoverInteract')
			interactibleBody = null
	pass

func receiveHoverInteractionField(from:Node3D):
	if interactionPerspectiveMode == InteractPerspectiveMode.Broad:
		# receive from interactible object
		interactibleBody = from
		pass
	pass

func receiveUnhoverInteractionField():
	if interactionPerspectiveMode == InteractPerspectiveMode.Broad:
		if interactibleBody:
			interactibleBody = null
		pass
	pass

func receiveInteraction(command:String = 'activate', argument:String = ''):
	pass

func attackNow():
	pass

func _centerSound(what:AudioStream):
	centerSpeaker.stream = what
	centerSpeaker.play()
	pass

func _feetSound(what:AudioStream):
	feetSpeaker.stream = what
	feetSpeaker.play()
	pass

func playSound(what:AudioStream,onWhat:String):
	match onWhat:
		_:
			pass
	pass

func playAnimation(named: StringName = "", custom_blend: float = -1, custom_speed: float = 1.0, from_end: bool = false
):
	for i in formsList:
		if i.visible:
			if i.has_method('playAnimation'):
				i.call('playAnimation', named,custom_blend,custom_speed,from_end)
				pass
			else:
				printerr('Form ' + i.name + ' wielded by ' + self.name + ' Lacks `playAnimation` function!!!')
				pass
			pass
		pass
	pass

func squishForm(byWha:Vector3,forHowLong:float=.25):
	for i in formsList:
		if i.visible:
			if i.has_method('squish'):
				i.call('squish',byWha,forHowLong)
				pass
			pass
		pass
	pass

func emitParticleForm(whichIs:String='death'):
	for i in formsList:
		if i.visible:
			if i.has_method('emitParticle'):
				i.call('emitParticle',whichIs)
	pass

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
		if coyoteTimer > 0:
			coyoteTimer -= delta
		if jumpedAlready:
			coyoteTimer = 0
		wasFloored = false
	else:
		resetJump()
		doWillFlooring()
	
	# Rotation
	if Vector2(velocity.z, velocity.x).length() > 0:
		rotation_direction = Vector2(velocity.z, velocity.x).angle()
		pass
		
	rotation.y = lerp_angle(rotation.y, rotation_direction, delta * 10)
	
	# Handle Jump.
	if ownActive:
	#	if Input.is_action_just_pressed(jumpKey) and is_on_floor():
		if Input.is_action_just_pressed(jumpKey):
			if not disableJump:
		#		if currentJumpTokens > 0:
		#			if is_on_floor():
		#				velocity.y = currentJumpVelocity
		#				jumpedAlready = true
		#			else:
		#				if (not offFloorJumpPenalty) or (offFloorJumpPenalty and (currentJumpTokens - 1 > 0 and not jumpedAlready) or jumpedAlready):
		#					velocity.y = currentJumpVelocity
		#					jumpedAlready = true
		#				pass
		#			currentJumpTokens -= 1
#				if (is_on_floor() or coyoteTimer > 0 or not offFloorJumpPenalty) and not jumpedAlready:
#					pushJump()
#					pass
#				else:
#					if currentJumpTokens > 0:
#						pushJump()
#						currentJumpTokens -= 1
#						pass
				pass
			pass
	
	# Jump Buffer
	if jumpBufferStarted:
		if jumpBufferTimer > 0:
			# is buffer
			jumpBufferTimer -= delta
			
			# if did landed on floor during jump buffer, then launch jump!
			if is_on_floor():
				pass
			pass
		else:
			# out of time then cancel buffer
			jumpBufferStarted = false
			jumpBufferTimer = jumpButtonBufferTime
			pass
		pass
	else:
		pass
	pass
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir :Vector2= Input.get_vector(moveLeftKey, moveRightKey, moveFrontKey, moveBackKey)
	if ownActive and alive:
#		inputer = inputer.rotated(Vector3.UP,currentCameraRig.rotation.y-rotation.y+deg_to_rad(180) if currentCameraRig else Vector3.ZERO).limit_length()
#		direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
#		direction = (transform.basis * inputer).limit_length()
#		direction = (transform.basis * inputer)
		pass
	else:
		direction = Vector3.ZERO
		pass
	if direction:
		velocity.x = direction.x * (currentSpeed + (SPEED_EXTRA if isSprinting else 0)) * delta
		velocity.z = direction.z * (currentSpeed + (SPEED_EXTRA if isSprinting else 0)) * delta
	else:
		velocity.x = move_toward(velocity.x, 0, currentSpeed)
		velocity.z = move_toward(velocity.z, 0, currentSpeed)
	
#	direction = (transform.basis * inputer)
	move_and_slide()
	
	if fallLimit:
		if position.y < fallLimitInY:
			respawn()
			if fallHPPenalty:
				damage(fallHPDecrease)
			pass
		pass
	
	# death
	if alive:
		pass
	else:
		isSprinting = false
		inputer = Vector3.ZERO
		moveAxes = [0,0,0,0]
#		direction = lerp(direction,Vector3.ZERO,1)
		pass
	pass

func _toggleMouseCapture():
	if usePhantomCamera:
		if ownActive:
			print('mouseCaptur')
			match(Input.mouse_mode):
				Input.MOUSE_MODE_VISIBLE:
					Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
					pass
				Input.MOUSE_MODE_CAPTURED:
					Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
					pass
				_:
					pass
			pass
		else:
			if Input.mouse_mode != Input.MOUSE_MODE_VISIBLE:
				Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
				pass
	else:
		if Input.mouse_mode != Input.MOUSE_MODE_VISIBLE:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			pass
	pass

func recheckMenu() -> void:
	if usePhantomCamera:
		match(Singletoner.currentMenu):
			'Gameplay':
				
				pass
			'MainMenu':
				_toggleMouseCapture()
				pass
			_:
				pass
	pass

func _input(event: InputEvent) -> void:
	var camRotate:Vector3 = Vector3.ZERO
	var camValid:bool = false
	if ((event.device != expectedPlayer) and onePlayerOnly):
		return
	else:
		inputer = Vector3.ZERO 
		pass
#	var input_dir :Vector2= Input.get_vector(moveLeftKey, moveRightKey, moveFrontKey, moveBackKey)
#	print('eeeeeeeeeeeeeeee')
#	direction = (transform.basis * Vector3(1, 0, 1)).normalized()
#	var ub:Array[float] = [0,0,0,0]
	
	# Phantom Camera
	if usePhantomCamera:
		if currentPhantomCamera:
			camValid = true
			camRotate = currentPhantomCamera.rotation
			
			#_set_pcam_rotation(currentPhantomCamera,event)
			if event is InputEventAction:
				# Mouse capture
				pass
		else:
			camRotate = Vector3.ZERO
		pass
		
		if event.is_action_pressed(cameraMouseCaptureKey):
			#print('MouseCapturea')
			_toggleMouseCapture()
			pass
		
		# camera right analog stick
		if ownActive:
			if event.is_action(cameraLeftKey):
				moveCamAxes[0] = event.get_action_strength(cameraLeftKey)
				pass
			if event.is_action(cameraRightKey):
				moveCamAxes[1] = event.get_action_strength(cameraRightKey)
				pass
			if event.is_action(cameraUpKey):
				moveCamAxes[2] = event.get_action_strength(cameraUpKey)
				pass
			if event.is_action(cameraDownKey):
				moveCamAxes[3] = event.get_action_strength(cameraDownKey)
				pass
			pass
			#if currentPhantomCameraLogic:
				#_set_pcam_rotation(currentPhantomCameraLogic, event)
		else:
			moveCamAxes = [0,0,0,0]
		
		if event.is_action(cameraZoomInKey):
			zoomAxes[0] = event.get_action_strength(cameraZoomInKey)
			pass
		if event.is_action(cameraZoomOutKey):
			zoomAxes[1] = event.get_action_strength(cameraZoomOutKey)
			pass
		
		if currentPhantomCameraLogic:
			_set_pcam_rotation(currentPhantomCameraLogic, event)
		pass
		
		if event is InputEventMouseButton:
			if ownActive:
				if currentPhantomCameraLogic:
					if event.is_action(cameraZoomOutKey+'.mouse'):
						#currentPhantomCameraLogic.set_spring_length(currentPhantomCameraLogic.get_spring_length() + 1)
						#currentPhantomCameraLogic.set_spring_length(clampf(currentPhantomCameraLogic.get_spring_length(),zoom_minimum,zoom_maximum))
						currentPhantomCameraLogic.set_spring_length(clampf(currentPhantomCameraLogic.get_spring_length() + zoom_speed,zoom_minimum,zoom_maximum))
					if event.is_action(cameraZoomInKey+'.mouse'):
						#currentPhantomCameraLogic.set_spring_length(currentPhantomCameraLogic.get_spring_length() - 1)
						#currentPhantomCameraLogic.set_spring_length(clampf(currentPhantomCameraLogic.get_spring_length(),zoom_minimum,zoom_maximum))
						currentPhantomCameraLogic.set_spring_length(clampf(currentPhantomCameraLogic.get_spring_length() - zoom_speed,zoom_minimum,zoom_maximum))
				pass
			pass
		
	else:
		
		if currentCameraRig:
			camValid = true
			camRotate = currentCameraRig.rotation
			captureMouse
		else:
			camRotate = Vector3.ZERO
		pass
	
	if ownActive and alive:
		if event.is_action(moveFrontKey):
			moveAxes[2] = event.get_action_strength(moveFrontKey)
			pass
		if event.is_action(moveLeftKey):
			moveAxes[0] = event.get_action_strength(moveLeftKey)
			pass
		if event.is_action(moveRightKey):
			moveAxes[1] = event.get_action_strength(moveRightKey)
			pass
		if event.is_action(moveBackKey):
			moveAxes[3] = event.get_action_strength(moveBackKey)
			pass
		if event.is_action_pressed(jumpKey):
			manageJump()
			pass
		if event.is_action_pressed(interactKey):
			interactNow()
#		isSprinting = event.is_action(sprintHoldKey)
		if event.is_action(sprintHoldKey):
			if event.is_action_pressed(sprintHoldKey):
				isSprinting = true
				pass
			elif event.is_action_released(sprintHoldKey):
				isSprinting = false
		inputer.x = -moveAxes[1]+moveAxes[0]
		inputer.z = moveAxes[2]-moveAxes[3]
#		inputer = inputer.rotated(Vector3.UP,camRotate.y-rotation.y+deg_to_rad(180) if currentCameraRig else Vector3.ZERO)
		#inputer = inputer.rotated(Vector3.UP,currentCameraRig.rotation.y-rotation.y+deg_to_rad(180) if currentCameraRig else Vector3.ZERO).limit_length()
#		inputer = inputer.rotated(Vector3.UP,camRotate.y-rotation.y+deg_to_rad(180) if currentCameraRig else Vector3.ZERO).normalized()
		#inputer = inputer.rotated(Vector3.UP,camRotate.y-rotation.y+deg_to_rad(180 if not usePhantomCamera else 0) if camValid else 0).limit_length()
		inputer = inputer.rotated(Vector3.UP,camRotate.y-rotation.y+deg_to_rad(180) if camValid else 0).limit_length()
	else:
		isSprinting = false
		inputer = Vector3.ZERO 
		moveAxes = [0,0,0,0]
	
#	direction = (transform.basis * Vector3(-moveAxes[0]+moveAxes[1], 0, -moveAxes[2]+moveAxes[3]))
	direction = (transform.basis * inputer)
	pass

func _set_pcam_rotation(pcam: PhantomCamera3D, event: InputEvent) -> void:
	# yoink from PhantomCamera https://phantom-camera.dev/
	# 3rd person demo
	if event is InputEventMouseMotion:
		var pcam_rotation_degrees: Vector3
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			# Assigns the current 3D rotation of the SpringArm3D node - so it starts off where it is in the editor
			pcam_rotation_degrees = pcam.get_third_person_rotation_degrees()

			# Change the X rotation
			pcam_rotation_degrees.x -= event.relative.y * mouseSensitivity

			# Clamp the rotation in the X axis so it go over or under the target
			pcam_rotation_degrees.x = clampf(pcam_rotation_degrees.x, minCamPitch, maxCamPitch)

			# Change the Y rotation value
			pcam_rotation_degrees.y -= event.relative.x * mouseSensitivity

			# Sets the rotation to fully loop around its target, but witout going below or exceeding 0 and 360 degrees respectively
			pcam_rotation_degrees.y = wrapf(pcam_rotation_degrees.y, minCamYaw, maxCamYaw)

			# Change the SpringArm3D node's rotation and rotate around its target
			pcam.set_third_person_rotation_degrees(pcam_rotation_degrees)
	if event is InputEventJoypadMotion:
		pass

func vibrateo(weak:float=.5,strong:float=.5,duration:float=1):
	if onePlayerOnly:
		Input.start_joy_vibration(expectedPlayer,weak,strong,duration)
		pass
	else:
		for i in Input.get_connected_joypads():
			Input.start_joy_vibration(i,weak,strong,duration)
			pass
		pass
	Input.vibrate_handheld(duration * 1000)
	pass

func _on_on_death_timer_timeout() -> void:
	_onDeathActs()
	pass # Replace with function body.


func _on_interactor_body_entered(body: Node3D) -> void:
	if interactionPerspectiveMode == InteractPerspectiveMode.Direct:
		interactibleBody = body
		hoverInteract(self)
	pass # Replace with function body.


func _on_interactor_body_exited(body: Node3D) -> void:
	unhoverInteract()
#	interactibleBody = null
	pass # Replace with function body.
