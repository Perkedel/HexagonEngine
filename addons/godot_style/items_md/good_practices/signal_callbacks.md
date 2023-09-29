- Godot's convention: `_on_SignalEmittingNode_signal_name`
```gdscript
func _on_Transition_started(which: Animation) -> void:
	return
```

- Remove `SignalEmittingNode` if the object connects to itself
```gdscript
class_name HitBox
extends Area2D

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	return
```
