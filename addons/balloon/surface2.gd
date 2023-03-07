extends Control

var p

func _ready():
	rect_size = Vector2(16,16)

func ex_update(p):
	self.p = p
	update()
	
func _draw():
	if not p or not is_inside_tree():
		return
	if Engine.editor_hint and not p.get('vertices'):
		return
	if p.vertices.size()==0:
		return
	
	var scale = Vector2(1,1)/get_global_transform().basis_xform_inv(Vector2(1,1)) * p._bubble_extra
	draw_set_transform(p._offset*scale, 0, scale)
		
	var rendered = 0
	var y = p.globalY - p.font_height_adjust
	for l in p.lines:
		if p.typewriter and not Engine.editor_hint:
			var c = p._typewritter_offset
			if (rendered+l[1].length())<=c:
				draw_string(p.font,Vector2(l[0],y-p.font.get_descent())+p.of,l[1], p.text_color)
				rendered += l[1].length()
			else:
				draw_string(p.font,Vector2(l[0],y-p.font.get_descent())+p.of,l[1].substr(0,c-rendered), p.text_color)
				break
		else:
			draw_string(p.font,Vector2(l[0],y-p.font.get_descent())+p.of,l[1], p.text_color)
		y += l[2]
	
	if p.show_debug_messages:
		y = p.globalY
		for l in p.lines:
			draw_rect( Rect2(Vector2(l[0],y-p.font.get_height())+p.of, Vector2(-l[0]-l[0],p.font.get_height()) ), Color(0,1,0,0.2) )
			y += p.font.get_height()
