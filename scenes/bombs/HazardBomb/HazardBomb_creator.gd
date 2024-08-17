extends Node
class_name HazardBomb_creator

const HazardBomb_scene = "res://scenes/bombs/HazardBomb/HazardBomb.tscn"

static func create(position_to_set: Vector2, warning_time_to_set: float, bomb_time_to_set: float) -> HazardBomb:
	var bomb_inst: HazardBomb = preload(HazardBomb_scene).instantiate() as HazardBomb
	bomb_inst.position = position_to_set
	bomb_inst.BombTimer_node.set_time = bomb_time_to_set
	bomb_inst.WarningTimer_node.set_time = warning_time_to_set
	return bomb_inst
