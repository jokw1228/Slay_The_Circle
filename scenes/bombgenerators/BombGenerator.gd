extends Node2D
class_name BombGenerator

var NormalBomb_scene :PackedScene = preload("res://scenes/bombs/NormalBomb.tscn")
var HazardBomb_scene :PackedScene = preload("res://scenes/bombs/HazardBomb.tscn")
var NumericBomb_scene :PackedScene = preload("res://scenes/bombs/NumericBomb.tscn")
var RotationInversionBomb_scene :PackedScene = preload("res://scenes/bombs/RotationInversionBomb.tscn")
var RotationSpeedUpBomb_scene :PackedScene = preload("res://scenes/bombs/RotationSpeedUpBomb.tscn")
var GameSpeedUpBomb_scene :PackedScene = preload("res://scenes/bombs/GameSpeedUpBomb.tscn")

var Normalbomb_warning_scene :PackedScene = preload("res://scenes/warnings/NormalBombWarning.tscn")
var HazardBomb_warning_scene :PackedScene = preload("res://scenes/warnings/HazardBombWarning.tscn")
var NumericBomb_warning_scene :PackedScene = preload("res://scenes/warnings/NumericBombWarning.tscn")
var RotationInversionBomb_warning_scene :PackedScene = preload("res://scenes/warnings/RotationInversionBombWarning.tscn")
var RotationSpeedUpBomb_warning_scene :PackedScene = preload("res://scenes/warnings/RotationSpeedUpBombWarning.tscn")
var GameSpeedUpBomb_warning_scene :PackedScene = preload("res://scenes/warnings/GameSpeedUpBombWarning.tscn")

var bomb_link :PackedScene = preload("res://scenes/bombs/BombLink.tscn")


func add_bomb(bomb_instance: Bomb, waiting_time: float):
	await Utils.timer(waiting_time)
	self.call_deferred("add_child", bomb_instance)


func create_normal_bomb(bomb_position: Vector2, warning_time: float, bomb_time: float) -> NormalBomb:
	var bomb_inst: NormalBomb = NormalBomb_scene.instantiate()
	var warning_inst: Warning = Normalbomb_warning_scene.instantiate()
	
	bomb_inst.position = bomb_position
	warning_inst.position = bomb_position
	
	bomb_inst.get_node("BombTimer").set_time = bomb_time
	warning_inst.get_node("BombTimer").set_time = warning_time
	
	self.call_deferred("add_child", warning_inst)
	Utils.attach_node(bomb_inst, warning_inst)
	add_bomb(bomb_inst, warning_time)
	return bomb_inst


func create_hazard_bomb(bomb_position: Vector2, warning_time: float, bomb_time: float) -> HazardBomb:
	var bomb_inst: HazardBomb = HazardBomb_scene.instantiate()
	var warning_inst: Warning = HazardBomb_warning_scene.instantiate()
	
	bomb_inst.position = bomb_position
	warning_inst.position = bomb_position
	
	bomb_inst.get_node("BombTimer").set_time = bomb_time
	warning_inst.get_node("BombTimer").set_time = warning_time
	
	self.call_deferred("add_child", warning_inst)
	Utils.attach_node(bomb_inst, warning_inst)
	add_bomb(bomb_inst, warning_time)
	return bomb_inst


func create_numeric_bomb(bomb_position: Vector2, warning_time: float, bomb_time: float, bomb_id: int) -> NumericBomb:
	var bomb_inst = NumericBomb_scene.instantiate()
	var warning_inst: Warning = NumericBomb_warning_scene.instantiate()
	
	bomb_inst.position = bomb_position
	warning_inst.position = bomb_position
	
	bomb_inst.get_node("BombTimer").set_time = bomb_time
	warning_inst.get_node("BombTimer").set_time = warning_time
	
	bomb_inst.id = bomb_id
	warning_inst.get_node("BombID").text = str(bomb_id)
	
	self.call_deferred("add_child", warning_inst)
	Utils.attach_node(bomb_inst, warning_inst)
	add_bomb(bomb_inst, warning_time)
	return bomb_inst


func create_rotationinversion_bomb(bomb_position: Vector2, warning_time: float, bomb_time: float) -> RotationInversionBomb:
	var bomb_inst = RotationInversionBomb_scene.instantiate()
	var warning_inst: Warning = RotationInversionBomb_warning_scene.instantiate()
	
	bomb_inst.position = bomb_position
	warning_inst.position = bomb_position
	
	bomb_inst.get_node("BombTimer").set_time = bomb_time
	warning_inst.get_node("BombTimer").set_time = warning_time
	
	self.call_deferred("add_child", warning_inst)
	Utils.attach_node(bomb_inst, warning_inst)
	add_bomb(bomb_inst, warning_time)
	return bomb_inst


func create_rotationspeedup_bomb(bomb_position: Vector2, warning_time: float, bomb_time: float, speed_up_value: float) -> RotationSpeedUpBomb:
	var bomb_inst = RotationSpeedUpBomb_scene.instantiate()
	var warning_inst = RotationSpeedUpBomb_warning_scene.instantiate()
	
	bomb_inst.position = bomb_position
	warning_inst.position = bomb_position
	
	bomb_inst.get_node("BombTimer").set_time = bomb_time
	warning_inst.get_node("BombTimer").set_time = warning_time
	
	bomb_inst.rotation_speed_up_value = speed_up_value
	
	self.call_deferred("add_child", warning_inst)
	Utils.attach_node(bomb_inst, warning_inst)
	add_bomb(bomb_inst, warning_time)
	return bomb_inst


func create_gamespeedup_bomb(bomb_position: Vector2, warning_time: float, bomb_time: float, speed_up_value: float) -> GameSpeedUpBomb:
	var bomb_inst = GameSpeedUpBomb_scene.instantiate()
	var warning_inst: Warning = GameSpeedUpBomb_warning_scene.instantiate()
	
	bomb_inst.position = bomb_position
	warning_inst.position = bomb_position
	
	bomb_inst.get_node("BombTimer").set_time = bomb_time
	warning_inst.get_node("BombTimer").set_time = warning_time
	
	bomb_inst.game_speed_up_value = speed_up_value
	
	self.call_deferred("add_child", warning_inst)
	Utils.attach_node(bomb_inst, warning_inst)
	add_bomb(bomb_inst, warning_time)
	return bomb_inst


func create_bomb_link(bomb1: Bomb, bomb2: Bomb) -> BombLink:
	var link = bomb_link.instantiate()
	link.set_child_bombs(bomb1, bomb2)
	self.call_deferred("add_child", link)
	return link


func slay_left_bomb():
	#for node in get_tree().current_scene.get_children():
	#		if node is Bomb or node is Warning:
	#			node.queue_free()
		
	#get_tree().call_group("links", "queue_free")
	queue_free()

