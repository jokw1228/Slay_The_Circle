extends AnimatedSprite2D

@export var Player_node: Player
@export var PlayerRayCast2D: RayCast2D

var ready_to_shoot: bool = false
var ready_to_land: bool = false

func _on_player_grounded():
	offset.x = -48
	play("laser_landing")
	ready_to_land = true
	ready_to_shoot = false

func _on_player_shooted():
	rotation = PlayerRayCast2D.rotation
	offset.x = 0
	play_backwards("laser_landing")
	ready_to_shoot = true
	ready_to_land = false

func _on_animation_finished():
	if ready_to_shoot == true:
		offset.x = 0
		play("laser")
		ready_to_shoot = false
	elif ready_to_land == true:
		rotation = atan2(Player_node.position.y, Player_node.position.x)
		offset.x = -48
		play("landed")
		ready_to_land = false
