@tool
class_name MarkdownTheme
extends Resource
## Custom resource to change the theme of Markdown

@export var name: String = "Name"

## Add a [color] tag to inline code
@export var color_inline_code: Color

## Add a [bgcolor] tag to inline code
@export var bgcolor_inline_code: Color

## Add a [color] tag to links
@export var color_link: Color

## Theme of other custom controls
@export var controls_theme: Theme
