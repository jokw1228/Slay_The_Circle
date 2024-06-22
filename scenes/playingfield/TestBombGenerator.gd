extends Node2D

@export var NormalBomb_scene: PackedScene
@export var RotationSpeedUpBomb_scene: PackedScene
@export var RotationInversionBomb_scene: PackedScene
@export var GameSpeedUpBomb_scene: PackedScene

func _on_timer_timeout():
	var inst = NormalBomb_scene.instantiate()
	var rad = randf_range(0,2*PI)
	var r = randf_range(0, 256)
	inst.position = Vector2(r*cos(rad), r*sin(rad))
	get_tree().current_scene.add_child(inst)
	
	inst = RotationSpeedUpBomb_scene.instantiate()
	rad = randf_range(0,2*PI)
	r = randf_range(0, 256)
	inst.position = Vector2(r*cos(rad), r*sin(rad))
	get_tree().current_scene.add_child(inst)
	
	inst = RotationInversionBomb_scene.instantiate()
	rad = randf_range(0,2*PI)
	r = randf_range(0, 256)
	inst.position = Vector2(r*cos(rad), r*sin(rad))
	get_tree().current_scene.add_child(inst)
	
	inst = GameSpeedUpBomb_scene.instantiate()
	rad = randf_range(0,2*PI)
	r = randf_range(0, 256)
	inst.position = Vector2(r*cos(rad), r*sin(rad))
	get_tree().current_scene.add_child(inst)
