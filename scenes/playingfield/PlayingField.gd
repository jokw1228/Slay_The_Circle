extends Node2D
class_name PlayingField

@export var BombGenerator: Node

@export var PlayingFieldCamera_node: PlayingFieldCamera
@export var PlayingFieldUI_node: PlayingFieldUI
@export var Player_node: Player

var playing_time: float = 0
var playing: bool = true

func _process(delta):
	if playing == true:
		playing_time += delta / Engine.time_scale
		PlayingFieldUI_node.playing_time_updated(playing_time)

func start_PlayingField():
	playing = true
	
	PlayingFieldCamera_node.rotation_reset()
	PlayingFieldUI_node.close_Stopped_and_open_Playing()

func stop_PlayingField():
	playing = false
	
	Engine.time_scale = 1.0
	PlayingFieldCamera_node.rotation_stop()
	await get_tree().create_timer(0.5).timeout
	PlayingFieldUI_node.close_Playing_and_open_Stopped()


### interface

func rotation_speed_up(up: float):
	PlayingFieldCamera_node.rotation_speed_up(up)

func rotation_inversion():
	PlayingFieldCamera_node.rotation_inversion()
