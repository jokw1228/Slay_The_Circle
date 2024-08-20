extends TextureProgressBar
class_name WarningTimer

@export var set_time: float = 1

signal warning_timeout

func _ready():
	var tween_time: Tween = get_tree().create_tween()
	tween_time.tween_property(self, "value", 0.0, set_time)
	await tween_time.finished
	warning_timeout.emit()

func _process(_delta):
	var parent: Bomb = get_parent() as Bomb
	var bright: float = PlayingFieldInterface.get_theme_bright()
	if parent != null and value != 0:
		parent.modulate.a = (32.0 + 32.0 * bright) / 256.0
