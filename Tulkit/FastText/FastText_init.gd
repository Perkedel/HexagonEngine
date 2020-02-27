#extends Label
#class_name FastTextInit

class_name FastTextInit
extends Label

func _enter_tree():
    _FastTextEnterTree()

func _ready():
    _FastTextReady()

func _process(delta):
    _FastTextProcess(delta)

func _unhandled_input(event):
    _FastTextUnhandledInput(event)

############################################ FastText Area - init
export              var FastText 				= true
export              var AllowInput	     		= true
enum UseType {sprite, control}
export (UseType)    var TargetType				= UseType.control
export (bool)       var AllowSignalTextChanged  = true
enum InputType {Line_Edit, Text_Edit}
export (InputType)  var InputBoxType            = InputType.Line_Edit
export(NodePath)    var InputBoxParent 			= null
export(bool) 	    var InputBoxStyleInherited 	= true
export(StyleBox)    var InputBoxStyle			= StyleBoxEmpty
export(bool) 	    var InputBoxFontInherited	= true
export(Font) 	    var InputBoxFont			= null
export var InputBoxAlwaysEmpty					= false
export var InputBoxFullWidth					= true
export var InputBoxCustomRect : Rect2			= Rect2(0,0,0,0)

export (String) var InputBoxScript="res://FastText/_FastText_IC_custom_script.gd"

var sprite_suffix 		= "_spr"
var duplicate_suffix 	= "_dup"
var control_suffix 		= "_ctr"
var inputControl_suffix = "_inp"

var Spr : Sprite		= null
var Lab : Label			= null
var VP  : Viewport		= null
var CT  : TextureRect	= null
var IC	: Object		= null   # InputType

var parent: Node		= null

signal text_changed         ; var text_changed_str="text_changed"   # Emitted when text has changed

var IC_OtherAlreadyOpenMeta 	 = "FastTextICAlreadyOpen"			# true/false
var IC_OtherAlreadyOpenOwnerMeta = "FastTextICAlreadyOpenOwner"     # object
var IC_ScriptReference		 	 = "FastTextICScriptReference"		# TextEdit custom script


var yielding 			  	= false
var processed			  	= false
var processOpenTextEdit		= false
var processCreateControl	= false
var processCreateSprite		= false
var processCloseTextEdit  	= false
var processSetVisible	  	= false	; var FastEditVisibleFlag	= false
var processParentNodeToAbs	= false
var NothingToDo	= false


# Flags ####################################
var isUpdating = false

############################################ FastText Area - end
############################################ FastText Funcion Area - init

func _FastTextInit():
    if !FastText:
        return

    if get_name().right(duplicate_suffix.length()) == duplicate_suffix:
        FastText = false
        return
    if AllowInput:
        processCreateControl = true
    elif TargetType == UseType.control:
        processCreateControl = true
    elif TargetType == UseType.sprite:
        processCreateSprite  = true

    connect ("item_rect_changed",self,"_FastText_item_rect_changed")
    return

func _FastTextEnterTree():
    if !FastText:
        return
    _FastTextCheckConsistency()
    _FastTextGetParent()
    if InputBoxParent == null:
        InputBoxParent = parent.get_path()
    InputBoxParent =_FastTextNodepathToAbsolute(InputBoxParent)
    if _IC_is_global_already_open():
        _IC_init_global()
    pass

func _FastTextReady():
    if !FastText:
#		remove_child($VP)
        return

    _VP_open()
    Lab=_dupe()
#	Lab.set_position(get_position())
    VP.add_child(Lab)
    Lab.set_position(Vector2(0,0))

func _FastTextProcess(delta):
    if !FastText:
        return
    elif processOpenTextEdit:
        _IC_open()
        processOpenTextEdit = false
    elif processCloseTextEdit:
        _IC_close()
        processCloseTextEdit = false
    elif NothingToDo:
        if processSetVisible:
            FastTextSetVisible()
            processSetVisible=false
        pass
        #set_process(false)
    elif processParentNodeToAbs:
        InputBoxParent =_FastTextNodepathToAbsolute(InputBoxParent)
        processParentNodeToAbs = false
    elif processCreateSprite:
        _spr_open(parent)
        processCreateSprite = false
    elif processCreateControl:
        _CT_open()
        processCreateControl = false
    elif !processed:
        _capture(VP)
    elif processed:
        .set_visible(false)
        remove_child(VP)
        NothingToDo = true
    return




func _FastTextUnhandledInput(event):
    if !FastText:
        pass
    elif !AllowInput:
        pass
    elif (event is InputEventMouseButton
    and   event.is_pressed()
    and   IC != null
    and   IC.is_visible()
    and   !IC.get_rect().has_point(event.position)
        ):
#		var dd=IC.get_rect().has_point(event.position)
#		var rec=IC.get_rect()
#		var po=event.position
#		if !rec.has_point(po):
        accept_event()
        processCloseTextEdit = true


func _VP_open():
    if has_node("VP"):
        VP = get_node_or_null("VP")
    elif has_node("Viewport"):
        VP = get_node_or_null("Viewport")
    else:
        VP=Viewport.new()
        VP.set_transparent_background(true)
        VP.set_handle_input_locally(false)
        VP.set_disable_3d(true)
        VP.set_usage(Viewport.USAGE_2D)
        VP.set_vflip(true)
        VP.set_clear_mode(Viewport.CLEAR_MODE_ALWAYS)
        VP.set_update_mode(Viewport.UPDATE_ALWAYS)
        VP.set_disable_input(false)
        add_child(VP)
    VP.set_size(get_size())


func _IC_CreateNew():
    var obj = null
    if   InputBoxType == InputType.Line_Edit:
        obj = LineEdit.new()
    elif InputBoxType == InputType.Text_Edit:
        obj = TextEdit.new()
    return obj

func _IC_set_wrap_enabled(inp):
    if   InputBoxType == InputType.Line_Edit:
        pass
    elif InputBoxType == InputType.Text_Edit:
        IC.set_wrap_enabled(true)



func _IC_open():
    if _IC_is_global_already_open():
        var other = _IC_get_global_owner()
        other._IC_close()
        _IC_init_global()

    _IC_set_global_open()

    if IC == null:
        IC = _IC_CreateNew()
        IC.set_name(get_IC_name())
        IC.set_theme(get_theme())
        _IC_init_script()
        if InputBoxFullWidth:
            var ws = get_viewport().get_size()
            InputBoxCustomRect.size = ws - InputBoxCustomRect.position
            InputBoxCustomRect.size.y = get_size().y
        if InputBoxCustomRect.has_no_area():
            IC.set_size(get_size())
            IC.set_position(get_global_position())
        else:
            IC.set_size(InputBoxCustomRect.size)
            IC.set_position(InputBoxCustomRect.position)

        if (!InputBoxStyleInherited
        and !InputBoxFontInherited
        and InputBoxStyle == StyleBoxEmpty
        and InputBoxFont  == null):
            pass
        else:
            var them = IC.get_theme()
            if them == null:
                them=Theme.new()
                them.copy_default_theme()
                IC.set_theme(them)

            if  InputBoxStyleInherited:
                var styl = them.get_stylebox_list(IC.get_class())
                var stylme=get_stylebox(them.get_stylebox_list(get_class())[0])
                for i in styl:
                    IC.add_stylebox_override(i,stylme)
                pass
            elif InputBoxStyle != StyleBoxEmpty:
                var styl = them.get_stylebox_list(IC.get_class())
                for i in styl:
                    IC.add_stylebox_override(i,InputBoxStyle)
            if  InputBoxFontInherited:
                var fontl = them.get_font_list(IC.get_class())
                var fontme=get_font(them.get_font_list(get_class())[0])
                for i in fontl:
                    IC.add_font_override(i,fontme)
            elif InputBoxFont != null:
                var fontl = them.get_font_list(IC.get_class())
                for i in fontl:
                    IC.add_font_override(i,InputBoxFont)
        _IC_set_wrap_enabled(true)
        IC.connect("gui_input",self,"_CT_gui_input")
        IC.connect("focus_exited",self,"_IC_focus_exited")
#		IC.connect("text_changed",self,"_IC_text_changed")
#		IC.connect("mouse_exited",self,"_IC_focus_exited")
    if InputBoxParent != null:
        get_node(InputBoxParent).add_child(IC)
        IC.set_owner(get_node(InputBoxParent))
    else:
        parent.add_child(IC)
        IC.set_owner(parent)
    IC.get_parent().move_child(IC,0)
#	IC.raise()
    IC.set_visible(true)
    IC.set_process(true)
    IC.grab_focus()
    if InputBoxAlwaysEmpty:
        IC.set_text("")
    else:
        IC.set_text(get_text())

func _IC_close():
    IC.set_visible(false)
    set_text(IC.get_text())
    update() # update text

func _IC_focus_exited():
    IC.set_visible(false)
    IC.set_process(false)
    parent.remove_child(IC)
#	_resample()
    pass

func _IC_input(event):
    if !FastText:
        pass
    elif !AllowInput:
        pass
    elif (event is InputEventMouseButton
    and   event.is_pressed()
    and   IC != null
    and   IC.is_visible()
    and   !IC.get_rect().has_point(event.position)
        ):
        processCloseTextEdit = true
        return true
    elif (event is InputEventKey
    and   event.get_scancode() == KEY_ENTER):
        processCloseTextEdit = true
        return true
    return false


func _IC_init_script():
    var script = _IC_get_script_into_meta()
    if script == null:
        script = load(InputBoxScript)
        _IC_set_script_from_meta(script)
    IC.set_script(script)

func _IC_get_script_into_meta():
    if get_tree().has_meta(IC_ScriptReference):
        return get_tree().get_meta(IC_ScriptReference)
    else:
        return null

func _IC_set_script_from_meta(ref):
    get_tree().set_meta(IC_ScriptReference,ref)

func _IC_is_global_already_open():
    if get_tree().has_meta(IC_OtherAlreadyOpenMeta):
        return get_tree().get_meta(IC_OtherAlreadyOpenMeta)
    return null

func _IC_get_global_owner():
    if get_tree().has_meta(IC_OtherAlreadyOpenOwnerMeta):
        return get_tree().get_meta(IC_OtherAlreadyOpenOwnerMeta)
    return null

func _IC_set_global_open():
    get_tree().set_meta(IC_OtherAlreadyOpenMeta,true)
    get_tree().set_meta(IC_OtherAlreadyOpenOwnerMeta,self)

func _IC_init_global():
    get_tree().set_meta(IC_OtherAlreadyOpenMeta,false)
    get_tree().set_meta(IC_OtherAlreadyOpenOwnerMeta,null)
func _IC_text_changed():
    pass

func _FastTextNodepathToAbsolute(np=null):   # np:nodepath
    var newNodePath = np
    var ps:String
    var nodop = null
    if   (np != null
    and   np is Node):
        nodop = np
    elif (np != null
    and   np is NodePath):
        nodop = get_node_or_null(np)

    if nodop != null:
        if nodop.is_inside_tree():
            if nodop != null:
                ps = nodop.get_path()
                if ps != "":
                    newNodePath= NodePath(ps)
        else:
            processParentNodeToAbs = true
    return newNodePath

func  _FastTextGetParent():
    if parent == null:
        parent = get_parent()
        if TargetType != UseType.control:
            if parent is CanvasLayer:
                parent = get_parent()

func _FastTextCheckConsistency():
    if (InputBoxScript == null
    or  InputBoxScript == ""):
        AllowInput = false

    if AllowInput:
        TargetType = UseType.control

    if InputBoxFontInherited:
        InputBoxFont = null

    if InputBoxStyleInherited:
        InputBoxStyle = StyleBoxEmpty

func  _CT_open():
    if CT == null:
        CT= TextureRect.new()
        CT.set_name(get_CT_name())
        parent.add_child(CT)
        CT.set_owner(parent)
        CT.set_size(get_size())
        CT.set_position(get_position())
    if AllowInput:
        CT.connect("gui_input",self,"_CT_gui_input")

func _CT_gui_input(event):
    if !FastText:
        pass
    if !AllowInput:
        pass
    if !CT.is_visible():
        pass
    elif (event is InputEventMouseButton
    and event.is_pressed()
    and IC == null
        ):
        accept_event()
        processOpenTextEdit = true
    elif (event is InputEventMouseButton
    and   event.is_pressed()
    and   IC != null
    and   !IC.is_visible()
        ):
        accept_event()
        processOpenTextEdit = true


func _dupe():
    Lab = Label.new()
    var pro = get_property_list()

    var nam = ""
    var val = ""
    for i in pro:
        nam = i.name
        if nam.to_lower() == "script":  # Attenzione! su Windows la S è maiuscola, ma su Android è minuscola
            break
        elif nam.to_lower() == "owner":
            pass
        elif i.type == 0:
            pass
        else:
            Lab.set(nam,get(nam))

    Lab.set_name(get_name() + duplicate_suffix)
    Lab.connect("draw",self,"_dup_redraw")
    return Lab

func _dup_redraw():
    _resample()
    .set_visible(false)

func get_dupe():
    return Lab

func get_spr_name():
    return get_name() + sprite_suffix

func get_IC_name():
    return get_name() + inputControl_suffix

func get_CT_name():
    return get_name() + control_suffix

func _spr_open(par):
    Spr=Sprite.new()
    Spr.set_name(get_spr_name())
    par.add_child(Spr)
    Spr.set_owner(par)
    Spr.set_position(get_position())
    Spr.set_centered(false)
    pass

func _capture(VP=get_viewport()):
        if !yielding:
            yielding = true
            yield(get_tree(),"idle_frame")
            var tex = VP.get_texture()
            if AllowInput:
                CT.set_texture(tex)
                CT.update()
            elif TargetType == UseType.control:
                CT.set_texture(tex)
                CT.update()
#			elif Spr == null:
#				_spr_open(parent)
#				Spr.set_texture(tex)
#				Spr.update()
            elif Spr != null:
                Spr.set_texture(tex)
                Spr.update()
#			var dbgimg=tex.get_data()
#			dbgimg.save_png("res://FastTextTex.png")
            yielding = false
            processed = true
            return

func _resample():
    yielding 	= false
    processed	= false
    NothingToDo	= false
    set_process(true)
    if VP.get_parent() == null:
        add_child(VP)

func set_size(size,bol=false):
    .set_size(size)
    if FastText:
        VP.set_size(size)
        Lab.set_size(size)
        if Spr:
            Spr.set_size(size)
        elif CT:
            CT.set_size(size)
#		if NothingToDo:
        _resample()

func set_text(iText):
    var Text=iText
    var EmitSignal = false
    if !(Text is String):
        Text=String(iText)
    if (Text != .get_text()
    and !isUpdating
    and AllowSignalTextChanged):
        EmitSignal = true
    .set_text(Text)
    if (FastText
    and Lab != null):
        Lab.set_text(Text)
        if NothingToDo:
            _resample()
    if EmitSignal:
        emit_signal(text_changed_str)

func set_position(pos:Vector2,bol=false):
    .set_position(pos)
    if FastText:
        if Spr:
            Spr.set_position(pos)
        elif CT:
            CT.set_position(pos)

func set_visible(tf):
    if FastText:
        FastEditVisibleFlag = tf
        processSetVisible = true
        if Spr:
            Spr.set_visible (tf)
        elif CT:
            CT.set_visible (tf)

func is_visible():
    var flag=.is_visible()
    if FastText:
        if Spr:
            flag=Spr.is_visible()
        elif CT:
            flag=CT.is_visible()
    return flag


func set_owner(obj):
    .set_owner(obj)
    if FastText:
        if Spr:
            Spr.set_owner(obj)
        elif CT:
            CT.set_owner(obj)


func update():
    isUpdating = true
    .update()
    isUpdating = false

func set_InputBoxParent(nodepath):
    InputBoxParent =_FastTextNodepathToAbsolute(nodepath)

func set_InputBoxCustomRect(rect):
    InputBoxCustomRect = rect

func FastTextSetVisible():
    if	processSetVisible:
        if Spr:
            Spr.set_visible (FastEditVisibleFlag)
        elif CT:
            CT.set_visible (FastEditVisibleFlag)

func _FastText_item_rect_changed():
#	set_size(get_size())
#	set_position(get_position())
#	Lab.set_size(get_size())
#	VP.set_size(get_size())
    pass
func isFastMode():
    return FastText

########################################### FastText Function Area - end
