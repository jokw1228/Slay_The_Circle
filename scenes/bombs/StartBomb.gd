extends Bomb
class_name StartBomb

const StartBomb_scene = "res://scenes/bombs/StartBomb.tscn"

@onready var RestartSprite_node: Sprite2D = $RestartSprite

signal started

static func create(position_to_set: Vector2, callable_to_connect: Callable) -> StartBomb:
	var inst: StartBomb = load(StartBomb_scene).instantiate() as StartBomb
	inst.position = position_to_set
	inst.connect("started", callable_to_connect)
	return inst

func slayed():
	started.emit()
	super()
	
	SoundManager.play("sfx_S_bomb","slay")

func _process(delta):
	RestartSprite_node.rotate(-delta * PI / 2)
