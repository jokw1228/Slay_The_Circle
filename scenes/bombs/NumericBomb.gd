extends Bomb
class_name NumericBomb

const NumericBomb_scene = "res://scenes/bombs/NumericBomb.tscn"

signal lower_value_bomb_exists
signal no_lower_value_bomb_exists

var id: int = 0

@export var CollisionShape2D_node: CollisionShape2D
@export var BombTimer_node: BombTimer
@export var WarningTimer_node: WarningTimer

static func create(position_to_set: Vector2, warning_time_to_set: float, bomb_time_to_set: float, id_to_set: int) -> NumericBomb:
	var bomb_inst: NumericBomb = preload(NumericBomb_scene).instantiate() as NumericBomb
	bomb_inst.position = position_to_set
	bomb_inst.BombTimer_node.set_time = bomb_time_to_set
	bomb_inst.WarningTimer_node.set_time = warning_time_to_set
	bomb_inst.id = id_to_set
	return bomb_inst

func _on_warning_timer_warning_timeout():
	modulate.a = 1.0
	CollisionShape2D_node.disabled = false

func _ready():
	$BombID.text = str(id)

func slayed():
	super()
	
	SoundManager.play("sfx_Num_bomb","slay")

func check_for_lower_value_bomb():
	if has_smaller_id_numeric_bomb():
		lower_value_bomb_exists.emit()
	else:
		no_lower_value_bomb_exists.emit()

func has_smaller_id_numeric_bomb():
	for bomb: NumericBomb in get_tree().get_nodes_in_group("group_numeric_bomb"):
		if bomb.id < id:
			return true
	return false
