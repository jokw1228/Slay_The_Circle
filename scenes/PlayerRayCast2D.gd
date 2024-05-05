extends RayCast2D

@export var Player: CharacterBody2D

var on_slaying: bool = false

func _on_player_slay():
	if on_slaying == false:
		on_slaying = true

func _physics_process(_delta):
	if on_slaying:
		on_slaying = false
		Player.position = (get_collision_point()).normalized() * 256
		
