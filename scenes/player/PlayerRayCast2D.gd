extends RayCast2D

signal move_player(position_to_go)

var on_slaying: bool = false

const CIRCLE_FIELD_RADIUS = 256

func _physics_process(_delta):
	if on_slaying:
		on_slaying = false
		
		var position_to_go = get_collision_point().normalized() * CIRCLE_FIELD_RADIUS
		move_player.emit(position_to_go)


func _on_player_change_click_queue_to_movement_queue(click_position):
	if on_slaying == false:
		on_slaying = true
		look_at(click_position)
