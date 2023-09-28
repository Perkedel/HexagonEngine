extends StaticBody3D

enum InteractPerspectiveMode{Direct,Broad}

@export_group('Interaction')
@export var recommendedInteractionCommand:String = 'activate'
@export var expectedGroup:String = 'player'
@export var allowAllType:bool = false
@export var interactedSound:AudioStream= preload("res://Audio/EfekSuara/CopyrightInfringement/Microsoft/tada.wav")
@export var interactionPerspectiveMode:InteractPerspectiveMode = InteractPerspectiveMode.Broad
@onready var shapesList: = $Shapes.get_children()
@onready var centerSpeaker: = $CenterSpeaker
@onready var glyphSign: = $GlyphSign
@onready var interactArea: = $InteractionToReceive3D
var beingFacedWith:Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	glyphSign.hide()
	interactArea.allowAllType = allowAllType
	interactArea.expectedGroup = expectedGroup
	pass # Replace with function body.

func hoverInteract(you:Node3D):
	if interactionPerspectiveMode == InteractPerspectiveMode.Direct:
		print('the ' + you.name + ' is hovering on ' + self.name)
		beingFacedWith = you
		glyphSign.show()
	pass

func hoverInteractField(collidingYou:Node3D):
	if interactionPerspectiveMode == InteractPerspectiveMode.Broad:
		print('the ' + collidingYou.name + ' is hovering on ' + self.name + ' Broadly')
		beingFacedWith = collidingYou
		if collidingYou.has_method('receiveHoverInteractionField'):
			collidingYou.call('receiveHoverInteractionField',self)
		glyphSign.show()
		pass
	pass

func unhoverInteract():
	if interactionPerspectiveMode == InteractPerspectiveMode.Direct:
		if beingFacedWith:
			print('bye bye ' + beingFacedWith.name)
			glyphSign.hide()
			beingFacedWith = null
	pass

func unhoverInteractField(collidingYou:Node3D):
	if interactionPerspectiveMode == InteractPerspectiveMode.Broad:
		if beingFacedWith and beingFacedWith == collidingYou:
			print('bye bye ' + beingFacedWith.name + ' Broadly')
			if collidingYou.has_method('receiveUnhoverInteractionField'):
				collidingYou.call('receiveUnhoverInteractionField')
			glyphSign.hide()
			beingFacedWith = null
		pass
	pass

func playAnimation(named: StringName = "", custom_blend: float = -1, custom_speed: float = 1.0, from_end: bool = false
):
	for i in shapesList:
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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	if beingFacedWith:
		var camRigHold:Node3D
		beingFacedWith.rotate(Vector3.UP,0)
		if beingFacedWith.has_method('getCamRig'):
			camRigHold = beingFacedWith.call('getCamRig')
		if camRigHold:
			glyphSign.rotation.y = camRigHold.rotation.y
			glyphSign.rotation.x = camRigHold.rotation.x
			pass
		pass
	else:
		glyphSign.hide()
	pass

func _centerSound(what:AudioStream):
	centerSpeaker.stream = what
	centerSpeaker.play()

func receiveInteractionSignal(from:StringName='',command:String='activate',argument:String=''):
	print('I received: `'+command + ' ' + argument + '`, from ' + from)
	playAnimation('activated')
	_centerSound(interactedSound)
	pass

func receiveInteraction(command:String = 'activate', argument:String=''):
	print('I received: `'+command + ' ' + argument + '`')
	playAnimation('activated')
	_centerSound(interactedSound)
	pass


func _on_interaction_to_receive_3d_received_interaction(from, command, argument) -> void:
	receiveInteractionSignal(from,command,argument)
	pass # Replace with function body.


func _on_interaction_to_receive_3d_received_hover_interaction(from) -> void:
	hoverInteractField(from)
	pass # Replace with function body.


func _on_interaction_to_receive_3d_received_unhover_interaction(from) -> void:
	unhoverInteractField(from)
	pass # Replace with function body.
