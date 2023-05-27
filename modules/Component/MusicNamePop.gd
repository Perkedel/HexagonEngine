extends Popup

class_name MusicNamePop

@export var albumPic: Texture2D:Texture2D = load("res://Sprites/MavrickleIcon.png")
@export var title: String = "Title"
@export var artist: String = "Artist"
@export var license: String = "CC4.0-BY-SA"
@export var source: String = "https://cointr.ee/joelwindows7"
@export var howLong: float = .5
@export var hideAfterIn: float = 5

@onready var tween = $Tween
@onready var AlbumPic = $HBoxContainer/AlbumPicture
@onready var Title = $HBoxContainer/TextLabels/Title
@onready var Artist = $HBoxContainer/TextLabels/Artist
@onready var License = $HBoxContainer/TextLabels/License
@onready var Source = $HBoxContainer/TextLabels/Source
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func processTheName(theTitle:String="Untitled",theArtist:String="Unknown",theLicense="??? license",theSource:String="??? sourced",theImage:Texture2D=preload("res://Sprites/MavrickleIcon.png")):
	title = theTitle
	artist = theArtist
	license = theLicense
	source = theSource
	albumPic = theImage
	
	# https://godotengine.org/qa/23713/how-to-convert-image-to-texture
	# https://docs.godotengine.org/en/stable/classes/class_imagetexture.html#class-imagetexture-method-create-from-image
	# 
	var itex = ImageTexture.new()
	var img = Image.new()
	img.load(albumPic.get_path())
	itex.create_from_image(img)
	
	AlbumPic.texture = albumPic
	Title.text = title
	Artist.text = artist
	License.text = license
	Source.text = source
	pass

func popTheName(forHowLong:float = 5.0,NoAnimation:bool = false):
	hideAfterIn = forHowLong
	show()
	if not NoAnimation:
		tween.interpolate_property(self,"position",Vector2(-size.x,position.y),Vector2(0,position.y),howLong,Tween.TRANS_LINEAR,Tween.EASE_IN )
		tween.start()
		await tween.tween_completed
	await get_tree().create_timer(hideAfterIn).timeout
	if not NoAnimation:
		tween.interpolate_property(self,"position",Vector2(0,position.y),Vector2(-size.x,position.y),howLong,Tween.TRANS_LINEAR,Tween.EASE_IN )
		tween.start()
		await tween.tween_completed
	hide()
	pass

func receiveDictionaryOfMusicName(thisOne:Dictionary):
	processTheName(thisOne["title"],thisOne["artist"],thisOne["license"],thisOne["source"],thisOne["albumPic"])
	pass

func forceHide():
	tween.stop_all()
	hide()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#AlbumPic.texture
#	Title.text = title
#	Artist.text = artist
#	License.text = license
#	Source.text = source
	pass
