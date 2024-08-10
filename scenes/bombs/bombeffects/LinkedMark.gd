extends Sprite2D
class_name LinkedMark

const LinkedMark_scene = "res://scenes/bombs/bombeffects/LinkedMark.tscn"

static func create() -> LinkedMark:
	var inst: LinkedMark = preload(LinkedMark_scene).instantiate() as LinkedMark
	return inst

func _process(delta):
	rotate(delta * PI / 6)
