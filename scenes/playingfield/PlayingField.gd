extends Node2D
class_name PlayingField

@export var PlayingFieldCamera_node: PlayingFieldCamera

func start_PlayingField():
	#set timer
	pass #virtual method

func rotation_speed_up(up: float):
	PlayingFieldCamera_node.rotation_speed_up(up)

func rotation_inversion():
	PlayingFieldCamera_node.rotation_inversion()
