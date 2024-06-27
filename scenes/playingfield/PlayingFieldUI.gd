extends CanvasLayer
class_name PlayingFieldUI

@export var Playing_node: Node2D
@export var Stopped_node: Node2D

@export var Seconds_node: Label
@export var Milliseconds_node: Label

@export var last_Seconds_node: Label
@export var last_Milliseconds_node: Label

var seconds_value: int = 0
var milliseconds_value: int = 0

func playing_time_updated(time: float):
	seconds_value = floor(time)
	Seconds_node.text = str(seconds_value)
	
	milliseconds_value = floor((time - seconds_value) * 100)
	Milliseconds_node.text = ":" + str(milliseconds_value)

func close_Stopped_and_open_Playing():
	Stopped_node.visible = false
	Playing_node.visible = true

func close_Playing_and_open_Stopped():
	Playing_node.visible = false
	Stopped_node.visible = true
	
	last_Seconds_node.text = str(seconds_value)
	last_Milliseconds_node.text = ":" + str(milliseconds_value)
