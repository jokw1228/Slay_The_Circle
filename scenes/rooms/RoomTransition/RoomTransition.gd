extends Control
class_name RoomTransition

@onready var animation_tex : TextureRect = $TextureRect
@onready var animation_player : AnimationPlayer = $AnimationPlayer


func _ready():
	animation_tex.visible = false

func _on_room_logo_room_transition_fadein():
	animation_player.queue("RoomTransition_FadeIn")


func _on_room_logo_room_transition_fadeout():
	animation_player.queue("RoomTransition_FadeOut")
