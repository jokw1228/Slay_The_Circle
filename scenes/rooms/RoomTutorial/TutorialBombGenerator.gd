extends BombGenerator
class_name TutorialBombGenerator

signal tutorial_end

var pattern_1_count_value: int

func _ready():
	
	await get_tree().create_timer(1.0).timeout
	
	pattern_1_start()

func pattern_1_start():
	pattern_1_count_value = 0
	
	var inst1: NormalBomb = create_normal_bomb(Vector2(-128, 0), 1.0, 5.0)
	var inst2: NormalBomb = create_normal_bomb(Vector2(128, 0), 1.0, 5.0)
	
	inst1.get_node("BombTimer").disconnect("bomb_timeout", Callable(inst1, "game_over"))
	inst2.get_node("BombTimer").disconnect("bomb_timeout", Callable(inst2, "game_over"))
	
	inst1.get_node("BombTimer").connect("bomb_timeout", Callable(self, "pattern_1_fail"))
	inst2.get_node("BombTimer").connect("bomb_timeout", Callable(self, "pattern_1_fail"))
	
	inst1.connect("player_body_entered", Callable(self, "pattern_1_count"))
	inst2.connect("player_body_entered", Callable(self, "pattern_1_count"))
	
func pattern_1_fail():
	if pattern_1_count_value != -1:
		pattern_1_count_value = -1
		await get_tree().create_timer(1.0).timeout
		pattern_1_start()

func pattern_1_count():
	pattern_1_count_value += 1
	if pattern_1_count_value == 2:
		pattern_1_clear()

func pattern_1_clear():
	tutorial_end.emit()
