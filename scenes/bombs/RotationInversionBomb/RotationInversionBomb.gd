extends Bomb
class_name RotationInversionBomb

@export var CollisionShape2D_node: CollisionShape2D
@export var BombTimer_node: BombTimer
@export var WarningTimer_node: WarningTimer

static func create(position_to_set: Vector2, warning_time_to_set: float, bomb_time_to_set: float) -> RotationInversionBomb:
	return RotationInversionBomb_creator.create(position_to_set, warning_time_to_set, bomb_time_to_set)

func _on_warning_timer_warning_timeout():
	modulate.a = 1.0
	CollisionShape2D_node.disabled = false

func slayed():
	PlayingFieldInterface.rotation_inversion()
	super()
	
	SoundManager.play("sfx_RI_bomb","slay")

func exploded():
	SoundManager.play("sfx_RI_bomb","explosion")
	super()

