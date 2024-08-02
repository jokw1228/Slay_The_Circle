extends TextureProgressBar

@export var set_time: float = 1

signal bomb_timeout

func _ready():
	var tween_time: Tween = get_tree().create_tween()
	tween_time.tween_property(self, "value", 0.0, set_time)
	await tween_time.finished
	bomb_timeout.emit()
