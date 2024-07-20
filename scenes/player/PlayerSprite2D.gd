extends AnimatedSprite2D

@export var Player_node: Player
@export var PlayerRayCast2D: RayCast2D

func _on_player_grounded():
	animation = "laser_landing"
	play()

func _on_player_shooted():
	rotation = PlayerRayCast2D.rotation
	animation = "laser"

func _on_animation_finished():
	rotation = atan2(Player_node.position.y, Player_node.position.x)
	animation = "landed"
