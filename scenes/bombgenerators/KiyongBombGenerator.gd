extends BombGenerator

func _ready():
	await get_tree().create_timer(3.0).timeout
	
	pattern4()
	await get_tree().create_timer(5.0).timeout
	pattern2()
	await get_tree().create_timer(5.0).timeout
	pattern3()
	await get_tree().create_timer(5.0).timeout
	pattern4()



func pattern1():
	create_hazard_bomb(Vector2(-80, 80), 1, 3)
	create_hazard_bomb(Vector2(80, -80), 1, 3)
	create_hazard_bomb(Vector2(-160, 160), 1, 3)
	create_hazard_bomb(Vector2(160, -160), 1, 3)
	create_normal_bomb(Vector2(0, 0), 1, 3)


func pattern2():
	create_normal_bomb(Vector2(0, 100), 1, 3)
	create_hazard_bomb(Vector2(100, 100), 1, 3)
	create_hazard_bomb(Vector2(-100, 100), 1, 3)
	create_hazard_bomb(Vector2(0, 0), 1, 3)


func pattern3():
	create_hazard_bomb(Vector2(-100, -100), 1, 3)
	create_hazard_bomb(Vector2(-130, -80), 1, 3)
	create_hazard_bomb(Vector2(-80, -130), 1, 3)
	create_normal_bomb(Vector2(-160, -160), 1, 3)


func pattern4():
	create_numeric_bomb(Vector2(0, 250), 1, 3, 1)
	create_numeric_bomb(Vector2(-60, -220), 1, 3, 2)
	create_numeric_bomb(Vector2(220, 60), 1, 3, 3)
	create_numeric_bomb(Vector2(-220, 60), 1, 3, 4)
	create_numeric_bomb(Vector2(60, -220), 1, 3, 5)
