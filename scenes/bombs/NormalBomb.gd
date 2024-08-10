extends Bomb
class_name NormalBomb

const NormalBomb_scene = "res://scenes/bombs/NormalBomb.tscn"
const NormalBombWarning_scene = "res://scenes/warnings/NormalBombWarning.tscn"

static func create(position_to_set: Vector2, time_to_set: float, warning_time_to_set: float) -> NormalBomb:
	var bomb_inst: NormalBomb = preload(NormalBomb_scene).instantiate() as NormalBomb
	bomb_inst.position = position_to_set
	bomb_inst.get_node("BombTimer").set_time = time_to_set
	var warning_inst: Warning = preload("res://scenes/warnings/NormalBombWarning.tscn").instantiate() as Warning
	bomb_inst.add_child(warning_inst)
	return bomb_inst

func slayed():
	super()
	
	SoundManager.play("sfx_Nor_bomb","slay")
