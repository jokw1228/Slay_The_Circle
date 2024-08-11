extends Node2D
class_name PlayingField

@export var BombGenerator_scene: PackedScene

@export var PlayingFieldCamera_node: PlayingFieldCamera
@export var PlayingFieldUI_node: PlayingFieldUI
@export var Player_node: Player
@export var BackGroundEffect_node: Node2D

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
		
		playing_time = -1 # time offset due to an animation delay
		
		BombGenerator_node = BombGenerator_scene.instantiate()
		add_child(BombGenerator_node)
		
		connect("game_over", Callable(BombGenerator_node, "queue_free"))
		
	if (MusicManager.is_playing("bgm_PF","playing_bgm")):
		MusicManager.disable_stem("dead",0.5)
		MusicManager.enable_stem("on_game",0.5)
	else:
		MusicManager.stop(0.5)
		MusicManager.play("bgm_PF","playing_bgm",0.5,1)

func stop_PlayingField(bomb_position: Vector2):
	if playing == true:
		playing = false
		PlayingFieldCamera_node.set_bomb_position(bomb_position)
		CircleField_node.set_bomb_position(bomb_position)
		emit_signal("game_over")
		
		PlayingFieldInterface.game_speed_reset()
		
		SoundManager.play("sfx_PF","explosion")
		MusicManager.enable_stem("dead",0.5)
		MusicManager.disable_stem("on_game",0.5)
		
		# Create a StartBomb
		await get_tree().create_timer(2.3).timeout
		emit_signal("game_ready")
		await get_tree().create_timer(0.6).timeout
		add_child( StartBomb.create(Vector2.ZERO, Callable(self, "start_PlayingField")) )

# Logic for BombLink
func _on_player_grounded():
	if BombGenerator_node != null:
		BombGenerator_node.get_tree().call_group("links", "on_player_grounded")


### interface
func game_speed_up():
	BackGroundEffect_node.speed_up(PlayingFieldInterface.get_theme_color().lightened(0.5))

func rotation_speed_up(up: float):
	PlayingFieldCamera_node.rotation_speed_up(up)
	BackGroundEffect_node.rotation_up(PlayingFieldInterface.get_theme_color().lightened(0.5))

func rotation_inversion():
	PlayingFieldCamera_node.rotation_inversion()
	BackGroundEffect_node.rotation_inversion(PlayingFieldInterface.get_theme_color().lightened(0.5))
	
func rotation_stop():
	PlayingFieldCamera_node.rotation_stop()

func get_playing_time() -> float:
	return playing_time

func add_playing_time(time_to_add: float): # legacy code
	if playing == true:
		playing_time += time_to_add / Engine.time_scale

func set_playing_time(time_to_set: float):
	if playing == true:
		playing_time = time_to_set
