extends Node

signal miss
signal done
signal step(step)

export(PoolStringArray) var actions
export(int) var threshold = 0 # n == 0: none; n > 0: n seconds

const IGNORE_EVENTS = [
	InputEventMouseButton,
	InputEventMouseMotion,
	InputEventScreenTouch,
	InputEventScreenDrag,
	InputEventJoypadMotion,
]

var timer = Timer.new()
var code_index = 0

func _ready():
	add_child(timer)
	if threshold > 0:
		timer.set_wait_time(threshold)
		timer.connect("timeout", self, 'code_miss')
	if actions == null or actions.size() == 0:
		actions = PoolStringArray([
			'ui_up', 'ui_up', 'ui_down', 'ui_down', # ↑ ↑ ↓ ↓
			'ui_left', 'ui_right', 'ui_left', 'ui_right', # ← → ← →
			'ui_cancel', 'ui_accept' # B=back (XBOX-B); A=accept (XBOX-A)
		])


func _input(event):
	if code_index == 0 and event.is_action_pressed(actions[0]):
		code_step()
	elif code_index > 0:
		if event.is_action_pressed(actions[code_index]):
			if code_index >= actions.size()-1:
				code_done()
			else:
				code_step()
		elif not is_ignored_event(event) and not event.is_action_released(actions[code_index-1]):
			code_miss()

func is_ignored_event(ev):
	for evt in IGNORE_EVENTS:
		if ev is evt:
			return true
	return false

func code_done():
	if OS.is_debug_build(): print('done')
	if threshold > 0:
		timer.stop()
	reset_codes()
	emit_signal("done")

func code_step():
	if OS.is_debug_build(): prints('step', code_index)
	emit_signal("step", code_index)
	code_index += 1
	if threshold > 0:
		timer.start()

func code_miss():
	if OS.is_debug_build(): print('miss')
	if threshold > 0:
		timer.stop()
	emit_signal("miss")
	reset_codes()

func reset_codes():
	code_index = 0
