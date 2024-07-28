extends BombGenerator
class_name TutorialBombGenerator

func pattern_1():
	var inst1: NormalBomb = create_normal_bomb(Vector2(-128, 0), 1.0, 5.0)
	var inst2: NormalBomb = create_normal_bomb(Vector2(128, 0), 1.0, 5.0)
	
	inst1.get_node("BombTimer").disconnect("bomb_time_out", Callable(inst1, "exploded"))
	inst2.get_node("BombTimer").disconnect("bomb_time_out", Callable(inst2, "exploded"))
	
	inst1.get_node("BombTimer").connect("bomb_time_out", Callable(inst1, "queue_free"))
	inst2.get_node("BombTimer").connect("bomb_time_out", Callable(inst2, "queue_free"))
