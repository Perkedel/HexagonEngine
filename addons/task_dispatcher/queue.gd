extends Reference


signal added(value)
signal removed(value)


const VALUE = 0
const NEXT = 1
const EMPTY = [null, null]


var _first: Array = [null, null]
var _last: Array = _first
var _size: int = 0


func size(): return _size

func is_empty(): return _size == 0

func enqueue(object): push(object)

func dequeue(): return pop()

func push(object):
    var node = [object, null]
    if _size == 0: _first = node
    else: _last[NEXT] = node
    _last = node
    _size += 1
    emit_signal("added", object)

func pop():
    var value = _first[VALUE]
    if _size == 1: _first = EMPTY
    else: _first = _first[NEXT]
    _size -= 1
    emit_signal("removed", value)
    return value
