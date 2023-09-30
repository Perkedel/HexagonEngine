extends HBoxContainer

@export var CoineCountNumber:float
@export var CoineIcon:Texture2D
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func setPon(to:float):
	CoineCountNumber = to
	_refresh()

func setPonIcon(to:Texture):
	print_rich('[b]SET SCORE ICON[/b]')
	CoineIcon = to
	_refresh()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _refresh():
	$CoineCountLabel.text = String.num(CoineCountNumber,3)
	$CoineIcon.texture = CoineIcon
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	pass
