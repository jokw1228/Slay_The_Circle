extends Node2D

@export var bombs_to_generate: PackedScene
@export var bomb_link: PackedScene

const CircleFieldRadius = 128

func _on_timer_timeout():
	var bomb1 = bombs_to_generate.instantiate()
	var rad = randf_range(0,2*PI)
	var r = randf_range(0, CircleFieldRadius * 2)
	bomb1.position = Vector2(r*cos(rad), r*sin(rad))
	
	var bomb2 = bombs_to_generate.instantiate()
	rad = randf_range(0,2*PI)
	r = randf_range(0, CircleFieldRadius * 2)
	bomb2.position = Vector2(r*cos(rad), r*sin(rad))
	
	var link = bomb_link.instantiate()
	link.set_child_bombs(bomb1, bomb2)
	get_tree().current_scene.add_child(link)
