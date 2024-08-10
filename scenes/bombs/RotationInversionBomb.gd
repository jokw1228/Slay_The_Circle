extends Bomb
class_name RotationInversionBomb

const RotationInversionBomb_scene = "res://scenes/bombs/RotationInversionBomb.tscn"

@export var CollisionShape2D_node: CollisionShape2D
@export var BombTimer_node: BombTimer
@export var WarningTimer_node: WarningTimer

static func create(position_to_set: Vector2, warning_time_to_set: float, bomb_time_to_set: float) -> RotationInversionBomb:
	var bomb_inst: RotationInversionBomb = preload(RotationInversionBomb_scene).instantiate() as RotationInversionBomb
	bomb_inst.position = position_to_set
	bomb_inst.BombTimer_node.set_time = bomb_time_to_set
	bomb_inst.WarningTimer_node.set_time = warning_time_to_set
	return bomb_inst

func _on_warning_timer_warning_timeout():
	modulate.a = 1.0
	CollisionShape2D_node.disabled = false

func slayed():
	PlayingFieldInterface.rotation_inversion()
	super()
	
	SoundManager.play("sfx_RI_bomb","slay")
