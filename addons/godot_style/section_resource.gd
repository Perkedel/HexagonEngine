@tool
class_name SectionResource
extends Resource
## Custom class to create new Sections for [code]Main[/code].[br]

## Will be used as a title in [code]Section/Name[/code]
@export var name: String = "Name"

## Items of type ItemResource to be displayed
@export var items: Array[ItemResource]
