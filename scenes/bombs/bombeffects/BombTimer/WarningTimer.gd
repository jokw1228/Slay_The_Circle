extends TextureProgressBar
class_name WarningTimer

@export var set_time: float = 1

signal warning_timeout

func _ready():
	var tween_time: Tween = get_tree().create_tween()
	tween_time.tween_property(self, "value", 0.0, set_time)
	await tween_time.finished
	warning_timeout.emit()
