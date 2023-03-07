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
	
	# shadow
	draw_primitive( p._arrow_vertices_shadow, p._arrow_colors_shadow, p._arrow_uvs, null)
	for i in range(p.vertices.size()):
		draw_primitive( p.vertices_shadow[i],p.colors_shadow[i],p.uvs[i],null )
	
	# background
	draw_primitive( p._arrow_vertices, p._arrow_colors, p._arrow_uvs, null)
	for i in range(p.vertices.size()):
		draw_primitive( p.vertices[i],p.colors[i],p.uvs[i],null )
