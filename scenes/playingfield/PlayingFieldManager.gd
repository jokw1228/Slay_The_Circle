extends Node2D
#class_name PlayingFieldManager


func get_PlayingField_node():
	var node: PlayingField = get_tree().current_scene
	return node

func game_over():
	pass
