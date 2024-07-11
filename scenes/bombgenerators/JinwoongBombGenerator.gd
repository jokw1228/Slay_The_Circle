extends Node2D

@export var bombs_to_generate: PackedScene
@export var bomb_link: PackedScene

const CircleFieldRadius = 128
var rad = PI / -8.0
var r = CircleFieldRadius / 2.0

func _on_timer_timeout():
	rad += PI / 8.0
	r += CircleFieldRadius * 0.2
	
	var bomb1 = bombs_to_generate.instantiate()
	bomb1.position = Vector2(-r*cos(rad), -r*sin(rad))
	
	var bomb2 = bombs_to_generate.instantiate()
	bomb2.position = Vector2(r*cos(rad), r*sin(rad))
	
	var link = bomb_link.instantiate()
	link.set_child_bombs(bomb1, bomb2)
	get_tree().current_scene.add_child(link)
	
