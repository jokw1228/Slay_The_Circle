extends Node
class_name NumericBomb_creator

const NumericBomb_scene = "res://scenes/bombs/NumericBomb/NumericBomb.tscn"

static func create(position_to_set: Vector2, warning_time_to_set: float, bomb_time_to_set: float, id_to_set: int) -> NumericBomb:
	var bomb_inst: NumericBomb = preload(NumericBomb_scene).instantiate() as NumericBomb
	bomb_inst.position = position_to_set
	bomb_inst.BombTimer_node.set_time = bomb_time_to_set
	bomb_inst.WarningTimer_node.set_time = warning_time_to_set
	bomb_inst.id = id_to_set
	return bomb_inst
