extends BombGenerator
class_name TutorialBombGenerator

func pattern_1():
	var inst1: NormalBomb = create_normal_bomb(Vector2(-128, 0), 1.0, 5.0)
	var inst2: NormalBomb = create_normal_bomb(Vector2(128, 0), 1.0, 5.0)
	
	inst1.get_node("BombTimer").disconnect("bomb_timeout", Callable(inst1, "game_over"))
	inst2.get_node("BombTimer").disconnect("bomb_timeout", Callable(inst2, "game_over"))
