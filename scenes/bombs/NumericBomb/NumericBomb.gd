extends Bomb
class_name NumericBomb

signal lower_value_bomb_exists
signal no_lower_value_bomb_exists

var id: int = 0

@export var CollisionShape2D_node: CollisionShape2D
@export var BombTimer_node: BombTimer
@export var WarningTimer_node: WarningTimer
@export var Indicator_node: Indicator

static func create(position_to_set: Vector2, warning_time_to_set: float, bomb_time_to_set: float, id_to_set: int) -> NumericBomb:
	return NumericBomb_creator.create(position_to_set, warning_time_to_set, bomb_time_to_set, id_to_set)

func _on_warning_timer_warning_timeout():
	modulate.a = 1.0
	CollisionShape2D_node.disabled = false

func _ready():
	$BombID.text = str(id)

func _process(_delta):
	var flag: bool = true
	for i: NumericBomb in get_tree().get_nodes_in_group("group_numeric_bomb"):
		if i.id < id:
			Indicator_node.visible = false
			flag = false
			break
	if flag == true:
		Indicator_node.visible = true

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
	
func exploded():
	SoundManager.play("sfx_Num_bomb","explosion")
	super()

