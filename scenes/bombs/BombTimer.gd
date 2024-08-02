extends TextureProgressBar

@export var set_time: float = 1

signal bomb_timeout

func _ready():
	max_value = set_time * 100
	value = max_value

func _process(delta):
	value -= 100 * delta
	if value <= 0:
		value = max_value
		bomb_timeout.emit()
