extends CanvasLayer
class_name PlayingFieldUI

@export var Playing_node: Node2D
@export var Stopped_node: Node2D

@export var Seconds_node: Label
@export var Milliseconds_node: Label

func playing_time_updated(time: float):
	var seconds_value: int = floor(time)
	Seconds_node.text = str(seconds_value)
	
	var milliseconds_value: int = floor((time - seconds_value) * 100)
	Milliseconds_node.text = ":" + str(milliseconds_value)

func close_Stopped_and_open_Playing():
	Stopped_node.visible = false
	Playing_node.visible = true

func close_Playing_and_open_Stopped():
	Playing_node.visible = false
	Stopped_node.visible = true
