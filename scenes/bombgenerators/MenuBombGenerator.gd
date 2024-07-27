extends Node2D

var room_menu: RoomMenu

signal circle
signal circler
signal circlest
signal hyper

func select_circle():
	room_menu.select_circle()
	circle.emit()

func select_circler():
	room_menu.select_circler()
	circler.emit()

func select_circlest():
	room_menu.select_circlest()
	circlest.emit()

func select_hyper():
	room_menu.select_hyper()
	hyper.emit()
