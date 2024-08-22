extends Bomb
class_name HazardBomb

@export var CollisionShape2D_node: CollisionShape2D
@export var BombTimer_node: BombTimer
@export var WarningTimer_node: WarningTimer

var is_time_zero: bool = false

static func create(position_to_set: Vector2, warning_time_to_set: float, bomb_time_to_set: float) -> HazardBomb:
	return HazardBomb_creator.create(position_to_set, warning_time_to_set, bomb_time_to_set)

func _on_warning_timer_warning_timeout():
	if !is_time_zero:
		modulate.a = 1.0
		CollisionShape2D_node.disabled = false

func exploded(): # (override) hazard bomb explosion effect
	var inst: BombExplodedEffect = BombExplodedEffect.create(global_position)
	inst.get_node("BrightModulator").queue_free()
	inst.modulate = Color.RED
	get_tree().current_scene.add_child( inst )
	
	SoundManager.play("sfx_H_bomb","explosion")

func hazard_bomb_ended_effect():
	get_tree().current_scene.add_child( HazardBombEndedEffect.create(global_position) )

func early_eliminate():
	hazard_bomb_ended_effect()
	queue_free()
