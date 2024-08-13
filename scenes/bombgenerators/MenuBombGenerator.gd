extends Node2D

var room_menu: RoomMenu

signal circle
signal circler
signal circlest
signal hyper

func select_circle():
	PlayingFieldInterface.set_theme_color(Color.DEEP_SKY_BLUE)
	PlayingFieldInterface.set_theme_bright(0)
	room_menu.select_stage(0)
	circle.emit()

func select_circler():
	PlayingFieldInterface.set_theme_color(Color.MEDIUM_PURPLE)
	PlayingFieldInterface.set_theme_bright(0)
	room_menu.select_stage(1)
	circler.emit()

func select_circlest():
	PlayingFieldInterface.set_theme_color(Color.ORANGE_RED)
	PlayingFieldInterface.set_theme_bright(0)
	room_menu.select_stage(2)
	circlest.emit()

func select_hyper():
	PlayingFieldInterface.set_theme_bright(1)
	room_menu.select_hyper()
	hyper.emit()
