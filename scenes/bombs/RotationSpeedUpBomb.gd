extends Bomb
class_name RotationSpeedUpBomb

const RotationSpeedUpBomb_scene = "res://scenes/bombs/RotationSpeedUpBomb.tscn"

@export var CollisionShape2D_node: CollisionShape2D
@export var BombTimer_node: BombTimer
@export var WarningTimer_node: WarningTimer

@export var rotation_speed_up_value: float = 0.1

static func create(position_to_set: Vector2, warning_time_to_set: float, bomb_time_to_set: float, rotation_speed_up_value_to_set: float) -> RotationSpeedUpBomb:
	var bomb_inst: RotationSpeedUpBomb = load(RotationSpeedUpBomb_scene).instantiate() as RotationSpeedUpBomb
	bomb_inst.position = position_to_set
	bomb_inst.BombTimer_node.set_time = bomb_time_to_set
	bomb_inst.WarningTimer_node.set_time = warning_time_to_set
	bomb_inst.rotation_speed_up_value = rotation_speed_up_value_to_set
	return bomb_inst

func _on_warning_timer_warning_timeout():
	modulate.a = 1.0
	CollisionShape2D_node.disabled = false

func slayed():
	PlayingFieldInterface.rotation_speed_up(rotation_speed_up_value)
	super()
	
	SoundManager.play("sfx_RSU_bomb","slay")

func exploded():
	SoundManager.play("sfx_RSU_bomb","explosion")
	super()
