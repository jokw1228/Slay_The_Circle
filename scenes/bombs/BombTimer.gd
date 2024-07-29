extends Control

@export var Bar: TextureProgressBar
@export var set_time: float = 1

signal bomb_timeout

func _ready():
	Bar.max_value = set_time * 100
	Bar.value = Bar.max_value

func _process(delta):
	Bar.value -= 100 * delta
	if Bar.value <= 0:
		Bar.value = Bar.max_value
		bomb_timeout.emit()
