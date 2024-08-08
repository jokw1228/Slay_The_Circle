extends Bomb
class_name NumericBomb

signal lower_value_bomb_exists
signal no_lower_value_bomb_exists

var id = 0

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
