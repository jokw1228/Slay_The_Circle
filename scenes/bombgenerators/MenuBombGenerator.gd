extends Node2D

var room_menu: RoomMenu

signal circle
signal circler
signal circlest
signal hyper

func select_circle():
	room_menu.select_stage(0)
	circle.emit()

func select_circler():
	room_menu.select_stage(1)
	circler.emit()

func select_circlest():
	room_menu.select_stage(2)
	circlest.emit()

func select_hyper():
	room_menu.select_hyper()
	hyper.emit()
