extends Node
# Posesser. Manage Player to Character Controllings
# this Posessings contains how many players. each controls a Node that has movements
# Each Character Object is expected to has:
# meMove(axis:vec2) 
# meJump(strength:float = 4.2) # strength optional
# meCamera(axis:vec2)


@export_subgroup('Posessions')
@export var Posessings:Array[Array] = [[]]
var MoveAxes:Array = [Vector2.ZERO,Vector2.ZERO,Vector2.ZERO]

@export_subgroup('KeyMap')
@export var moveLeftKey:String = 'Jalan_Kiri'
@export var moveRightKey:String = 'Jalan_Kanan'
@export var moveBackKey:String = 'Jalan_Belakang'
@export var moveFrontKey:String = 'Jalan_Depan'
@export var jumpKey:String = 'Melompat'

var moveSet:Dictionary = {
	moveAxes = [],
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func addPosess(forThisNode:Node,toWhom:int=0):
	if forThisNode is Node:
		Posessings[toWhom].append(forThisNode)
	return Posessings[toWhom]
	pass

func replacePosess(withThisNode:Node,toWhom:int = 0):
	clearPosess(toWhom)
	if withThisNode is Node:
		Posessings[toWhom] = [withThisNode]
	return Posessings[toWhom]
	pass

func removePosess(whichOne,toWhom:int=0):
	if whichOne is Node:
		Posessings[toWhom].erase(whichOne)
		pass
	elif whichOne is int:
		Posessings[toWhom].remove_at(whichOne)
		pass
	pass

func clearPosess(toWhom:int=0):
	Posessings[toWhom].clear()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
#	MoveAxes[event.device] = Vector2(event.get_action_strength('Jalan_Kanan')-event.get_action_strength('Jalan_Kiri'),event.get_action_strength('Jalan_Depan')-event.get_action_strength('Jalan_Belakang')).normalized()
#	moveSet['moveAxes'][event.device+] = Vector2(event.get_action_strength('Jalan_Kanan')-event.get_action_strength('Jalan_Kiri'),event.get_action_strength('Jalan_Depan')-event.get_action_strength('Jalan_Belakang')).normalized()
#	if Posessings:
#		if Posessings[event.device]:
#			for i in range(Posessings[event.device].size()):
#				if Posessings[event.device][i].has_method('meMove'):
#					Posessings[event.device][i].call('meMove',MoveAxes[event.device])
#					pass
#				pass
#			pass
#		pass
	pass

func _unhandled_input(event: InputEvent) -> void:
	
	pass

func _physics_process(delta: float) -> void:
	for i in Input.get_connected_joypads():
		# pls check if there is multithread. this best runs on other thread
		#var moveX = Input.get_joy_axis(i,InputHelper.get_joypad_input_for_action('Jalan_Kanan'))
#		MoveAxes[i] = Input.get_vector(moveLeftKey, moveRightKey, moveFrontKey, moveBackKey)
#		if Posessings[i]:
#			for j in range(Posessings[i].size()):
#				if Posessings[i][j].has_method('meMove'):
##					Posessings[i][j].call('meMove',MoveAxes[i])
#					pass
#				pass
#			pass
		pass
	pass
