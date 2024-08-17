extends Node
class_name NormalBomb_creator

const NormalBomb_scene = "res://scenes/bombs/NormalBomb/NormalBomb.tscn"

static func create(position_to_set: Vector2, warning_time_to_set: float, bomb_time_to_set: float) -> NormalBomb:
	var bomb_inst: NormalBomb = preload(NormalBomb_scene).instantiate() as NormalBomb
	bomb_inst.position = position_to_set
	bomb_inst.BombTimer_node.set_time = bomb_time_to_set
	bomb_inst.WarningTimer_node.set_time = warning_time_to_set
	return bomb_inst
