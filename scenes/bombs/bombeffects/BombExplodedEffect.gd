extends Node2D
class_name BombExplodedEffect

@export var BombDeathEffect_scene: PackedScene

@export var sprite: Sprite2D

const end_time = 0.6
const max_scale = 2

var elapsed_time: float = 0.0

func _ready():
	death_effect()
	
	await get_tree().create_timer(end_time).timeout
	queue_free()

func death_effect():
	const death_effect_count = 8
	for i: float in range(death_effect_count):
		var inst: BombDeathEffect = BombDeathEffect_scene.instantiate()
		inst.angle_offset = 2*PI * i / death_effect_count
		add_child(inst)

func _process(delta):
	elapsed_time += delta
	var scale_value: float = max_scale * sin(PI*elapsed_time/end_time)
	sprite.scale = Vector2(scale_value, scale_value)
