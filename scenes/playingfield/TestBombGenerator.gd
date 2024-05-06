extends Node2D

@export var NormalBomb_scene: PackedScene

func _on_timer_timeout():
	var inst = NormalBomb_scene.instantiate()
	var rad = randf_range(0,2*PI)
	var r = randf_range(0, 256)
	inst.position = Vector2(r*cos(rad), r*sin(rad))
	get_tree().current_scene.add_child(inst)
