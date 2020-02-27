tool
extends Node

#const TaskGraphData = preload("res://addons/task_graph/task_graph_data.gd")
const TaskGraphData = preload("task_graph_data.gd")
const ThreadPool = preload("thread_utils/thread_pool.gd")

#signal task_finished(task)
signal output_ready(output_name, output)
signal finished()

export(int, 1000) var max_threads = 0 # 0x7FFFFFFF <- Max integer
#var resource setget set_resource # Only for 3.1
export(Resource) var resource setget set_resource


var _inputs = {}
var _outputs = {}
var _outputs_left

var thread_pool

var nodes

func start():
	if resource == null:
		printerr("No resource available! Could not start.")
		return
	
	_outputs_left = _outputs.size()
	
	nodes = []
	for node in resource.nodes:
		if node["type"] == TaskGraphData.TASK_NODE:
			nodes.append(Task.new(self, load(node["data"]).new()))
		elif node["type"] == TaskGraphData.INPUT_NODE:
			nodes.append(InputTask.new(self))
		elif node["type"] == TaskGraphData.OUTPUT_NODE:
			nodes.append(OutputTask.new(self))
	
	for connection in resource.connections:
		var from = nodes[connection["from"]]
		var to = nodes[connection["to"]]
		from.outputs.append([connection["from_port"], to, connection["to_port"]])
		to.inputs_needed += 1
	
	var start_nodes = []
	for node in nodes:
		if not "inputs_needed" in node or node.inputs_needed == 0:
			start_nodes.append(node)
	
	thread_pool = ThreadPool.new(min(nodes.size(), max_threads if max_threads != 0 else OS.get_processor_count() * 2))
	
	for node in start_nodes:
		thread_pool.add_task(node, "_run")

func set_resource(p_resource):
	resource = p_resource
	
	_inputs.clear()
	_outputs.clear()
	
	if resource == null: return
	
	for node in resource.nodes:
		if node["type"] == TaskGraphData.TASK_NODE:
			pass
		elif node["type"] == TaskGraphData.INPUT_NODE:
			_inputs[node["data"]] = null
		elif node["type"] == TaskGraphData.OUTPUT_NODE:
			_outputs[node["data"]] = null
		else:
			printerr("Unknown type")

func set_input(key, value):
	if not _inputs.has(key):
		printerr("Input not found.")
		return
	_inputs[key] = value

func get_output(key):
	return _outputs[key]

func get_progress():
	var progress = 0.0
	var total_progress = 0.0
	for node in nodes:
		var node_total = node.get_total_progress()
		total_progress += node_total
		if node.status == STATUS_RUNNING:
			progress += node.get_progress()
		elif node.status == STATUS_FINISHED:
			progress += node_total
	return progress / total_progress






enum TaskStatus{
	STATUS_WAITING
	STATUS_RUNNING
	STATUS_FINISHED
}

class Task extends Reference:
	var status = STATUS_WAITING
	
	var inputs_needed = 0
	var outputs = []
	
	var outer
	var task
	var mutex = Mutex.new()
	
	func _init(p_outer, p_task):
		outer = p_outer
		task = p_task
	
	func add_input(input_name, value):
		task.set(input_name, value)
		mutex.lock()
		inputs_needed -= 1
		if inputs_needed == 0:
			outer.thread_pool.add_task(self, "_run")
		mutex.unlock()
	
	func _run():
		status = STATUS_RUNNING
		task._run()
		status = STATUS_FINISHED
		for output in outputs:
			output[1].add_input(output[2], task.get(output[0]))
	
	func get_progress():
		return task.progress if "progress" in task else 0
	
	func get_total_progress():
		return task.total_progress if "total_progress" in task else 1

class InputTask extends Reference:
	var status = STATUS_WAITING
	
	var outputs = []
	
	var outer
	
	func _init(p_outer):
		outer = p_outer
	
	func _run():
		status = STATUS_RUNNING
		for output in outputs:
			output[1].add_input(output[2], outer._inputs[output[0]])
		status = STATUS_FINISHED
	
	func get_progress():
		return 1 if status == STATUS_FINISHED else 0
	
	func get_total_progress():
		return 1

class OutputTask extends Reference:
	var status = STATUS_WAITING
	
	var inputs_needed = 0
	
	var outer
	
	func _init(p_outer):
		outer = p_outer
	
	func add_input(input_name, value):
		status = STATUS_RUNNING
		outer.call_deferred("_set_output", input_name, value)
		status = STATUS_FINISHED
	
	func get_progress():
		return 1 if status == STATUS_FINISHED else 0
	
	func get_total_progress():
		return 1

func _set_output(output_name, value):
	_outputs[output_name] = value
	_outputs_left -= 1
	emit_signal("output_ready", output_name, value)
	if _outputs_left == 0:
		thread_pool.quit()
		emit_signal("finished")







# Editor functions
# Only in 3.1
#func _get_property_list():
#	var properties = [
#		{
#			"name": "resource",
#			"type": TYPE_OBJECT,
#			"hint": PROPERTY_HINT_RESOURCE_TYPE,
#			"hint_string": "TaskGraphData",
#			"usage": PROPERTY_USAGE_DEFAULT
#		}
#	]
#	return properties
#
#func _get(key):
#	if key == "resource":
#		return resource
#
#func _set(key, value):
#	if key == "resource":
#		set_resource(value)
#	else:
#		return false
#	return true


