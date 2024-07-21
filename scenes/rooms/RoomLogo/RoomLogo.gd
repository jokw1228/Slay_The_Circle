extends Node2D
class_name RoomLogo

@export var room_menu: PackedScene
@export var Logos_node: Node2D
@export var RoomMainMenu_room: PackedScene
@export var LogoSound: AudioStream
var sound_player: AudioStreamPlayer

func _ready():
	#playsound
	sound_player=AudioStreamPlayer.new()
	add_child(sound_player)
	sound_player.stream=LogoSound
	sound_player.volume_db = -15
	sound_player.play()
	#로고 밝아지게 하기
	var tween1=get_tree().create_tween()
	tween1.tween_property(Logos_node, "modulate", Color(1,1,1,0), 0.0)
	await tween1.finished
	tween1 = get_tree().create_tween()
	tween1.tween_property(Logos_node, "modulate", Color(1, 1, 1, 1), 5.0)
	await get_tree().create_timer(5.0).timeout
	await tween1.finished
	
	tween1 = get_tree().create_tween()
	tween1.tween_property(Logos_node, "modulate", Color(1, 1, 1, 0), 0.0)
	
	#룸 메뉴로 이동
	get_tree().change_scene_to_packed(room_menu)
	

	
