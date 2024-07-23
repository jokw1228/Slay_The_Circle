extends Node2D

@export var themecolor: PackedScene
var room_menu: RoomMenu

signal circle
signal circler
signal circlest
signal hyper

func select_circle():
	room_menu.select_circle()
	circle.emit()
	var sprite = themecolor.instantiate()
	get_tree().current_scene.add_child(sprite)
func select_circler():
	room_menu.select_circler()
	circler.emit()
	var sprite = themecolor.instantiate()
	get_tree().current_scene.add_child(sprite)
func select_circlest():
	room_menu.select_circlest()
	circlest.emit()
	var sprite = themecolor.instantiate()
	get_tree().current_scene.add_child(sprite)
func select_hyper():
	room_menu.select_hyper()
	hyper.emit()
	var sprite = themecolor.instantiate()
	get_tree().current_scene.add_child(sprite)
