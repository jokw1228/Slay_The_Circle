extends Area2D

@export var PlayerRayCast2D: RayCast2D

signal slay

func _draw():
	draw_arc(position, 32, 0, 2 * PI, 9, Color.WHITE, 4.0, false)

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		look_at(get_global_mouse_position())
		slay.emit()

func _on_player_ray_cast_2d_move_player(position_to_go):
	var tween = create_tween()
	var d = position_to_go - position
	var distance: float = sqrt(d.x * d.x + d.y * d.y)
	var speed: float = 2048
	tween.tween_property(self, "position", position_to_go, distance / speed)
