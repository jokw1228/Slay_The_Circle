extends AnimatedSprite2D

@export var Player_node: Player
@export var PlayerRayCast2D: RayCast2D

var ready_to_shoot: bool = false
var ready_to_land: bool = false

func _on_player_grounded():
	stop()
	play("laser_landing")
	ready_to_land = true

func _on_player_shooted():
	stop()
	rotation = PlayerRayCast2D.rotation
	play_backwards("laser_landing")
	ready_to_shoot = true

func _on_animation_finished():
	if ready_to_shoot == true:
		stop()
		play("laser")
		ready_to_shoot = false
	elif ready_to_land == true:
		stop()
		rotation = atan2(Player_node.position.y, Player_node.position.x)
		play("landed")
		ready_to_land = false
