extends Node2D
class_name PlayingField

@export var BombGenerator_scene: PackedScene

@export var StartBomb_scene: PackedScene

@export var PlayingFieldCamera_node: PlayingFieldCamera
@export var PlayingFieldUI_node: PlayingFieldUI
@export var Player_node: Player

var playing_time: float = 0
var playing: bool = false

var BombGenerator_node: Node2D

func _ready():
	PlayingFieldInterface.set_PlayingField_node(self)
	start_PlayingField()

func _process(delta):
	if playing == true:
		playing_time += delta / Engine.time_scale
		PlayingFieldUI_node.playing_time_updated(playing_time)

func start_PlayingField():
	if playing == false:
		playing = true
		
		PlayingFieldCamera_node.rotation_reset()
		PlayingFieldUI_node.close_Stopped_and_open_Playing()
		playing_time = 0
		
		BombGenerator_node = BombGenerator_scene.instantiate()
		add_child(BombGenerator_node)

func stop_PlayingField():
	if playing == true:
		playing = false
		
		PlayingFieldInterface.game_speed_reset()
		PlayingFieldCamera_node.rotation_stop()
		
		BombGenerator_node.queue_free()
		
		await get_tree().create_timer(1.0).timeout
		PlayingFieldUI_node.close_Playing_and_open_Stopped()
		
		# Create a StartBomb
		var StartBomb_node: StartBomb = StartBomb_scene.instantiate()
		StartBomb_node.position = Vector2.ZERO
		StartBomb_node.started.connect(start_PlayingField)
		get_tree().current_scene.add_child(StartBomb_node)


### interface

func rotation_speed_up(up: float):
	PlayingFieldCamera_node.rotation_speed_up(up)

func rotation_inversion():
	PlayingFieldCamera_node.rotation_inversion()
