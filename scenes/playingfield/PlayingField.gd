extends Node2D
class_name PlayingField

@export var BombGenerator_scene: PackedScene

@export var StartBomb_scene: PackedScene

@export var PlayingFieldCamera_node: PlayingFieldCamera
@export var PlayingFieldUI_node: PlayingFieldUI
@export var Player_node: Player

signal game_start
signal game_over

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
		game_start.emit()
		
		playing_time = 0
		
		BombGenerator_node = BombGenerator_scene.instantiate()
		add_child(BombGenerator_node)

func stop_PlayingField():
	if playing == true:
		playing = false
		game_over.emit()
		PlayingFieldCamera_node.zoom_transition()
		PlayingFieldInterface.game_speed_reset()
		
		BombGenerator_node.queue_free()
		
		# Create a StartBomb
		await get_tree().create_timer(1.0).timeout
		var StartBomb_node: StartBomb = StartBomb_scene.instantiate()
		StartBomb_node.position = Vector2.ZERO
		StartBomb_node.started.connect(start_PlayingField)
		get_tree().current_scene.add_child(StartBomb_node)


### interface

func rotation_speed_up(up: float):
	PlayingFieldCamera_node.rotation_speed_up(up)

func rotation_inversion():
	PlayingFieldCamera_node.rotation_inversion()
	
func gameover_position(x:Vector2):
	PlayingFieldCamera_node.position_transition(x)
