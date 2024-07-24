extends Node2D
class_name RoomLogo
signal room_transition_fadein
signal room_transition_fadeout
signal room_color_change

@export var room_menu: PackedScene
@export var Logos_node: Node2D
@export var RoomMainMenu_room: PackedScene
#@export var LogoSound: AudioStream
#var sound_player: AudioStreamPlayer
var room_transition_scene: PackedScene = load("res://scenes/rooms/RoomTransition/RoomTransition.tscn")


func _ready():
	# playsound
	#sound_player=AudioStreamPlayer.new()
	#add_child(sound_player)
	#sound_player.stream=LogoSound
	#sound_player.volume_db = -15
	#sound_player.play()
	SoundManager.loaded.connect(on_sound_manager_loaded)
	#로고 밝아지게 하기
	var tween1=get_tree().create_tween()
	tween1.tween_property(Logos_node, "modulate", Color(1,1,1,0), 0.0)
	await tween1.finished
	emit_signal("room_transition_fadein")
	emit_signal("room_color_change")
	tween1 = get_tree().create_tween()
	tween1.tween_property(Logos_node, "modulate", Color(1, 1, 1, 1), 4.0)
	await get_tree().create_timer(4.0).timeout
	await tween1.finished
	
	tween1 = get_tree().create_tween()
	tween1.tween_property(Logos_node, "modulate", Color(1, 1, 1, 0), 0.0)
	await tween1.finished
	
	emit_signal("room_transition_fadeout")
	await get_tree().create_timer(1.0).timeout

	get_tree().change_scene_to_packed(room_menu)
		
func on_sound_manager_loaded() -> void:
	SoundManager.play("sfx_logo","fade_in")
	
