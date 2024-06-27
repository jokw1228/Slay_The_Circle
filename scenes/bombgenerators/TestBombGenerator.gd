extends Node2D

@export var bombs_to_generate: Array[PackedScene]

const CircleFieldRadius = 128

func _on_timer_timeout():
	for i in bombs_to_generate:
		var inst = i.instantiate()
		var rad = randf_range(0,2*PI)
		var r = randf_range(0, CircleFieldRadius * 2)
		inst.position = Vector2(r*cos(rad), r*sin(rad))
		get_tree().current_scene.add_child(inst)
