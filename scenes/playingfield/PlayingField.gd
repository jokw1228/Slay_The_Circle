extends Node2D
class_name PlayingField

@export var BombGenerator: PackedScene

@export var PlayingFieldCamera_node: PlayingFieldCamera
@export var PlayingFieldUI_node: PlayingFieldUI
@export var Player_node: Player

var playing_time: float = 0
var playing: bool = true

var BombGenerator_node: Node2D

func _ready():
	start_PlayingField()

func _process(delta):
	if playing == true:
		playing_time += delta / Engine.time_scale
		PlayingFieldUI_node.playing_time_updated(playing_time)

func start_PlayingField():
	playing = true
	
	PlayingFieldCamera_node.rotation_reset()
	PlayingFieldUI_node.close_Stopped_and_open_Playing()
	
	BombGenerator_node = BombGenerator.instantiate()
	add_child(BombGenerator_node)

func stop_PlayingField():
	playing = false
	
	PlayingFieldInterface.game_speed_reset()
	PlayingFieldCamera_node.rotation_stop()
	
	BombGenerator_node.queue_free()
	
	await get_tree().create_timer(1.0).timeout
	PlayingFieldUI_node.close_Playing_and_open_Stopped()


### interface

func rotation_speed_up(up: float):
	PlayingFieldCamera_node.rotation_speed_up(up)

func rotation_inversion():
	PlayingFieldCamera_node.rotation_inversion()
