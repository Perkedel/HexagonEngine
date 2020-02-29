tool
extends Node

const Tools: Script = preload("tools.gd")

export(NodePath) var scene3d_path: NodePath

onready var scene3d: Spatial = get_node(scene3d_path)

var model: Spatial
var anim_player: AnimationPlayer
var views: Array
var anim_names: Array
var anim_fkeys: Array
var iview: int
var ianim: int
var ikey: int
var sprites: Array = []
var wait_frame: bool = false
var animation_finished: bool = true


func _ready() -> void:
	set_process(false)


func _process(_delta: float) -> void:
	if wait_frame:
		wait_frame = false
		return
	if animation_finished:
		if iview == views.size():
			ianim += 1
			if ianim == anim_names.size():
				end_bake()
				return
			iview = 0
		set_view()
		ikey = 0
		anim_player.play(anim_names[ianim])
		anim_player.seek(anim_fkeys[ianim][ikey], true)
		wait_frame = true
		animation_finished = false
	else:
		var texture: = ImageTexture.new()
		texture.create_from_image($Viewport3D.get_texture().get_data(), 0)
		sprites.append(texture)
		ikey += 1
		if ikey == anim_fkeys[ianim].size():
			make_sprite_sheet(anim_names[ianim])
			anim_player.stop(false)
			sprites = []
			iview += 1
			animation_finished = true
		else:
			anim_player.seek(anim_fkeys[ianim][ikey], true)


func update_model(model_: Spatial) -> void: # SpriteBaker.Model group function
	model = model_


func clear_model() -> void: # SpriteBaker.Model group function
	model = null


func bake(data: Dictionary) -> void:  # SpriteBaker.Bake group function
	scene3d.set_model(model)
	set_resolution(data["pixel_density"], data["margin"])
	anim_player = scene3d.anim_player
	views = data["views"]
	var anim_data: Dictionary = data["animations"]
	for aname in anim_data:
		anim_names.append(aname)
		anim_fkeys.append(anim_data[aname])
	if data.has("root_motion:path"):
		scene3d.set_root_motion_track(data["root_motion:path"], data["root_motion:bone_id"])
	iview = 0
	ianim = 0
	animation_finished = true
	set_process(true)


func set_resolution(pixel_dens: float, margin: int) -> void:
	var aabb: AABB = scene3d.aabb
	var res_x: int = int(ceil(aabb.size.x * pixel_dens))
	var res_y: int = int(ceil(aabb.size.y * pixel_dens))
	$Viewport3D.size = Vector2(res_x, res_y)
	scene3d.adjust_camera()

	# Add margin
	var dblmargin: int = 2 * margin
	res_x += dblmargin
	res_y += dblmargin
	$Viewport3D.size = Vector2(res_x, res_y)
	scene3d.camera.size += dblmargin / pixel_dens


func make_sprite_sheet(aname: String) -> void:
	var anim_name: String
	if aname.find("|") != -1:
		anim_name = aname.right(anim_name.find_last("|")).strip_edges()
	else:
		anim_name = aname
	if anim_name.ends_with("-loop"):
		anim_name = anim_name.left(anim_name.length() - 5)
	if views.size() != 1:
		anim_name += "-" + views[iview][0]
	Tools.clear_node($SpriteSheet)
	var size: Vector2 = (sprites[0] as ImageTexture).get_size()
	var n: int = int(ceil(sqrt(sprites.size())))
	$SpriteSheet.size = Vector2(size.x * n, size.y * n)
	for i in range(sprites.size()):
		var rect: = TextureRect.new()
		$SpriteSheet.add_child(rect)
		rect.rect_size = size
		rect.texture = sprites[i]
		var x: float = (i % n) * size.x
		var y: float = int(i / float(n)) * size.y
		rect.rect_position = Vector2(x, y)
	yield(get_tree(), "idle_frame")
	var path: String = "res://" + anim_name + ".png"
	var texture: = ImageTexture.new()
	texture.create_from_image($SpriteSheet.get_texture().get_data())
	assert(ResourceSaver.save(path, texture, 0) == OK)


func set_view() -> void:
	var rot: Vector2 = views[iview][1]
	scene3d.rotate_model(rot.x, rot.y)


func end_bake() -> void:
	scene3d.clear_root_motion_track()
	scene3d.set_model(null)
	set_process(false)
