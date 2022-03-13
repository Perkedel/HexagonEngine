extends Reference


signal finished(result)


enum State { PENDING, FINISHED }


var _state: int = State.PENDING
var _result = null


func finish(value) -> void:
    _result = value
    _state = State.FINISHED
    emit_signal("finished", value)

func get_state() -> int: return _state

func get_result(): return _result
