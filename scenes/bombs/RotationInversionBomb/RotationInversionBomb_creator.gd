extends Node
class_name RotationInversionBomb_creator

const RotationInversionBomb_scene = "res://scenes/bombs/RotationInversionBomb/RotationInversionBomb.tscn"

static func create(position_to_set: Vector2, warning_time_to_set: float, bomb_time_to_set: float) -> RotationInversionBomb:
	var bomb_inst: RotationInversionBomb = preload(RotationInversionBomb_scene).instantiate() as RotationInversionBomb
	bomb_inst.position = position_to_set
	bomb_inst.BombTimer_node.set_time = bomb_time_to_set
	bomb_inst.WarningTimer_node.set_time = warning_time_to_set
	return bomb_inst
