extends Node
class_name Darksight_creator

const Darksight_scene = "res://scenes/bombs/bombeffects/Darksight/Darksight.tscn"

static func create() -> Darksight:
	var inst: Darksight = preload(Darksight_scene).instantiate() as Darksight
	return inst
