extends Node2D
class_name BombGenerator

#var bomb_link :PackedScene = preload("res://scenes/bombs/BombLink.tscn")

func create_normal_bomb(bomb_position: Vector2, warning_time: float, bomb_time: float) -> NormalBomb:
	var bomb_inst: NormalBomb = NormalBomb.create(bomb_position, warning_time, bomb_time)
	call_deferred("add_child", bomb_inst)
	return bomb_inst

func create_hazard_bomb(bomb_position: Vector2, warning_time: float, bomb_time: float) -> HazardBomb:
	var bomb_inst: HazardBomb = HazardBomb.create(bomb_position, warning_time, bomb_time)
	call_deferred("add_child", bomb_inst)
	return bomb_inst

func create_numeric_bomb(bomb_position: Vector2, warning_time: float, bomb_time: float, bomb_id: int) -> NumericBomb:
	var bomb_inst: NumericBomb = NumericBomb.create(bomb_position, warning_time, bomb_time, bomb_id)
	call_deferred("add_child", bomb_inst)
	return bomb_inst

func create_rotationinversion_bomb(bomb_position: Vector2, warning_time: float, bomb_time: float) -> RotationInversionBomb:
	var bomb_inst: RotationInversionBomb = RotationInversionBomb.create(bomb_position, warning_time, bomb_time)
	call_deferred("add_child", bomb_inst)
	return bomb_inst

func create_rotationspeedup_bomb(bomb_position: Vector2, warning_time: float, bomb_time: float, speed_up_value: float) -> RotationSpeedUpBomb:
	var bomb_inst: RotationSpeedUpBomb = RotationSpeedUpBomb.create(bomb_position, warning_time, bomb_time, speed_up_value)
	call_deferred("add_child", bomb_inst)
	return bomb_inst

func create_gamespeedup_bomb(bomb_position: Vector2, warning_time: float, bomb_time: float, speed_up_value: float) -> GameSpeedUpBomb:
	var bomb_inst: GameSpeedUpBomb = GameSpeedUpBomb.create(bomb_position, warning_time, bomb_time, speed_up_value)
	call_deferred("add_child", bomb_inst)
	return bomb_inst

func create_bomb_link(bomb1: Bomb, bomb2: Bomb) -> BombLink:
	var link: BombLink = BombLink.create(bomb1, bomb2)
	self.call_deferred("add_child", link)
	return link
