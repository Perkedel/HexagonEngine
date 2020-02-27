tool
extends Spatial

var flareLayer = CanvasLayer.new()

var flareVisNotif = VisibilityNotifier.new()

var flareRay = RayCast.new()

var flareArray = []

var flareHidden = false

var brightness = 0

var camera = null

export(Array, Texture) var flareTextures = [preload("FlareTex.png")] setget set_textures
export(Array, Color) var flareColors
export(Array, Vector2) var flareScale
export(Array, bool) var rotateFlare
export(Vector2) var flareSpacing = Vector2.ONE
export(float, 0.01, 100) var fadeSpeed = 5
export(float, 0.01, 1) var spacingFade = 0.6

func set_textures(texArray):
	flareTextures = texArray
	for i in flareArray.size():
		flareArray[i].free()
	flareArray = []
	for i in flareTextures.size():
		var node = TextureRect.new()
		flareLayer.add_child(node)
		node.texture = flareTextures[i]
		node.material = preload("Flare.material")
		node.visible = false
		flareArray.push_back(node)

func _init():
	add_child(flareLayer)
	flareLayer.layer = -10
	for i in flareArray.size():
		flareArray[i].free()
	flareArray = []
	for i in flareTextures.size():
		var node = TextureRect.new()
		flareLayer.add_child(node)
		node.texture = flareTextures[i]
		node.material = preload("Flare.material")
		node.visible = false
		flareArray.push_back(node)
	add_child(flareVisNotif)
	flareVisNotif.aabb = AABB(Vector3(-0.1, -0.1, -0.1), Vector3(0.2, 0.2, 0.2))
	add_child(flareRay)

func _process(delta):
	if visible:
		renderFlare(delta)

func _physics_process(delta):
	if visible:
		if camera != null:
			var dist = (global_transform.origin - camera.global_transform.origin).length()
			flareRay.cast_to = Vector3(0, 0, dist)
			flareRay.look_at(2 * global_transform.origin - camera.global_transform.origin, Vector3.UP)

func renderFlare(delta):
	var viewPort = get_viewport()
	if viewPort != null:
		camera = viewPort.get_camera()
		if camera != null:
			var flareCoords = camera.unproject_position(global_transform.origin)
			var centerScreen = viewPort.size / 2
			var flare2Center = centerScreen - flareCoords
			calcFlare(flare2Center, flareCoords, viewPort.size, delta)

func calcFlare(flare2Center, flareCoords, size, delta):
	for i in flareArray.size():
		if flareVisNotif.is_on_screen():
			if flareRay.enabled != true:
				flareRay.enabled = true
			if !flareRay.is_colliding():
				var color = Color.white
				var scale = Vector2.ONE
				var rot = false
				if flareColors.size() > i:
					color = flareColors[i]
				if flareScale.size() > i:
					scale = flareScale[i]
				if rotateFlare.size() > i:
					rot = rotateFlare[i]
				var dir = flare2Center * (i * flareSpacing)
				var flarePos = flareCoords + dir
				brightness = clamp(1 - (flare2Center / size).length() / spacingFade, 0, 1) * color.a
				flareArray[i].rect_position = flarePos - (flareArray[i].rect_size / 2)
				flareArray[i].rect_pivot_offset = flareArray[i].rect_size / 2
				flareArray[i].rect_scale = scale
				flareArray[i].self_modulate = color
				if rot:
					flareArray[i].rect_rotation = rad2deg((flareCoords - flarePos).angle()) + 90
				if flareHidden:
					flareHidden = false
			else:
				if !flareHidden:
					flareHidden = true
		else:
			if flareRay.enabled != false:
				flareRay.enabled = false
			if !flareHidden:
				flareHidden = true
	fade(fadeSpeed, delta, brightness)

var i = 0
func fade(speed, delta, bright):
	if flareHidden:
		i = lerp(i, 0, speed * delta)
	else:
		i = lerp(i, 1, speed * delta)
	i = clamp(i, 0, 1)
	for j in flareArray.size():
		if i > 0:
			flareArray[j].visible = true
		else:
			flareArray[j].visible = false
		flareArray[j].self_modulate.a = i * bright