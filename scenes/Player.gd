extends CharacterBody2D

@export var PlayerRayCast2D: RayCast2D

signal slay

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var target_position: Vector2 = get_global_mouse_position()
		
		PlayerRayCast2D.look_at(target_position)
		slay.emit()

func _draw():
	draw_arc(position, 32, 0, 2 * PI, 9, Color.WHITE, 4.0, false)
