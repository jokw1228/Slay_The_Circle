extends CanvasLayer
class_name PlayingFieldUI

@export var Seconds: Label
@export var Milliseconds: Label

func playing_time_updated(time: float):
	var seconds_value: int = floor(time)
	Seconds.text = str(seconds_value)
	
	var milliseconds_value: int = floor((time - seconds_value) * 100)
	Milliseconds.text = ":" + str(milliseconds_value)
