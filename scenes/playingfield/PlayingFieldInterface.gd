extends Node2D
#class_name PlayingFieldInterface

func get_PlayingField_node():
	var node: PlayingField = get_tree().current_scene.get_node("PlayingField")
	return node

func game_over():
	get_PlayingField_node().stop_PlayingField()
