extends Control

var radius:float = 1.0 setget _set_radius
var color:Color = Color.white setget _set_color

func _init(radius:float = 1.0, color:Color = Color.white):
	self.radius = radius
	self.color = color

func _set_radius(value:float):
	radius = value
	update()

func _set_color(value:Color):
	color = value
	update()

func _draw():
	draw_circle(Vector2.ZERO, radius, color)
