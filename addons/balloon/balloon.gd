######################################################################################################
#
#                   This work is licensed under a Creative Commons Attribution 4.0
#                                      International License.
#               Based on a work at https://github.com/marcosbitetti/godot_balloon_text.
#
# <a rel="license" href="http://creativecommons.org/licenses/by/4.0/"><img alt="Creative Commons License"
# style="border-width:0" src="https://i.creativecommons.org/l/by/4.0/88x31.png" /></a><br />This work is 
# licensed under a <a rel="license" href="http://creativecommons.org/licenses/by/4.0/">Creative Commons 
# Attribution 4.0 International License</a>.<br />Based on a work at <a 
# xmlns:dct="http://purl.org/dc/terms/" href="https://github.com/marcosbitetti/godot_balloon_text" 
# rel="dct:source">https://github.com/marcosbitetti/godot_balloon_text</a>.
#
######################################################################################################
#

tool
extends Control

# font normal_font bold_font italics_font bold_italics_font mono_font default_color 

export(String) var text = "" setget _set_text
export(float) var ratio = 1.0 setget _set_ratio
export(int) var font_height_adjust = 0 setget _set_font_height_adjust
export(int) var padding = 8 setget _set_padding
export(int) var shadown_width = 4 setget _set_shadown_width
export(Color) var text_color = Color(0,0,0,1) setget _set_text_color
export(Color) var color = Color(1,1,1,1) setget _set_color
export(Color) var color_center = Color(1,1,1,1) setget _set_color_center
export(Color) var color_shadow = Color(0,0,0,1) setget _set_color_shadow
export(float) var arrow_width = 0.25 setget _set_arrow_width
export(Font) var normal_font = preload("res://addons/balloon/assets/OpenComicFont.tres") setget _set_font
#export(Font) var bold_font
#export(Font) var italics_font
#export(Font) var bold_italics_font
#export(Font) var mono_font
export(NodePath) var lock_target = null setget _set_target
export(int) var words_per_minute = 200 # world median words readed by minute
export (bool) var typewriter = false
export(bool) var auto_hide = true
export(bool) var bubble_effect = false setget _set_bubble_effect
export(Material) var balloon_material = null setget _set_balloon_material
export(Material) var text_material = null setget _set_text_material
export(NodePath) var script_path = null setget _set_script_path
export(Theme) var ui_theme = preload("res://addons/balloon/assets/balloon.theme") setget _set_ui_theme

export var show_debug_messages = false

const BALLOON_HIDE_EVENT = "balloon_hide"
const BALLOON_TRUE = "balloon_true"
const BALLOON_FALSE = "balloon_false"

const RESOLUTION = 48.0

var config = {
	effects = {
		bubble = {
			initial = Vector2(1.45,1.45),
			duration = 0.6,
		},
		
		typewriter = {
			time = 1.0/15
		}
	},
	resolution = RESOLUTION
}

var vertices = Array()
var colors = Array()
var vertices_shadow = Array()
var colors_shadow = Array() 
var uvs = Array()
var _arrow_vertices = Array()
var _arrow_colors = Array()
var _arrow_vertices_shadow = Array()
var _arrow_colors_shadow = Array()
var _arrow_uvs = Array()
var of = Vector2()
var _offset = Vector2()
var area = 0.0
var rad = 0.0
var font = null
var lines = []
var globalY = 0
var arrow_target = null
var extra_offset = Vector2()
var _is3D = false
var old_tg_pos = Vector2()
var _arrow_target = Vector2()
var delay = 0
var is_opened = false
var _stream = null
var _tweener = Tween.new()
var _bubble_extra = Vector2(1,1)
#var _surface1 = preload("res://addons/balloon/background.tscn").instance()
var _surface1 = preload("res://addons/balloon/surface1.gd").new()
var _surface2 = preload("res://addons/balloon/surface2.gd").new()
var _panel = VBoxContainer.new()
var _script_path = null
var response1 = null
var response2 = null
var responses = []
var _typewritter_offset = 0
var _typewritter_delay = 0
var _letter_count = 0

####################
#
#  Gettes/Setters
#
####################

# helper to dismiss a lot of this same IF
func __need_update():
	if text and text.length()>0:
		render_text(text)
	update()
	
# set target from string
func _set_target(name=""):
	if not name or name=="":
		lock_target = null
		arrow_target = null
		_arrow_target = Vector2()
		update()
		return
		
	var lt = str(name)
	if lt.find('../') != 0 and lt.find('/')!=0:
		lt = '../' + lt
	if has_node(lt):
		var obj = get_node(lt)
		if obj:
			target(obj)
			update()
	lock_target = name

func _set_text(txt):
	lines.clear()
	vertices.clear()
	if not txt:
		txt = ""
	text = txt
	if txt == "" and not Engine.editor_hint:
		hide()
	else:
		render_text(txt)
		update()

func _set_font(fnt):
	if not fnt:
		if show_debug_messages:
			print('a ',.get_font('font'))
		fnt = .get_font('font')
	if ui_theme:
		#if ui_theme.get_font('font','Button')==.get_font('font'):
		ui_theme.set_font('font','Button', fnt)
	normal_font = fnt
	__need_update()

func _get_font():
	#return get_font('normal_font')
	normal_font

func _set_ratio(r):
	ratio = float(r)
	__need_update()
	
func _set_padding(p):
	padding = float(p)
	__need_update()

func _set_font_height_adjust(v):
	font_height_adjust = float(v)
	__need_update()

func _set_shadown_width(w):
	shadown_width = float(w)
	__need_update()
	
func _set_text_color(c):
	text_color = c
	__need_update()

func _set_color(c):
	color = c
	__need_update()

func _set_color_center(c):
	color_center = c
	__need_update()	

func _set_color_shadow(c):
	color_shadow = c
	__need_update()

func _set_arrow_width(w):
	arrow_width = float(w)
	__need_update()

func _set_balloon_material(m):
	if _surface1:
		_surface1.material = m
	balloon_material = m
	__need_update()

func _set_text_material(m):
	if _surface2:
		_surface2.material = m
	text_material = m
	__need_update()

func _set_ui_theme(t):
	ui_theme = t
	__need_update()

func _set_script_path(name=null):
	if name==null:
		_script_path = null
		script_path = null
		return
	var lt = str(name)
	if lt.find('/') != 0:
		name = '../' + lt
	if has_node(name):
		_script_path = get_node(name)
		script_path = name
	else:
		_script_path = null
	script_path = name

func _set_bubble_effect(v):
	if not v:
		v = false
	else:
		v = true
	bubble_effect = v
	if not Engine.editor_hint:
		if bubble_effect:
			add_child(_tweener)
			_tweener.interpolate_method( self,"_bubble", config.effects.bubble.initial, Vector2(1,1), config.effects.bubble.duration, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
		else:
			if _tweener.get_parent():
				remove_child(_tweener)

#
# set a target object
func target(obj):
	var c = obj.get_class()
	while true:
		var p = ClassDB.get_parent_class(c)
		if show_debug_messages:
			printt('object class: ', c, "\nparent class: ",p)
		if c=='Spatial' or p=='Spatial':
			_is3D = true
			break
		elif c=='Node2D' or p=='Node2D':
			_is3D = false
			break
		elif c=='Control' or p=='Control':
			var nd = Node2D.new()
			nd.position = obj.rect_size / 2.0
			nd.set_meta('balloon_arrow_target',true)
			obj.add_child(nd)
			obj = nd
			break
		c = p
		if p=='Object':
			break
		
	if arrow_target:
		if arrow_target.get_meta('balloon_arrow_target'):
			arrow_target.queue_free()			
	arrow_target = obj
	
	if obj:
		set_process(true)
	else:
		set_process(false)


#
# Render spoked text
# return time in seconds that baloon remains visible
#
func say(txt, time=null):
	var words = render_text(txt)
	if time==null:
		time = (float(words) / float(words_per_minute)) * 60
	delay = time
	set_process(true)
	is_opened = true
	update()
	show()
	
	return time

#
# Render spoked text and waithing a stream to end
# return time in seconds that baloon remains visible
#
func sat_with_stream(txt, stream):
	var t = say(txt)
	if stream:
		delay = 1000
		_stream = stream
	return -1

#
# Render spoked text, and whait user interation
# return time in seconds that baloon remains visible
#
func ask(txt, param1 = null, param2 = null, param3 = null, param4 = null):
	var t = say(txt)
	var _ratio = Vector2(1.0/ratio, ratio)
	
	if _panel:
		_panel.queue_free()
		_panel = null
	
	responses.clear()
	response1 = null
	response2 = null
	
	# mode Yes/No
	if not param1:
		_panel = HBoxContainer.new()
		_panel.alignment = HALIGN_CENTER
		var yes = Button.new()
		yes.text = tr('Yes')
		yes.size_flags_horizontal = SIZE_FILL | SIZE_EXPAND
		yes.connect("pressed", self, "_button_true_clicked")
		var no = Button.new()
		no.text = tr('No')
		no.size_flags_horizontal = SIZE_FILL | SIZE_EXPAND
		no.connect("pressed", self, "_button_false_clicked")
		_panel.add_child(no)
		_panel.add_child(yes)
	elif typeof(param1)==TYPE_STRING and typeof(param2)==TYPE_STRING:
		var yes = Button.new()
		yes.text = tr( param1 )
		yes.size_flags_horizontal = SIZE_FILL | SIZE_EXPAND
		yes.connect("pressed", self, "_button_true_clicked")
		var no = Button.new()
		no.text = tr( param2 )
		no.size_flags_horizontal = SIZE_FILL | SIZE_EXPAND
		no.connect("pressed", self, "_button_false_clicked")
		if typeof(param3)==TYPE_STRING:
			response1 = param3
		if typeof(param4)==TYPE_STRING:
			response2 = param4
		if typeof(param3)==TYPE_INT or (typeof(param2)==TYPE_STRING and typeof(param4)==TYPE_INT):
			_panel = HBoxContainer.new()
			_panel.add_child(no)
			_panel.add_child(yes)
		else:
			_panel = VBoxContainer.new()
			_panel.add_child(yes)
			_panel.add_child(no)
		_panel.alignment = HALIGN_CENTER
	elif typeof(param1)==TYPE_ARRAY:
		_panel = VBoxContainer.new()
		_panel.alignment = HALIGN_CENTER
		var pary_functions = typeof(param2)==TYPE_ARRAY and param2.size()==param1.size()
		var index = 0
		for resp in param1:
			var r = Button.new()
			r.size_flags_horizontal = SIZE_FILL | SIZE_EXPAND
			r.text = tr(resp)
			r.connect("pressed", self, "_button_resp_clicked", [index])
			_panel.add_child(r)
			if pary_functions:
				responses.append(param2[index])
			index += 1
		if typeof(param2)==TYPE_STRING:
			response1 = param2
	
	if ui_theme:
		_panel.theme = ui_theme
	
	var size = int( (rad*_ratio.x*2.0) * 0.8 ) # 80%
	if size < int( (rad*_ratio.x*2.0) * 0.2 ):
		size = int( (rad*_ratio.x*2.0) * 0.2 ) # 20%
	_panel.rect_min_size = Vector2(size,_panel.rect_size.y)
	#_panel.rect_position = Vector2(int(rad*_ratio.x - size*0.5),int(rad*_ratio.y*2.0 + padding*2 + shadown_width) )
	add_child(_panel)
		
	update()
	delay = 10000
	
	return -1



#
# Overrides get_font
#
func get_font(fnt, strs = ""): # JOELwindows7 edit, second parameter override still has to exist despite defaulted in parent
	match fnt:
		#'bold_font': return bold_font
		#'italics_font': return italics_font
		#'bold_italics_font': return bold_italics_font
		#'mono_font': return mono_font
		_: return normal_font #normal_font
	
func render_text(txt):
	if not txt or txt.length()==0:
		return -1
	var _ratio = Vector2(1.0/ratio, ratio)
	var arr1 = txt.strip_edges().split(" ")
	var letters = 0
	var longString = ''
	var words = []
	lines.clear()
	
	for k in arr1:
		var tk
		if k.find("\n")>-1:
			for k2 in k.split("\n"):
				if show_debug_messages:
					print(k2)
				pass
		else:
			tk = k
			letters += tk.length() + 1
		words.append([tk])
		longString += tk
	
	# area
	font = get_font("normal_font")
	if not font:
		font = .get_font('font')
	
	var _area = font.get_string_size(longString)
	area = float(_area.x * _area.y)
	rad = sqrt(float(area) / PI) * 1.00 + font.get_height()
	
	_letter_count = txt.length()
	
	#
	# render text
	#
	var x = 0
	var y = ( -rad *_ratio.y ) + font.get_height() #+ (font.get_height() * _ratio.y) # - font.get_descent()
	var w = 0
	var end = words.size()
	var spc = font.get_string_size(" ")
	var c_rad = rad
	
	if show_debug_messages:
		printt('initial radius:',rad)
		
	while w<end: #y<=rad:
		#var corda = round(rad * cos(abs(y)/rad))
		var f = ( rad - abs(y) ) # * _ratio.y
		var corda = 2.0 * round( sqrt( max( abs(f * (2.0 * rad - f)), abs(f * (2.0 * rad - f - font.get_height()))) ) ) * _ratio.x
		var corda2 = 2.0 * round( sqrt( min( abs(f * (2.0 * rad - f)), abs(f * (2.0 * rad - f - font.get_height()))) ) ) * _ratio.x
		var st = ''
		x = 0
		while w<end: #x<corda and w<end:
			var old_st = st
			var old_x = x
			st += words[w][0]
			x = font.get_string_size(st).x # + spc.x
			st += " "
			if x>corda:
				st = old_st
				x = old_x
				break
			else:
				w += 1
		var c = -x*0.5 # (2.0*rad - x)*0.5
		#draw_string( font, Vector2(c,y), st, Color(0,0,0,1) )
		lines.append([c,st,font.get_height()])
		if show_debug_messages:
			printt("String size is: ", font.get_string_size(" "))
		var line_rad = max( sqrt(pow(x*0.5*_ratio.y,2) + pow(y*_ratio.x,2)), sqrt(pow(x*0.5*_ratio.y,2) + pow(y*_ratio.x+font.get_height(),2)) )
		if line_rad>c_rad:
			c_rad = line_rad
		y += font.get_height() #* _ratio.x
		if show_debug_messages:
			printt(corda,x, x*_ratio.y*0.5, rad,st, _ratio)
	rad = c_rad
	globalY = font.get_height() - (rad * _ratio.y - ( rad * 2.0 * _ratio.y - float(lines.size()) * font.get_height() ) * 0.5) + font_height_adjust
	
	if show_debug_messages:
		printt('final radius:',rad)
	
	# render ballon
	var resolution = RESOLUTION
	var a = (PI*2)/resolution
	var p = padding * font.get_string_size(" ").y
	vertices.clear()
	colors.clear()
	uvs.clear()
	vertices.append( [Vector2(0,0),Vector2(0,0),Vector2(0,0)] )
	colors.append( [color_center,color,color] )
	uvs.append([Vector2(0.5,0.5),Vector2(0.5,0.5),Vector2(0.5,0.5)])
	var _rad = rad + padding
	for i in range(resolution):
		var x0 = rad*_ratio.x + cos(a*i)*_rad * _ratio.x
		var y0 = rad*_ratio.y + sin(a*i)*_rad * _ratio.y
		var x1 = rad*_ratio.x + cos((a*i)+a)*_rad * _ratio.x
		var y1 = rad*_ratio.y + sin((a*i)+a)*_rad * _ratio.y
		vertices.push_back( [Vector2(rad*_ratio.x,rad*_ratio.y), Vector2(x0,y0), Vector2(x1,y1)] )
		colors.push_back( [color_center,color,color] )
		uvs.push_back([Vector2(0.5,0.5),Vector2(0.5+cos(a*i)*0.5,0.5+sin(a*i)*0.5),Vector2(0.5+cos((a*i)+a)*0.5,0.5+sin((a*i)+a)*0.5)])
	
	a = (PI*2)/resolution
	vertices_shadow.clear()
	colors_shadow.clear()
	vertices_shadow.append( [Vector2(0,0),Vector2(0,0),Vector2(0,0)] )
	colors_shadow.append( [color_shadow,color_shadow,color_shadow] )
	for i in range(resolution):
		var x0 = rad*_ratio.x + cos(a*i)*_rad * _ratio.x + cos(a*i) * shadown_width
		var y0 = rad*_ratio.y + sin(a*i)*_rad * _ratio.y + sin(a*i) * shadown_width
		var x1 = rad*_ratio.x + cos((a*i)+a)*_rad * _ratio.x + cos((a*i)+a) * shadown_width
		var y1 = rad*_ratio.y + sin((a*i)+a)*_rad * _ratio.y + sin((a*i)+a) * shadown_width
		vertices_shadow.push_back( [Vector2(rad*_ratio.x,rad*_ratio.y), Vector2(x0,y0), Vector2(x1,y1)] )
		colors_shadow.push_back( [color_shadow,color_shadow,color_shadow] )
	
	extra_offset = Vector2(_rad,_rad) * _ratio
	
	if not arrow_target:
		update()
	
	if Engine.editor_hint and is_inside_tree():
		var s = Vector2(round(rad*2),round(rad*2))*_ratio
		s = s * Vector2(1,1)/get_global_transform().basis_xform_inv(Vector2(1,1))
		s = Vector2(abs(int(s.x)),abs(int(s.y)))
		rect_size = s
	
	# runtime effects
	if not Engine.editor_hint:
		if typewriter:
			_typewritter_offset = 0
			_typewritter_delay = config.effects.typewriter.time
		
		if _tweener.get_parent():
			_tweener.reset_all()
			_tweener.start()
	
	return words.size()

func _bubble(v):
	_bubble_extra = v
	if lines.size()>0:
		update()

func _draw():
	var _ratio = Vector2(1.0/ratio, ratio)
	if Engine.editor_hint:
		draw_texture( preload("res://addons/balloon/assets/icon_balloon.png"), Vector2(-8,-8) + rect_size*0.5, Color(1,1,1,1) )
		if text=="":
			var cr = Color("#a5efac")
			if arrow_target and vertices.size():
				draw_line( Vector2(-3,7) + rect_size*0.5, _arrow_target, Color("#a5efac"), 1 )
			return
	
	if vertices.size()==0 or lines.size()==0:
		return
	
		# adjust to fit screen
	var left_top = rect_global_position #- extra_offset
	var right_bottom = rect_global_position + extra_offset*2.0
	var computed_size = Vector2(right_bottom.x-left_top.x,right_bottom.y-left_top.y)
	if _panel and _panel.get_child_count()>0:
		computed_size.x = max(computed_size.x,_panel.rect_size.x)
		computed_size.y = computed_size.y + _panel.rect_size.y + padding
	_offset = Vector2()
	
	if left_top.x<(padding + shadown_width):
		_offset.x = (padding + shadown_width) - left_top.x
	if left_top.y<(padding + shadown_width):
		_offset.y = padding + shadown_width - left_top.y
	if (left_top.x+computed_size.x-padding-shadown_width) > get_viewport().get_visible_rect().size.x:
		_offset.x = -((left_top.x+computed_size.x) - get_viewport().get_visible_rect().size.x)
	if (left_top.y+computed_size.y-padding-shadown_width) > get_viewport().get_visible_rect().size.y:
		_offset.y = -((left_top.y+computed_size.y) - get_viewport().get_visible_rect().size.y)

	_arrow_vertices = [Vector2(),Vector2(),Vector2()]
	_arrow_colors = [color,color,color]
	_arrow_vertices_shadow = [Vector2(),Vector2(),Vector2()]
	_arrow_colors_shadow = [color_shadow,color_shadow,color_shadow]
	_arrow_uvs = [Vector2(0,0),Vector2(0,0),Vector2(0,0)]
	
	# draw arrow
	of = Vector2(rad*_ratio.x,rad*_ratio.y)
	var _t = _arrow_target
	if not arrow_target:
		_t = of
	var nor = (_t - of).normalized()
	var per = Vector2(-nor.y,nor.x)
	_arrow_vertices[0] = _t - shadown_width*nor - _offset
	_arrow_vertices[1] = per * _ratio * (rad+padding) * arrow_width + of
	_arrow_vertices[2] = per * _ratio * (-rad-padding) * arrow_width + of
	_arrow_vertices_shadow[0] = _t + shadown_width * nor - _offset
	_arrow_vertices_shadow[1] = per * (rad+padding) * arrow_width * _ratio + per * shadown_width*_ratio.x + of
	_arrow_vertices_shadow[2] = per * (-rad-padding) * arrow_width * _ratio - per * shadown_width*_ratio.x + of
	if _bubble_extra!=Vector2(1,1):
		var _v = Vector2(1,1)/_bubble_extra
		_arrow_vertices[0] *= _v
		_arrow_vertices_shadow[0] *= _v
	nor = (_t - of).normalized() #_t.normalized()
	per = Vector2(-nor.y,nor.x)
	_arrow_uvs[0] = Vector2(0.5,0.5) + nor*((((_t-of)).length()-padding-rad)/rad)*0.5 #+ nor*0.5
	#_arrow_uvs[0] = Vector2(0.5,0.5) + nor*0.5
	_arrow_uvs[1] = Vector2(0.5,0.5) + per * arrow_width * 0.5
	_arrow_uvs[2] = Vector2(0.5,0.5) - per * arrow_width * 0.5
	
	draw_set_transform(_offset, 0, Vector2(1,1))
		
	if _panel and _panel.get_child_count()>0:
		_panel.rect_position = Vector2(int(((_panel.rect_size.x*-0.5 + rad*_ratio.x)+_offset.x)*_bubble_extra.x),int(((rad*_ratio.y*2.0 + padding*2 + shadown_width)+_offset.y)*_bubble_extra.y) )
	
	if _surface1:
		if Engine.editor_hint and _surface1.has_method('ex_update'):
			_surface1.emit_signal("draw")
			_surface2.emit_signal("draw")
		else:
			_surface1.ex_update(self)
			_surface2.ex_update(self)


func _process(delta):
	if arrow_target:
		if _is3D:
			var cam = get_viewport().get_camera()
			if cam:
				_arrow_target = cam.unproject_position(arrow_target.global_transform.origin) - get_global_transform().origin
		else:
			_arrow_target = arrow_target.global_position - get_global_transform().origin
		if _arrow_target != old_tg_pos:
			old_tg_pos = _arrow_target
			update()
	
	if delay>0:
		delay -= delta
		if delay<0:
			delay=0
			if auto_hide:
				set_process(false)
				is_opened = false
				hide()
	
	# runtime effects
	if not Engine.editor_hint:
		if typewriter:
			_typewritter_delay -= delta
			if _typewritter_delay<=0:
				_typewritter_delay = config.effects.typewriter.time
				_typewritter_offset += 1
				if _typewritter_offset<=_letter_count:
					update()

func _button_true_clicked():
	var p = _script_path
	if not p:
		p = get_parent()
	if response1 and not response2:
		if p.has_method(response1):
			p.call_deferred(response1,true)
	if response1 and response2:
		if p.has_method(response1):
			p.call_deferred(response1)
	emit_signal(BALLOON_TRUE)
	hide()
	set_process(false)
	if show_debug_messages:
		print('true clicked')

func _button_false_clicked():
	var p = _script_path
	if not p:
		p = get_parent()
	if response1 and not response2:
		if p.has_method(response1):
			p.call_deferred(response1,false)
	if response1 and response2:
		if p.has_method(response2):
			p.call_deferred(response2)
	emit_signal(BALLOON_FALSE)
	hide()
	set_process(false)
	if show_debug_messages:
		print('false clicked')

func _button_resp_clicked(index):
	var nm
	if responses.size()>0:
		nm = responses[index]
	else:
		if response1:
			nm = response1
	var p = _script_path
	if not p:
		p = get_parent()
	if p.has_method(nm):
		if responses.size()>0:
			p.call(nm)
		else:
			p.call(nm,index)
	if show_debug_messages:
		if responses.size()==0:
			print( 'Option ' + str(index) + ' clicked')
		else:
			print( 'Option \"' + nm + '\" clicked')
	hide()
	set_process(false)

func _rec_changed():
	#update()
	pass

func _force_update():
	if lock_target:
		_set_target(lock_target)
	else:
		update()

func _init():
	set_meta("type","balloon")
	add_user_signal(BALLOON_TRUE)
	add_user_signal(BALLOON_FALSE)
	add_user_signal(BALLOON_HIDE_EVENT)

func _ready():
	if not normal_font:
		#normal_font = .get_font('font')
		self.normal_font = .get_font('font')
	#if not bold_font:
	#	bold_font = .get_font('font')
	#if not italics_font:
	#	italics_font = .get_font('font')
	#if not bold_italics_font:
	#	bold_italics_font = .get_font('font')
	#if not mono_font:
	#	mono_font = .get_font('font')
	
	# surfaces
	if Engine.editor_hint:
		#_surface1.add_script(preload("res://addons/balloon/surface1.gd").get_script())
		#_surface2.add_script(preload("res://addons/balloon/surface2.gd").get_script())
		#_surface1.connect("draw",_surface1, "ex_update",[vertices,colors,uvs,vertices_shadow,colors_shadow,_arrow_vertices,_arrow_colors,_arrow_uvs,_arrow_vertices_shadow,_arrow_colors_shadow] )
		_surface1.connect("draw",_surface1, "ex_update",[self] )
		_surface2.connect("draw",_surface2, "ex_update",[self] )
	add_child(_surface1)
	add_child(_surface2)
	
	# prevent wrong initialization
	set_process(false)
	
	# if lock target exist set arrow to it
	if lock_target:
		_set_target(lock_target)
	
	if Engine.editor_hint:
		update()
		#connect("item_rect_changed",self,"_rec_changed")
		return
	
	#rect_min_size = Vector2(500,500)
	if text and text.length()>0:
		if Engine.editor_hint:
			_set_text(text)
		else:
			say(text)
	else:
		hide()
