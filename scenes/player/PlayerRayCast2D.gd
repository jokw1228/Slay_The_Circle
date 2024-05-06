extends RayCast2D

@export var Player: CharacterBody2D

signal move_player(position_to_go)

var on_slaying: bool = false

func _on_player_slay():
	if on_slaying == false:
		on_slaying = true

func _physics_process(_delta):
	if on_slaying:
		on_slaying = false
		
		var position_to_go = get_collision_point().normalized() * 256
		move_player.emit(position_to_go)
