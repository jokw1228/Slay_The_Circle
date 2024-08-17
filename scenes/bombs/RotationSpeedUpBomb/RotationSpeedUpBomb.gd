extends Bomb
class_name RotationSpeedUpBomb


@export var CollisionShape2D_node: CollisionShape2D
@export var BombTimer_node: BombTimer
@export var WarningTimer_node: WarningTimer

@export var rotation_speed_up_value: float = 0.1

static func create(position_to_set: Vector2, warning_time_to_set: float, bomb_time_to_set: float, rotation_speed_up_value_to_set: float) -> RotationSpeedUpBomb:
	return RotationSpeedUpBomb_creator.create(position_to_set, warning_time_to_set, bomb_time_to_set, rotation_speed_up_value_to_set)

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
