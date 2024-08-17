extends Node
class_name RotationSpeedUpBomb_creator

const RotationSpeedUpBomb_scene = "res://scenes/bombs/RotationSpeedUpBomb/RotationSpeedUpBomb.tscn"

static func create(position_to_set: Vector2, warning_time_to_set: float, bomb_time_to_set: float, rotation_speed_up_value_to_set: float) -> RotationSpeedUpBomb:
	var bomb_inst: RotationSpeedUpBomb = load(RotationSpeedUpBomb_scene).instantiate() as RotationSpeedUpBomb
	bomb_inst.position = position_to_set
	bomb_inst.BombTimer_node.set_time = bomb_time_to_set
	bomb_inst.WarningTimer_node.set_time = warning_time_to_set
	bomb_inst.rotation_speed_up_value = rotation_speed_up_value_to_set
	return bomb_inst
