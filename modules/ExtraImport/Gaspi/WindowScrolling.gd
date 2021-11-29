extends Control

# Margin scale:
# How far from the border the contents draw.
# 0 means no margin, the contents draw right next to the border.
# 2 means the margin is twice the border size.
export(float, 0, 10) var margin_scale: float = 0
# Opening time:
# The time it takes for the opening animation of this window to end.
export(float, 0, 5) var opening_time: float = 1
# Closing time:
# The time it takes for the closing animation of this window to end.
export(float, 0, 5) var closing_time: float = .5

# Node variables for easy access.
onready var _background_node := $Background
onready var _border_node := $Border
onready var _contents_node := $Contents
onready var _tween := $Tween

# Signals.
signal animation_ended()
signal opened()
signal closed()


func _ready() -> void:
	
	# Set minimum size based on the minimum size of the border.
	_border_node.rect_min_size = _border_node.texture.get_size()
	rect_min_size = _border_node.rect_min_size
	_background_node.rect_min_size = rect_min_size * 2/3
	
	# Animate opening.
	opening_animation()
	yield(self, "opened")
	
	# Set margins depending on the movement direction.
	var texture_size = _background_node.texture.get_size()
	
	if _background_node.scroll_velocity.x > 0:
		_background_node.margin_right = -texture_size.x
	elif _background_node.scroll_velocity.x < 0:
		_background_node.margin_left = texture_size.x

	if _background_node.scroll_velocity.y > 0:
		_background_node.margin_bottom = -texture_size.y
	elif _background_node.scroll_velocity.y < 0:
		_background_node.margin_top = texture_size.y
	
	# Set contents container margins.
	_contents_node.margin_bottom = - (margin_scale + 1) * _border_node.patch_margin_bottom
	_contents_node.margin_left = (margin_scale + 1) * _border_node.patch_margin_left
	_contents_node.margin_right = - (margin_scale + 1) * _border_node.patch_margin_right
	_contents_node.margin_top = (margin_scale + 1) * _border_node.patch_margin_top



func resize_animation(start_pos: Vector2, final_pos: Vector2, start_size: Vector2, final_size: Vector2, time: float = 1, to_hide: CanvasItem = _contents_node):
	
	# Save previous state of scrolling and stop scrolling.
	var prev_scrolling: bool = _background_node.scrolling
	_background_node.scrolling = false
	# Hide contents.
	if to_hide != null: to_hide.visible = false
	
	# Start opening animation.
	_tween.interpolate_property(self, "rect_size", start_size, final_size, time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	_tween.interpolate_property(self, "rect_position", start_pos, final_pos, time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	_tween.start()
	yield(_tween, "tween_all_completed") # Wait until the animation is over.
	# Animation is over.
	
	# Restore previous scrolling state.
	_background_node.scrolling = prev_scrolling
	# Show contents.
	if to_hide != null: to_hide.visible = true
	
	# Send signal.
	emit_signal("animation_ended")


func opening_animation(time = opening_time):
	resize_animation(rect_position + rect_size / 2 - rect_min_size / 2, rect_position, rect_min_size, rect_size, time)
	yield(self, "animation_ended")
	emit_signal("opened")


func closing_animation(time = closing_time):
	resize_animation(rect_position, rect_position + rect_size / 2 - rect_min_size / 2, rect_size, rect_min_size, time)
	yield(self, "animation_ended")
	emit_signal("closed")
