extends Bomb
class_name NormalBomb

@export var CollisionShape2D_node: CollisionShape2D
@export var BombTimer_node: BombTimer
@export var WarningTimer_node: WarningTimer

static func create(position_to_set: Vector2, warning_time_to_set: float, bomb_time_to_set: float) -> NormalBomb:
	return NormalBomb_creator.create(position_to_set, warning_time_to_set, bomb_time_to_set)

func _on_warning_timer_warning_timeout():
	modulate.a = 1.0
	CollisionShape2D_node.disabled = false

func slayed():
	super()
	
	SoundManager.play("sfx_Nor_bomb","slay")

func exploded():
	SoundManager.play("sfx_Nor_bomb","explosion")
	super()
