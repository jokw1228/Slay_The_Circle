extends Bomb
class_name StartBomb

@onready var RestartSprite_node: Sprite2D = $RestartSprite

signal started

func slayed():
	started.emit()
	super()

func _process(delta):
	RestartSprite_node.rotate(-delta * PI / 2)
