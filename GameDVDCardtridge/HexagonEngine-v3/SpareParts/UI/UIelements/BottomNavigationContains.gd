@tool
extends ScrollContainer

enum AlignmentMode{Begin,Center,End}
enum FocusStartMode{Begin,Custom,End}

#@export_group('Properties')
#@export var focusFromLast:bool = false
@export var focusStartFrom:FocusStartMode = FocusStartMode.Begin
@export var selectCustomFocusStart:int = 0
@export var alignment:AlignmentMode = AlignmentMode.Begin
@export var automaticallyFocusPerVisible:bool = true

@onready var sidren:Node = $Sidren
var __isReady:bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	__isReady = true
	_refreshLook()
	_refocusWhichButton()
	pass # Replace with function body.

func _refreshLook():
	sidren.alignment = alignment
	pass

func _refocusWhichButton():
	if visible:
		match(focusStartFrom):
			FocusStartMode.Begin:
				for i in sidren.get_children():
					if i is Button:
						i.grab_focus()
						break
						pass
					pass
				pass
			FocusStartMode.Custom:
				if selectCustomFocusStart >= 0 and selectCustomFocusStart <= sidren.get_child_count():
					if sidren.get_child(selectCustomFocusStart) is Button:
						sidren.get_child(selectCustomFocusStart).grab_focus()
						pass
					else:
						printerr('Bottom Navigation '+ name +' for which button #' + String.num(selectCustomFocusStart) + ' is NOT a Button!!')
					pass
				else:
					printerr('Bottom Navigation '+ name +' for which button #' + String.num(selectCustomFocusStart) + 'does not exist!! Max from 0 to ' + String.num(sidren.get_child_count()))
					pass
				pass
			FocusStartMode.End:
				for i in range(sidren.get_child_count(),0,-1):
					if sidren.get_child(i) is Button:
						sidren.get_child(i).grab_focus()
						break
						pass
					pass
				pass
			_:
				pass
		pass
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _draw() -> void:
	_refreshLook()
	pass

func _notification(what: int) -> void:
	if __isReady:
		match(what):
			NOTIFICATION_VISIBILITY_CHANGED:
				if visible:
					if automaticallyFocusPerVisible:
						_refocusWhichButton()
						pass
					pass
				pass
			NOTIFICATION_DRAW:
				pass
			_:
				pass
		pass
	pass
