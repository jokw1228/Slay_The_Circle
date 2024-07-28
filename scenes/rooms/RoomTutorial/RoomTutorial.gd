extends Node2D

@onready var TutorialBombGenerator_node = $TutorialBombGenerator

var RoomMenu_room = "res://scenes/rooms/RoomMenu/RoomMenu.tscn"

func _ready():
	TutorialBombGenerator_node.pattern_1()

func tutorial_1():
	pass
