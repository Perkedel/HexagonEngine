extends Node

var current = null
var drag_offset = Vector2()

var candidates = []

export var drag_group = "draggable"


func _ready():
	var draggables = get_tree().get_nodes_in_group(drag_group)
	for dragable in draggables:
		if dragable is CollisionObject2D:
			dragable.connect("mouse_entered",self,"mouse_entered",[dragable])
			dragable.connect("mouse_exited",self,"mouse_exited",[dragable])
			dragable.connect("input_event",self,"input_event",[dragable])

func _process(delta):
	if current is Node2D:
		current.global_position = current.get_global_mouse_position() - drag_offset

func mouse_entered(which):
	candidates.append(which)
	pass

func mouse_exited(which):
	candidates.erase(which)
	pass

func input_event(viewport: Node, event: InputEvent, shape_idx: int,which:Node2D):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if event.is_pressed():
			candidates.sort_custom(self,"depth_sort")
			var last = candidates.back()
			if last:
				last.raise()
				current = last
				drag_offset = current.get_global_mouse_position() - current.global_position
				if current.has_method("on_drag_start"):
					current.on_drag_start()
		else:
			var can_drop = true
			if current:
				if current.has_method("on_drop"):
					var on_drop_result = current.on_drop()
					can_drop = on_drop_result == null || on_drop_result
				if can_drop:
					current = null

func depth_sort(a,b):
	return b.get_index()<a.get_index()
