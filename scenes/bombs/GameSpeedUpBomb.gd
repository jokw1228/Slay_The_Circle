extends Bomb
class_name GameSpeedUpBomb

const GameSpeedUpBomb_scene = "res://scenes/bombs/GameSpeedUpBomb.tscn"

@export var CollisionShape2D_node: CollisionShape2D
@export var BombTimer_node: BombTimer
@export var WarningTimer_node: WarningTimer

var game_speed_up_value: float = 0.1

static func create(position_to_set: Vector2, warning_time_to_set: float, bomb_time_to_set: float, game_speed_up_value_to_set: float) -> GameSpeedUpBomb:
	var bomb_inst: GameSpeedUpBomb = preload(GameSpeedUpBomb_scene).instantiate() as GameSpeedUpBomb
	bomb_inst.position = position_to_set
	bomb_inst.BombTimer_node.set_time = bomb_time_to_set
	bomb_inst.WarningTimer_node.set_time = warning_time_to_set
	bomb_inst.game_speed_up_value = game_speed_up_value_to_set
	return bomb_inst

func _on_warning_timer_warning_timeout():
	modulate.a = 1.0
	CollisionShape2D_node.disabled = false

func slayed():
	PlayingFieldInterface.game_speed_up(game_speed_up_value)
	super()
	
	SoundManager.play("sfx_SU_bomb","slay")
