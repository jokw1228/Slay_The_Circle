extends TextureProgressBar
class_name BombTimer

@export var set_time: float = 1

signal bomb_timeout

func bomb_timer_start():
	visible = true
	var tween_time: Tween = get_tree().create_tween()
	tween_time.tween_property(self, "value", 0.0, set_time)
	await tween_time.finished
	bomb_timeout.emit()
