extends Node2D
class_name BombGenerator

@export var NormalBomb_scene: PackedScene
@export var HazardBomb_scene: PackedScene
@export var NumericBomb_scene: PackedScene
@export var RotationInversionBomb_scene: PackedScene
@export var RotationSpeedUpBomb_scene: PackedScene
@export var GameSpeedUpBomb_scene: PackedScene

@export var Normalbomb_warning_scene: PackedScene
@export var HazardBomb_warning_scene: PackedScene
@export var NumericBomb_warning_scene: PackedScene
@export var RotationInversionBomb_warning_scene: PackedScene
@export var RotationSpeedUpBomb_warning_scene: PackedScene
@export var GameSpeedUpBomb_warning_scene: PackedScene

@export var bomb_link: PackedScene


func _ready():
	#print("BombGenerator Loaded")
	pass
	
	
func add_bomb(bomb_instance: Bomb, waiting_time: float):
	await get_tree().create_timer(waiting_time).timeout
	get_tree().current_scene.add_child(bomb_instance)


func create_normal_bomb(bomb_position: Vector2, warning_time: float, bomb_time: float):
	var inst = NormalBomb_scene.instantiate()
	var inst2 = Normalbomb_warning_scene.instantiate()
	inst.position = bomb_position
	inst2.position = bomb_position
	inst2.warningtime = warning_time
	var timer = inst.get_node("BombTimer")
	timer.set_time = bomb_time
	
	get_tree().current_scene.add_child(inst2)
	Utils.attach_node(inst, inst2)
	add_bomb(inst, warning_time)
	return inst


func create_hazard_bomb(bomb_position: Vector2, warning_time: float, bomb_time: float):
	var inst = HazardBomb_scene.instantiate()
	var inst2 = HazardBomb_warning_scene.instantiate()
	inst.position = bomb_position
	inst2.position = bomb_position
	inst2.warningtime = warning_time
	var timer = inst.get_node("BombTimer")
	timer.set_time = bomb_time
	
	get_tree().current_scene.add_child(inst2)
	Utils.attach_node(inst, inst2)
	add_bomb(inst, warning_time)
	return inst
	# 이건 link가 필요 없지 않나요? ㅋㅋㅋ 
	
	
func create_numeric_bomb(bomb_position: Vector2, warning_time: float, bomb_time: float, bomb_id: int):
	var inst = NumericBomb_scene.instantiate()
	var inst2 = NumericBomb_warning_scene.instantiate()
	inst.position = bomb_position
	inst2.position = bomb_position
	inst2.warningtime = warning_time
	var timer = inst.get_node("BombTimer")
	timer.set_time = bomb_time
	inst.id = bomb_id
	
	get_tree().current_scene.add_child(inst2)
	Utils.attach_node(inst, inst2)
	add_bomb(inst, warning_time)
	return inst
	
	
func create_rotationinversion_bomb(bomb_position: Vector2, warning_time: float, bomb_time: float):
	var inst = RotationInversionBomb_scene.instantiate()
	var inst2 = RotationInversionBomb_warning_scene.instantiate()
	inst.position = bomb_position
	inst2.position = bomb_position
	inst2.warningtime = warning_time
	var timer = inst.get_node("BombTimer")
	timer.set_time = bomb_time
	
	get_tree().current_scene.add_child(inst2)
	Utils.attach_node(inst, inst2)
	add_bomb(inst, warning_time)
	return inst
	
	
func create_rotationspeedup_bomb(bomb_position: Vector2, warning_time: float, bomb_time: float, speed_up_value: float):
	var inst = RotationSpeedUpBomb_scene.instantiate()
	var inst2 = RotationSpeedUpBomb_warning_scene.instantiate()
	inst.position = bomb_position
	inst2.position = bomb_position
	inst2.warningtime = warning_time
	var timer = inst.get_node("BombTimer")
	timer.set_time = bomb_time
	inst.rotation_speed_up_value = speed_up_value
	
	get_tree().current_scene.add_child(inst2)
	Utils.attach_node(inst, inst2)
	add_bomb(inst, warning_time)
	return inst
	
	
func create_gamespeedup_bomb(bomb_position: Vector2, warning_time: float, bomb_time: float, speed_up_value: float):
	var inst = GameSpeedUpBomb_scene.instantiate()
	var inst2 = GameSpeedUpBomb_warning_scene.instantiate()
	inst.position = bomb_position
	inst2.position = bomb_position
	inst2.warningtime = warning_time
	var timer = inst.get_node("BombTimer")
	timer.set_time = bomb_time
	inst.game_speed_up_value = speed_up_value
	
	get_tree().current_scene.add_child(inst2)
	Utils.attach_node(inst, inst2)
	add_bomb(inst, warning_time)
	return inst


func create_bomb_link(bomb1: Bomb, bomb2: Bomb):
	var link = bomb_link.instantiate()
	link.set_child_bombs(bomb1, bomb2)
	get_tree().current_scene.add_child(link)
