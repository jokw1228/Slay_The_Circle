extends BombGenerator

func _ready():
	await get_tree().create_timer(1.0).timeout
	
	#pattern_smile_face()
	#await get_tree().create_timer(5.5).timeout
	#
	#pattern_angry_face()
	#await get_tree().create_timer(5.5).timeout
	
	pattern_numeric()
	await get_tree().create_timer(5.5).timeout


func pattern_smile_face():
	var bomb1 = create_normal_bomb(Vector2(-194, -62), 2, 3)
	var bomb2 = create_normal_bomb(Vector2(-148, -123), 2, 3)
	var bomb3 = create_normal_bomb(Vector2(-71, -65), 2, 3)
	
	var bomb4 = create_normal_bomb(Vector2(76, -67), 2, 3)
	var bomb5 = create_normal_bomb(Vector2(124, -114), 2, 3)
	var bomb6 = create_normal_bomb(Vector2(182, -54), 2, 3)
	
	var bomb7 = create_hazard_bomb(Vector2(-199, 95), 2, 3)
	var bomb8 = create_hazard_bomb(Vector2(-140, 161), 2, 3)
	var bomb9 = create_hazard_bomb(Vector2(-60, 208), 2, 3)
	var bomb10 = create_hazard_bomb(Vector2(28, 208), 2, 3)
	var bomb11 = create_hazard_bomb(Vector2(109, 179), 2, 3)
	var bomb12 = create_hazard_bomb(Vector2(158, 122), 2, 3)
	var bomb13 = create_hazard_bomb(Vector2(193, 78), 2, 3)

func pattern_angry_face():
	var bomb1 = create_normal_bomb(Vector2(-176, -152), 2, 3)
	var bomb2 = create_normal_bomb(Vector2(-102, -101), 2, 3)
	
	var bomb3 = create_normal_bomb(Vector2(105, -106), 2, 3)
	var bomb4 = create_normal_bomb(Vector2(185, -149), 2, 3)
	
	var bomb5 = create_hazard_bomb(Vector2(-192, 145), 2, 3)
	var bomb6 = create_hazard_bomb(Vector2(-135, 108), 2, 3)
	var bomb7 = create_hazard_bomb(Vector2(-59, 95), 2, 3)
	var bomb8 = create_hazard_bomb(Vector2(14, 94), 2, 3)
	var bomb9 = create_hazard_bomb(Vector2(97, 112), 2, 3)
	var bomb10 = create_hazard_bomb(Vector2(172, 147), 2, 3)

func pattern_numeric():
	var bomb1 = create_numeric_bomb(Vector2(-182, 169), 0.5, 1.5, 1)
	await get_tree().create_timer(1.0).timeout
	
	var bomb2 = create_numeric_bomb(Vector2(180, 160), 0.5, 1.5, 2)
	await get_tree().create_timer(1.0).timeout
	
	var bomb3 = create_numeric_bomb(Vector2(15, -229), 0.5, 1.5, 3)
	await get_tree().create_timer(1.0).timeout
	
	var bomb4 = create_numeric_bomb(Vector2(-8, 229), 0.5, 1.5, 4)
	await get_tree().create_timer(1.0).timeout
