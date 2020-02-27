extends Node

# you have to tell this node where the actual camera object is.
# bonus points if this is the direct child of your camera object, composition ftw.
export(NodePath) var camera_path
onready var camera = get_node(camera_path)

var far_limit = 10000000

# I tried using only a single tween object, but it didn't work. Not sure why.

# might be a bit weird to be spawning children
# nodes dynamically, but this is plugin world
# where scenes don't exist =(
func _ready():
	add_to_group("markopolodev_camera")
	
	for name in ["tween_top", "tween_bottom", "tween_left", "tween_right"]:
		var tween = Tween.new()
		tween.set_name(name)
		add_child(tween)

func set_limits(limits):
	var camera_rect = Rect2()
	camera_rect.size = get_viewport().get_visible_rect().size
	# top left corner
	camera_rect.position = camera.get_camera_screen_center() - (camera_rect.size / 2.0)
	
	tween_limit(limits, "limit_top",    camera_rect.position.y,                      $tween_top)
	tween_limit(limits, "limit_bottom", camera_rect.position.y + camera_rect.size.y, $tween_bottom)
	tween_limit(limits, "limit_left",   camera_rect.position.x,                      $tween_left)
	tween_limit(limits, "limit_right",  camera_rect.position.x + camera_rect.size.x, $tween_right)

func clear_limits(limits):
	clear_limit(limits, "limit_top", $tween_top)
	clear_limit(limits, "limit_bottom", $tween_bottom)
	clear_limit(limits, "limit_right", $tween_right)
	clear_limit(limits, "limit_left", $tween_left)

func tween_limit(limits, limit, viewport_edge, tween):
	if limits.has(limit):
		var initial
		if limit == "limit_top" or limit == "limit_left":
			# near
			initial = min(viewport_edge, limits[limit]) - 10
			camera.set(limit, initial)
		else:
			# far
			initial = max(viewport_edge, limits[limit]) + 10
			camera.set(limit, initial)
		
		print("setting %s: %s" % [limit, initial])
		
		var final = limits[limit]
		tween.stop_all()
		tween.interpolate_property(camera, limit, initial, final, 1, Tween.TRANS_QUAD, Tween.EASE_OUT)
		tween.start()

func clear_limit(limits, limit, tween):
	if limits.has(limit) and abs(camera.get(limit)) != far_limit:
		print("clearing %s" % limit)
		var initial = camera.get(limit)
		var final
		if limit == "limit_top" or limit == "limit_left":
			final = -far_limit
		else:
			final = far_limit
		tween.stop_all()
		tween.interpolate_property(camera, limit, initial, final, 10, Tween.TRANS_CUBIC, Tween.EASE_IN)
		tween.start()



