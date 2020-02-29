tool
extends VBoxContainer

signal time_changed(time)

const Tools: Script = preload("tools.gd")

export(StyleBox) var tick_style: StyleBox
export(NodePath) var time_ruler_path: NodePath
export(NodePath) var slider_path: NodePath
export(NodePath) var background_path: NodePath

onready var time_ruler: BoxContainer = get_node(time_ruler_path)
onready var slider: Slider = get_node(slider_path)
onready var background: PanelContainer = get_node(background_path)

var anim_length: float = 0.0
var time: float = 0.0
var playing: bool = false


func clear() -> void:
	anim_length = 0.0
	playing = false
	background.update()
	slider.value = 0.0
	slider.editable = false


func set_timeline(length: float) -> void:
	Tools.clear_node(time_ruler)
	anim_length = length
	set_range()
	slider.editable = true
	slider.value = 0.0
	time = 0.0
	playing = true
	background.update()


func set_time(t: float) -> void:
	time = t
	slider.value = time


func set_range() -> void:
	var step: float
	if anim_length < 0.6:
		step = 0.1
	elif anim_length < 1.6:
		step = 0.5
	elif anim_length < 6.0:
		step = 1.0
	elif anim_length < 16.0:
		step = 2.0
	elif anim_length < 35.0:
		step = 5.0
	elif anim_length < 100.0:
		step = 10.0
	else:
		step = 50.0
	var length: float = stepify(anim_length + step * 0.5, step)
	slider.max_value = length
	var nticks = int(length / step) + 1
	slider.tick_count = nticks
	for itick in range(nticks):
		if itick != 0:
			var separator: = VSeparator.new()
			separator.add_stylebox_override("separator", tick_style)
			separator.size_flags_horizontal = SIZE_EXPAND_FILL
			time_ruler.add_child(separator)
		var label: = Label.new()
		var t: float = float(itick) * length / float(nticks - 1)
		label.text = "%.1f" % t
		if t > anim_length:
			label.add_color_override("font_color", Color(0.5, 0.5, 0.5))
		time_ruler.add_child(label)


func _on_Background_draw() -> void:
	if playing:
		var width: float = background.rect_size.x * anim_length / slider.max_value
		var rect: = Rect2(Vector2(0, 0), Vector2(width, background.rect_size.y))
		background.draw_rect(rect, Color(0.26, 0.31, 0.40), true)


func _on_Slider_value_changed(value: float) -> void:
	if not playing:
		return
	if value > anim_length:
		slider.value = anim_length
	time = slider.value
	emit_signal("time_changed", time)

