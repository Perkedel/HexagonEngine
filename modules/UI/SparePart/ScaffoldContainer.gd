extends Control

@onready var current = $CurrentScaffold
@onready var next = $NextScaffold
@onready var tween = $aTween
@onready var twoon = $bTween
@onready var tweep = $aTwoop
@onready var twoop = $bTwoop

@export var moveBy: float = 5
@export var howLong: float = .5

var anotherScaffold:PackedScene

signal plsGoBack
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func bindScaffold():
	next.get_child(0).connect("plsGoBack", Callable(self, "goBack"))
	pass

func initCurrent():
	current.get_child(0).connect("plsGoBack", Callable(self, "closeMe"))
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	current.show()
	next.hide()
	pass # Replace with function body.

func closeMe():
	if get_parent().get_parent().has_method("goBack"):
		get_parent().get_parent().goBack()
	pass

func goBack():
	tween.interpolate_property(current,"position",Vector2(-moveBy,0),Vector2.ZERO,howLong,Tween.TRANS_LINEAR,Tween.EASE_IN)
	twoon.interpolate_property(next,"position",Vector2.ZERO,Vector2(moveBy,0),howLong,Tween.TRANS_LINEAR,Tween.EASE_IN)
	
	tweep.interpolate_property(current,"modulate",Color(1,1,1,0),Color.WHITE,howLong,Tween.TRANS_LINEAR,Tween.EASE_IN)
	twoop.interpolate_property(next,"modulate",Color.WHITE,Color(1,1,1,0),howLong,Tween.TRANS_LINEAR,Tween.EASE_IN)
	tween.start()
	twoon.start()
	tweep.start()
	twoop.start()
	

	current.show()
	await tween.tween_completed
	next.hide()
	for stuff in next.get_children():
		stuff.free()
	pass

func openScaffold(AnotherScaffoldContainer:PackedScene):
	anotherScaffold = AnotherScaffoldContainer
	tween.interpolate_property(current,"position",Vector2.ZERO,Vector2(-moveBy,0),howLong,Tween.TRANS_LINEAR,Tween.EASE_IN)
	twoon.interpolate_property(next,"position",Vector2(moveBy,0),Vector2.ZERO,howLong,Tween.TRANS_LINEAR,Tween.EASE_IN)
	next.add_child(anotherScaffold)
	
	tweep.interpolate_property(current,"modulate",Color.WHITE,Color(1,1,1,0),howLong,Tween.TRANS_LINEAR,Tween.EASE_IN)
	twoop.interpolate_property(next,"modulate",Color(1,1,1,0),Color.WHITE,howLong,Tween.TRANS_LINEAR,Tween.EASE_IN)
	tween.start()
	twoon.start()
	tweep.start()
	twoop.start()
	next.show()
	await tween.tween_completed
	current.hide()
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
