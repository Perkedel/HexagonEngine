extends Control

export var num_subunits = 1 setget set_num_subunits
export var percent = 0.0 setget set_percent #0-1

export var margin_x = 10

func _ready():
	set_num_subunits(num_subunits)
	$ReferenceTextureProgress.visible = false

func set_percent(val):
	percent = clamp(val,0,1)
	
	if is_inside_tree():
		var val_per_subunit = 1.0 / num_subunits
		var subunit_index = int(percent / val_per_subunit)
		
		for i in range( num_subunits ):
			var tp = $CreatedTextureProgresses.get_children()[i]
			if i == subunit_index:
				var remainder = float(percent) / val_per_subunit - subunit_index
				tp.value = remainder * tp.max_value
			elif i < subunit_index:
				tp.value = tp.max_value
			else: 
				tp.value = tp.min_value

func set_num_subunits(new_num_subunits):
	new_num_subunits = ceil(new_num_subunits)
	
	if is_inside_tree():
		if new_num_subunits != $CreatedTextureProgresses.get_children().size(): #do not redo if nothing has changed
			for child in $CreatedTextureProgresses.get_children():
				$CreatedTextureProgresses.remove_child(child) #queue free does not remove immediately, but for other things to work it needs to be done immediately
				child.queue_free()
			
			for i in range(new_num_subunits):
				var tp = $ReferenceTextureProgress.duplicate()
				$CreatedTextureProgresses.add_child(tp)
				tp.rect_position = Vector2(i * (tp.rect_size.x + margin_x), 0)
				tp.visible = true
	
	num_subunits = new_num_subunits
	set_percent(percent)

func get_width():
	var tp = _last_tp()
	return tp.rect_position.x + tp.rect_size.x

func get_height():
	var tp = _last_tp()
	return tp.rect_position.y + tp.rect_size.y

func _last_tp():
	var num_children = $CreatedTextureProgresses.get_children().size()
	return $CreatedTextureProgresses.get_children()[num_children - 1]