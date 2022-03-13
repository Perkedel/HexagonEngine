extends Node


const Task := preload("res://addons/task_dispatcher/task.gd")
const Queue := preload("res://addons/task_dispatcher/queue.gd")


enum In { OBJECT, METHOD, ARGS, TASK }
enum Out { TASK, RESULT }


const MAX_BLOCKING_TIME = 10


var _in: Queue
var _out: Queue
var _done: Queue
var _thread: Thread
var _semaphore: Semaphore
var _in_mutex: Mutex
var _out_mutex: Mutex
var _running_mutex: Mutex
var _running: bool


func _init() -> void:
    _in = Queue.new()
    _out = Queue.new()
    _done = Queue.new()
    _thread = Thread.new()
    _semaphore = Semaphore.new()
    _in_mutex = Mutex.new()
    _out_mutex = Mutex.new()
    _running_mutex = Mutex.new()

    _running = true
    _thread.start(self, "_thread_loop")

func dispose() -> void:
    _running = false
    _semaphore.post()
    _thread.wait_to_finish()

func run(object: Object, method: String, args: Array = []) -> Task:
    var task = Task.new()
    _in.push([object, method, args, task])
    _semaphore.post()
    return task

func _process(_delta: float) -> void:
    var start := OS.get_ticks_msec()
    _out_mutex.lock()
    while not _out.is_empty():
        if OS.get_ticks_msec() - start >= MAX_BLOCKING_TIME: break
        _done.push(_out.pop())
    _out_mutex.unlock()

    while not _done.is_empty():
        if OS.get_ticks_msec() - start >= MAX_BLOCKING_TIME: break
        var data = _done.pop()
        data[Out.TASK].finish(data[Out.RESULT])

func _try_pop() -> Array:
    var data = null
    _in_mutex.lock()
    if not _in.is_empty():
        data = _in.pop()
    _in_mutex.unlock()
    return data

func _thread_loop() -> void:
    while _running:
        var data = _try_pop()
        if data == null: _semaphore.wait()
        else: _handle_task(data[In.OBJECT], data[In.METHOD], data[In.ARGS], data[In.TASK])

func _handle_task(object: Object, method: String, args: Array, task: Task) -> void:
    var return_value = object.callv(method, args)
    _out_mutex.lock()
    _out.push([task, return_value])
    _out_mutex.unlock()
