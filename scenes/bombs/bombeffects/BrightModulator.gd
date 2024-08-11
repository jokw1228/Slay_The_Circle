extends Node
class_name BrightModulator

var parent: CanvasItem

func _ready():
	parent = get_parent() as CanvasItem
	

func _process(_delta):
	var bright: float = PlayingFieldInterface.get_theme_bright()
	parent.modulate = Color(1-bright, 1-bright, 1-bright, parent.modulate.a)
