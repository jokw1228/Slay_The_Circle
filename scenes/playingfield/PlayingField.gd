extends Node2D
class_name PlayingField

@export var PlayingFieldCamera_node: PlayingFieldCamera
@export var PlayingFieldUI_node: PlayingFieldUI

var playing_time: float = 0
var playing: bool = false

func _ready():
	playing = true
	pass

func _process(delta):
	if playing == true:
		playing_time += delta / Engine.time_scale
		PlayingFieldUI_node.playing_time_updated(playing_time)

func start_PlayingField():
	playing = true
	pass #virtual method

func stop_PlayingField():
	playing = false
	pass

func rotation_speed_up(up: float):
	PlayingFieldCamera_node.rotation_speed_up(up)

func rotation_inversion():
	PlayingFieldCamera_node.rotation_inversion()
