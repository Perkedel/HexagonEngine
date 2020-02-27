extends Node

export(bool) var started = false
export(bool) var paused = false
# This is the max time the stopwatch can support in [seconds].[milliseconds] format.
export(float) var max_time = 86399.999

signal started
signal paused
signal resumed
signal stopped
signal reset
signal ticked

# The current elapsed time.
var _elapsed_time = float(0)

func _ready():
	# Reset the stopwatch but don't emit the reset signal.
	reset(false)

# Resets and starts the stopwatch.
func start():
	# Reset the stopwatch then start it.
	reset()
	started = true
	emit_signal("started")

# Pauses the stopwatch.
func pause():
	paused = true
	emit_signal("paused")

# Resumes the stopwatch from a paused state.
func resume():
	paused = false
	emit_signal("resumed")

# Stops the stopwatch.
func stop():
	started = false
	paused = false
	emit_signal("stopped")

# Resets the stopwatch.
# Parameters:
#	notify: Whether to emit the reset signal when resetting.
func reset(notify = true):
	_elapsed_time = float(0)
	started = false
	paused = false
	
	if notify:
		emit_signal("reset")

# Gets the current elapsed time as a decimal. The format is [total_seconds].[current_milliseconds].
func get_elapsed_time():
	return _elapsed_time

# Gets the current elapsed time as a formatted string. The default format is HH:mm:ss:SSS.
# Parameters:
#	f_hours: The format to use to represent hours. This can be a String or null.
#	f_minutes: The format to use to represent minutes. This can be a String or null.
#	f_seconds: The format to use to represent seconds. This can be a String or null.
#	f_millis: The format to use to represent milliseconds. This can be a String or null.
#	millis_precision: The number of digits to return for milliseconds.
func get_formatted_elapsed_time(f_hours = "%02d:", f_minutes = "%02d:", f_seconds = "%02d:", f_millis = "%03d", millis_precision = 3):
	# Get the current elapsed time.
	var time = get_elapsed_time()
	
	# Break the elapsed time into seconds and milliseconds.
	var part_seconds = 0
	var part_milliseconds = 0
	var time_split = str(time).split(".")
	if time_split.size() == 2:
		part_seconds = int(time_split[0])
		part_milliseconds = int(time_split[1].substr(0, millis_precision))
	
	# Break the total seconds into their respective time parts.
	var hours = floor(part_seconds / 3600)
	var minutes = fmod(floor(part_seconds / 60), 60)
	var seconds = fmod(part_seconds, 60)
	var millis = part_milliseconds
	
	# Prepare output formatting.
	var format_string = ""
	var format_values = Array()
	if f_hours != null and f_hours != "":
		format_string += f_hours
		format_values.append(hours)
	if f_minutes != null and f_minutes != "":
		format_string += f_minutes
		format_values.append(minutes)
	if f_seconds != null and f_seconds != "":
		format_string += f_seconds
		format_values.append(seconds)
	if f_millis != null and f_millis != "":
		format_string += f_millis
		format_values.append(millis) 
	
	# Return the formatted output.
	return format_string % format_values

func _physics_process(delta):
	# Tick the stopwatch when it is running and not paused.
	if started and not paused:
		# Prevent the time from rolling over by limiting it to the defined max time.
		_elapsed_time = clamp(_elapsed_time + delta, 0, max_time)
		emit_signal("ticked")