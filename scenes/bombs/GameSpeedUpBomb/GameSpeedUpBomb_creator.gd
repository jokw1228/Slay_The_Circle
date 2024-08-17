extends Node
class_name GameSpeedUpBomb_creator

const GameSpeedUpBomb_scene = "res://scenes/bombs/GameSpeedUpBomb/GameSpeedUpBomb.tscn"

static func create(position_to_set: Vector2, warning_time_to_set: float, bomb_time_to_set: float, game_speed_up_value_to_set: float) -> GameSpeedUpBomb:
	var bomb_inst: GameSpeedUpBomb = preload(GameSpeedUpBomb_scene).instantiate() as GameSpeedUpBomb
	bomb_inst.position = position_to_set
	bomb_inst.BombTimer_node.set_time = bomb_time_to_set
	bomb_inst.WarningTimer_node.set_time = warning_time_to_set
	bomb_inst.game_speed_up_value = game_speed_up_value_to_set
	return bomb_inst
