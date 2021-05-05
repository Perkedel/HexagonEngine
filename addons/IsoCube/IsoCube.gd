tool
extends Control

class_name IsoCube

export (Texture) var top_texture setget set_top_texture
export (Color) var top_color : = Color(1,1,1) setget set_top_color
export (Texture) var left_texture setget set_left_texture
export (Color) var left_color : = Color(1,1,1) setget set_left_color
export (Texture) var right_texture setget set_right_texture
export (Color) var right_color : = Color(1,1,1) setget set_right_color
export (bool) var antialiasing = true setget set_antialiasing
export (float) var height = 1.0 setget set_height
export (bool) var perfect_iso = false setget set_perfect_iso

enum UvAdaptMode {
	NONE = 0,
	TOP = 1,
	BOTTOM = 2
}

export (UvAdaptMode) var adapt_uv = UvAdaptMode.TOP setget set_adapt_uv

###############################################
# Cache

# var
var _cached_side : float
var _cached_size : float = 64
var _cached_y_position_difference : float

# Colors Array
var _cached_top_pool_color : PoolColorArray
var _cached_left_pool_color : PoolColorArray
var _cached_right_pool_color : PoolColorArray

# Points Array
var _cached_top_point_array : PoolVector2Array
var _cached_left_point_array : PoolVector2Array
var _cached_right_point_array : PoolVector2Array

# Uvs
var _cached_adapted_uvs : PoolVector2Array
const _top_uv : Array = [Vector2(0,0), Vector2(1,0), Vector2(1,1), Vector2(0,1)]

###############################################
# Setter

func set_perfect_iso(new_value : bool):
	if new_value != perfect_iso:
		perfect_iso = new_value
		_update_rect_size()
		update()

func set_top_texture(new_texture : Texture):
	if new_texture != top_texture:
		top_texture = new_texture
		update()
		
func set_left_texture(new_texture : Texture):
	if new_texture != left_texture:
		left_texture = new_texture
		update()
		
func set_right_texture(new_texture : Texture):
	if new_texture != right_texture:
		right_texture = new_texture
		update()

func set_top_color(new_color : Color):
	if new_color != top_color:
		top_color = new_color
		_update_top_pool_color()
		update()

func set_left_color(new_color : Color):
	if new_color != left_color:
		left_color = new_color
		_update_left_pool_color()
		update()
		
func set_right_color(new_color : Color):
	if new_color != right_color:
		right_color = new_color
		_update_right_pool_color()
		update()

func set_antialiasing(new_bool : bool):
	if new_bool != antialiasing:
		antialiasing = new_bool
		update()

func set_height(new_height : float):
	if new_height != height:
		height = new_height
		_update_cached_adapted_uvs()
		_update_cached_y_position_difference()
		_update_all_pool_point()
		update()

func set_adapt_uv(new_type):
	if new_type != adapt_uv:
		adapt_uv = new_type
		_update_cached_adapted_uvs()
		update()

###############################################
# Updater

func _update_side():
	_cached_side = _cached_size if not perfect_iso else sqrt(pow(_cached_size,2)+pow(_cached_size*2,2))/2.0
	_update_cached_y_position_difference()
	_update_all_pool_point()
	
func _update_all_pool_point():
	_update_top_point_array()
	_update_left_point_array()
	_update_right_point_array()

func _update_all_pool_color():
	_update_top_pool_color()
	_update_left_pool_color()
	_update_right_pool_color()
		
func _update_top_pool_color():
	_cached_top_pool_color= [top_color, top_color, top_color, top_color]
	
func _update_left_pool_color():
	_cached_left_pool_color=[left_color, left_color, left_color, left_color]
	
func _update_right_pool_color():
	_cached_right_pool_color=[right_color, right_color, right_color, right_color]

func _update_top_point_array():
	_cached_top_point_array = [
		Vector2(_cached_size,_cached_y_position_difference),
		Vector2(_cached_size*2,_cached_size/2 + _cached_y_position_difference),
		Vector2(_cached_size,_cached_size +_cached_y_position_difference),
		Vector2(0,_cached_size/2 + _cached_y_position_difference)
	]

func _update_left_point_array():
	_cached_left_point_array = [
		Vector2(0,_cached_size/2 + _cached_y_position_difference),
		Vector2(_cached_size,_cached_size + _cached_y_position_difference),
		Vector2(_cached_size,_cached_size+_cached_side*height + _cached_y_position_difference),
		Vector2(0,_cached_size/2+_cached_side*height + _cached_y_position_difference)
	]
func _update_right_point_array():
	_cached_right_point_array = [
		Vector2(_cached_size,_cached_size + _cached_y_position_difference),
		Vector2(_cached_size*2,_cached_size/2 + _cached_y_position_difference),
		Vector2(_cached_size*2,_cached_size/2+_cached_side*height + _cached_y_position_difference),
		Vector2(_cached_size,_cached_size+_cached_side*height + _cached_y_position_difference)
	]

func _update_rect_size():
	_cached_size = rect_size.x/2
	_update_side()
	_update_cached_y_position_difference()
	rect_size.y = _cached_size + _cached_side
	update()

func _update_cached_y_position_difference():
	_cached_y_position_difference = (1.0-height)*_cached_side

func _update_cached_adapted_uvs():
	if adapt_uv == UvAdaptMode.BOTTOM:
		_cached_adapted_uvs = [Vector2(0,1.0-height), Vector2(1,1.0-height), Vector2(1,1), Vector2(0,1)]
	if adapt_uv == UvAdaptMode.TOP:
		_cached_adapted_uvs = [Vector2(0,0), Vector2(1,0), Vector2(1,height), Vector2(0,height)]
	if adapt_uv == UvAdaptMode.NONE:
		_cached_adapted_uvs = [Vector2(0,0), Vector2(1,0), Vector2(1,1), Vector2(0,1)]
		
###############################################
# Godot

func _init():
	_update_cached_adapted_uvs()
	_update_side()
	_update_all_pool_color()

func _ready():
	# warning-ignore:return_value_discarded
	connect("resized", self, "_update_rect_size")

func _draw():
	# Top face
	draw_polygon(_cached_top_point_array, _cached_top_pool_color, _top_uv, top_texture, null, antialiasing)
	# Left face
	draw_polygon(_cached_left_point_array, _cached_left_pool_color, _cached_adapted_uvs, left_texture, null, antialiasing)
	# Right face
	draw_polygon(_cached_right_point_array, _cached_right_pool_color, _cached_adapted_uvs, right_texture, null, antialiasing)
