@tool
class_name ItemResource
extends Resource
## Custom class to create new Items for Sections.[br]
## [br]
## I have no idea how to implement markdown in Godot yet,
## so I'll just use pictures for now lmao.

## Will be used to navigate in the Tree
@export var name: String = "Name"

## Will be used in [code]Main/ItemContent/ItemName[/code].
## Leave blank if not needed.
@export var content_title: String = ""

## Markdown file to be displayed.
@export_file("*.md") var content_path: String
