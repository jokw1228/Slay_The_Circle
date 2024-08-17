extends Node
class_name Indicator_creator

const Indicator_scene = "res://scenes/bombs/bombeffects/Indicator/Indicator.tscn"

static func create(position_to_set: Vector2 = Vector2.ZERO, size_to_set: float = 32) -> Indicator:
	var inst: Indicator = preload(Indicator_scene).instantiate() as Indicator
	inst.position = position_to_set
	inst.size = size_to_set
	return inst
