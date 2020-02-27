tool
extends AnimationPlayer

export (String) var undesired_path
export (String) var desired_path
export (bool) var fix_it = false setget set_fix_it

func set_fix_it(value):
	if !value:
		return
	undesired_path = undesired_path.to_lower()
	for a in get_animation_list():
		var anim = get_animation(a)
		for t in anim.get_track_count():
			var p = str(anim.track_get_path(t))
			p = p.to_lower()
			p = p.replace(undesired_path, desired_path)
			anim.track_set_path(t, p)
		ResourceSaver.save(anim.get_path(), anim)