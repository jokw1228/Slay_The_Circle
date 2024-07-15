extends Node2D

@export var bombs_to_generate: Array[PackedScene]

@export var NormalBomb_scene: PackedScene
@export var HazardBomb_scene: PackedScene
# @export var NumberBomb_scene: PackedScene
@export var RotationInversionBomb_scene: PackedScene
@export var RotationSpeedUpBomb_scene: PackedScene
@export var GameSpeedUpBomb_scene: PackedScene

# const CircleFieldRadius = 128

func _on_timer_timeout():
# test bomb generation code
	create_gamespeedup_bomb(Vector2(0, 0), 3, 0.1)
	create_rotationspeedup_bomb(Vector2(100, 100), 3, 1)
	create_hazard_bomb(Vector2(100, -100), 0.5)
	create_rotationinversion_bomb(Vector2(-100, -100), 3)
	create_normal_bomb(Vector2(-100, 100), 3)


func create_hazard_bomb(bomb_position: Vector2, bomb_time: float):
	var inst = HazardBomb_scene.instantiate()
	inst.position = bomb_position
	var timer = inst.get_node("BombTimer")
	timer.set_time = bomb_time
	
	get_tree().current_scene.add_child(inst)
#	print("DEBUG: hazard_bomb generated, time:", bomb_time)


func create_normal_bomb(bomb_position: Vector2 = Vector2.ZERO, bomb_time: float = 0):
	var inst = NormalBomb_scene.instantiate()
	inst.position = bomb_position
	var timer = inst.get_node("BombTimer")
	timer.set_time = bomb_time
	
	get_tree().current_scene.add_child(inst)
#	print("DEBUG: normal_bomb generated, time:", bomb_time)
	
	
func create_rotationinversion_bomb(bomb_position: Vector2 = Vector2.ZERO, bomb_time: float = 0):
	var inst = RotationInversionBomb_scene.instantiate()
	inst.position = bomb_position
	var timer = inst.get_node("BombTimer")
	timer.set_time = bomb_time
	
	get_tree().current_scene.add_child(inst)
#	print("DEBUG: rotation_inversion_bomb generated, time:", bomb_time)
	
	
func create_rotationspeedup_bomb(bomb_position: Vector2 = Vector2.ZERO, bomb_time: float = 0, speed_up_value: float = 0):
	var inst = RotationSpeedUpBomb_scene.instantiate()
	inst.position = bomb_position
	var timer = inst.get_node("BombTimer")
	timer.set_time = bomb_time
	inst.rotation_speed_up_value = speed_up_value
	
	get_tree().current_scene.add_child(inst)
#	print("DEBUG: rotation_speedup_bomb generated, time:", bomb_time)
	
	
func create_gamespeedup_bomb(bomb_position: Vector2 = Vector2.ZERO, bomb_time: float = 0, speed_up_value: float = 0):
	var inst = GameSpeedUpBomb_scene.instantiate()
	inst.position = bomb_position
	var timer = inst.get_node("BombTimer")
	timer.set_time = bomb_time
	inst.game_speed_up_value = speed_up_value
	
	get_tree().current_scene.add_child(inst)
#	print("DEBUG: game_speedup_bomb generated, time:", bomb_time)
