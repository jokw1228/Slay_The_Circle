extends Bomb
class_name HazardBomb

const HazardBomb_scene = "res://scenes/bombs/HazardBomb.tscn"

@export var CollisionShape2D_node: CollisionShape2D
@export var BombTimer_node: BombTimer
@export var WarningTimer_node: WarningTimer

static func create(position_to_set: Vector2, warning_time_to_set: float, bomb_time_to_set: float) -> HazardBomb:
	var bomb_inst: HazardBomb = preload(HazardBomb_scene).instantiate() as HazardBomb
	bomb_inst.position = position_to_set
	bomb_inst.BombTimer_node.set_time = bomb_time_to_set
	bomb_inst.WarningTimer_node.set_time = warning_time_to_set
	return bomb_inst

func _on_warning_timer_warning_timeout():
	modulate.a = 1.0
	CollisionShape2D_node.disabled = false

func exploded(): # (override) hazard bomb explosion effect
	var inst: BombExplodedEffect = BombExplodedEffect.create(global_position)
	inst.get_node("BrightModulator").queue_free()
	inst.modulate = Color.RED
	get_tree().current_scene.add_child( inst )

func hazard_bomb_ended_effect():
	get_tree().current_scene.add_child( HazardBombEndedEffect.create(global_position) )

func early_eliminate():
	hazard_bomb_ended_effect()
	queue_free()
