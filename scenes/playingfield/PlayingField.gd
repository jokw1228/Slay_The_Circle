extends Node2D
class_name PlayingField

@export var BombGenerator_scene: PackedScene

@export var StartBomb_scene: PackedScene

@export var PlayingFieldCamera_node: PlayingFieldCamera
@export var PlayingFieldUI_node: PlayingFieldUI
@export var Player_node: Player

@export var CircleField_node: StaticBody2D

signal game_start
signal game_over
signal game_ready

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
		emit_signal("game_start")
		
		playing_time = 0
		
		BombGenerator_node = BombGenerator_scene.instantiate()
		add_child(BombGenerator_node)
		
		connect("game_over", Callable(BombGenerator_node, "slay_left_bomb"))

func stop_PlayingField(bomb_position: Vector2):
	if playing == true:
		playing = false
		CircleField_node.set_bomb_position(bomb_position)
		emit_signal("game_over")
		
		PlayingFieldInterface.game_speed_reset()
		
		SoundManager.play("sfx_PF","explosion")
		MusicManager.play("bgm_PF","test_slow",0,1)
		
		# Create a StartBomb
		await get_tree().create_timer(5.0).timeout
		emit_signal("game_ready")
		await get_tree().create_timer(1.0).timeout
		var StartBomb_node: StartBomb = StartBomb_scene.instantiate()
		StartBomb_node.position = Vector2.ZERO
		StartBomb_node.started.connect(start_PlayingField)
		get_tree().current_scene.add_child(StartBomb_node)

# Logic for BombLink
func _on_player_grounded():
	if BombGenerator_node != null:
		BombGenerator_node.get_tree().call_group("links", "on_player_grounded")


### interface

func rotation_speed_up(up: float):
	PlayingFieldCamera_node.rotation_speed_up(up)

func rotation_inversion():
	PlayingFieldCamera_node.rotation_inversion()

func rotation_stop():
	PlayingFieldCamera_node.rotation_stop()

func merge_transition(x):
	PlayingFieldCamera_node.add_transition(x)

func get_playing_time() -> float:
	return playing_time

func add_playing_time(time_to_add: float):
	if playing == true:
		playing_time += time_to_add
