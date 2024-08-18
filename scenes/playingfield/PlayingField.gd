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
		
	if(PlayingFieldInterface.get_stage_index() == 0 || PlayingFieldInterface.get_stage_index() == 3):
		#circle 음악 재생
		if (MusicManager.is_playing("bgm_PF","playing_bgm")):
			MusicManager.disable_stem("dead",0.5)
			MusicManager.enable_stem("on_game",0.5)
		else:
			MusicManager.stop(0.5)
			MusicManager.play("bgm_PF","playing_bgm",0.5,1)
			
	elif(PlayingFieldInterface.get_stage_index() == 1 || PlayingFieldInterface.get_stage_index() == 4):
		#circler 음악 재생
		if (MusicManager.is_playing("bgm_PF","playing_bgm_2")):
			MusicManager.disable_stem("dead",0.5)
			MusicManager.enable_stem("on_game",0.5)
		else:
			MusicManager.stop(0.5)
			MusicManager.play("bgm_PF","playing_bgm_2",0.5,1)
			
	elif(PlayingFieldInterface.get_stage_index() == 2 || PlayingFieldInterface.get_stage_index() == 5):
		#circlest 음악 재생
		if (MusicManager.is_playing("bgm_PF","playing_bgm_3")):
			MusicManager.disable_stem("dead",0.5)
			MusicManager.enable_stem("on_game",0.5)
		else:
			MusicManager.stop(0.5)
			MusicManager.play("bgm_PF","playing_bgm_3",0.5,1)
			
	#스타트 목소리..
	SoundManager.play("sfx_PF","start")



func stop_PlayingField(bomb_position: Vector2):
	if playing == true:
		playing = false
		PlayingFieldCamera_node.set_bomb_position(bomb_position)
		CircleField_node.set_bomb_position(bomb_position)
		emit_signal("game_over")
		
		PlayingFieldInterface.game_speed_reset()
		
		# 게임오버 목소리.... 게임에 안어울리면 주석처리 해주십시오...
		SoundManager.play("sfx_PF","game_over")
		MusicManager.enable_stem("dead",0.5)
		MusicManager.disable_stem("on_game",0.5)
		
		# Create a StartBomb
		await get_tree().create_timer(1.3).timeout
		Player_node.is_playing = false
		await get_tree().create_timer(0.5).timeout
		emit_signal("game_ready")
		await get_tree().create_timer(0.55).timeout
		add_child(StartBomb.create(Vector2.ZERO, Callable(self, "start_PlayingField")) )

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

func set_playing_time(time_to_set: float):
	if playing == true:
		playing_time = time_to_set

func set_player_position(position_to_set: Vector2):
	await !Player_node.is_moving
	Player_node.position = position_to_set
	Player_node.PlayerSprite2D_node.rotation = Player_node.PlayerSprite2D_node.global_position.angle()
	Player_node.is_playing = true
