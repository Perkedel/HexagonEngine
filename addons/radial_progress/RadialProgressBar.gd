tool
extends Control


export var max_value = 100;
export var radius = 120; 
export var progress = 0;
export var thickness = 20 ;
export var bg_color : Color  = Color(0.5,.5,0.5,1);
export var bar_color :Color =  Color(0.2,.9,0.2,1);
var angle = 0.0 ; 
var tween = Tween.new();
func _ready():
	add_child(tween);
	pass # Replace with function body.

func set_max(value):
	max_value = value;
	_draw();

func set_progress(v):
	progress = v;
	update();

func set_radius_and_thickness(r,th):
	radius = r; 
	thickness = th;
	update();

func set_colors(bg,bar):
	bg_color = bg;
	bar_color = bar;
	update();

func _draw():
	draw_circle_arc(Vector2(0,0),radius,0,360,bg_color);
	angle = progress*360/max_value;
	draw_circle_arc(Vector2(0,0),radius,0,angle,bar_color);
	draw_circle_arc(Vector2(0,0),radius - thickness,0,360,bg_color);
	pass;
	
func _process(delta):
	 update();

func animate(duration,reverse = false,initial_value = 0):
	if reverse:
		tween.interpolate_method(self,"set_progress",max_value,initial_value,duration,Tween.TRANS_LINEAR,Tween.EASE_IN);
	else:
		tween.interpolate_method(self,"set_progress",initial_value,max_value,duration,Tween.TRANS_LINEAR,Tween.EASE_IN);
	tween.start();

func draw_circle_arc(center, radius, angle_from, angle_to, color):
	var nb_points = 32
	var points_arc = PoolVector2Array()
	points_arc.push_back(center)
	var colors = PoolColorArray([color])
	for i in range(nb_points + 1):
	    var angle_point = deg2rad(angle_from + i * (angle_to - angle_from) / nb_points - 90)
	    points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)
	draw_polygon(points_arc, colors)
