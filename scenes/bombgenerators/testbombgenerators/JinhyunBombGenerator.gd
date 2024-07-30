extends BombGenerator

func _ready():
	await get_tree().create_timer(3.0).timeout
	
	#pattern_smile_face()
	#await get_tree().create_timer(5.5).timeout
	#
	#pattern_angry_face()
	#await get_tree().create_timer(5.5).timeout
	
	pattern_numeric(12)
	await get_tree().create_timer(5.5).timeout
	
	pattern_spiral()
	await get_tree().create_timer(6).timeout
	
	pattern_blocking()
	await get_tree().create_timer(5.5).timeout
	
	pattern_blocking()
	await get_tree().create_timer(5.5).timeout
	
	pattern_rotation()
	await  get_tree().create_timer(5.5).timeout


func pattern_smile_face():
	create_normal_bomb(Vector2(-148, -123), 2, 3)
	create_normal_bomb(Vector2(-194, -62), 2, 3)
	create_normal_bomb(Vector2(-71, -65), 2, 3)
	
	create_normal_bomb(Vector2(76, -67), 2, 3)
	create_normal_bomb(Vector2(124, -114), 2, 3)
	create_normal_bomb(Vector2(182, -54), 2, 3)
	
	create_hazard_bomb(Vector2(-199, 95), 2, 3)
	create_hazard_bomb(Vector2(-140, 161), 2, 3)
	create_hazard_bomb(Vector2(-60, 208), 2, 3)
	create_hazard_bomb(Vector2(28, 208), 2, 3)
	create_hazard_bomb(Vector2(109, 179), 2, 3)
	create_hazard_bomb(Vector2(158, 122), 2, 3)
	create_hazard_bomb(Vector2(193, 78), 2, 3)

func pattern_angry_face():
	create_normal_bomb(Vector2(-176, -152), 2, 3)
	create_normal_bomb(Vector2(-102, -101), 2, 3)
	
	create_normal_bomb(Vector2(105, -106), 2, 3)
	create_normal_bomb(Vector2(185, -149), 2, 3)
	
	create_hazard_bomb(Vector2(-192, 145), 2, 3)
	create_hazard_bomb(Vector2(-135, 108), 2, 3)
	create_hazard_bomb(Vector2(-59, 95), 2, 3)
	create_hazard_bomb(Vector2(14, 94), 2, 3)
	create_hazard_bomb(Vector2(97, 112), 2, 3)
	create_hazard_bomb(Vector2(172, 147), 2, 3)

func pattern_numeric(num: int):
	var player_position: Vector2 = PlayingFieldInterface.get_player_position()
	var rotation_box: Array = [PI/2, PI, -PI/2, 0]
	
	for i in range(num):
		create_numeric_bomb(player_position.rotated(rotation_box[i%4]) * 0.8, 0.3, 1, i+1)
		await get_tree().create_timer(0.3).timeout

func pattern_numeric_inv(num: int):
	var player_position: Vector2 = PlayingFieldInterface.get_player_position()
	var rotation_box: Array = [-PI/2, PI, PI/2, 0]
	
	for i in range(num):
		create_numeric_bomb(player_position.rotated(rotation_box[i%4]) * 0.8, 0.3, 1, i+1)
		await get_tree().create_timer(0.3).timeout

func pattern_spiral():
	var init_position: Vector2 = Vector2.UP
	
	for i in range(16):
		create_normal_bomb(init_position.rotated(i*PI/3) * (i+1) * 14, 0.3, 3)
		await  get_tree().create_timer(0.2).timeout

func pattern_blocking():
	var player_position: Vector2 = PlayingFieldInterface.get_player_position()
	
	for i in range(5):
		create_hazard_bomb(player_position.rotated((i-2)*PI/6) * 0.6, 0.5, 4)
	
	var bomb1 = create_normal_bomb(player_position.rotated(PI/3) * -0.6, 0.3, 3)
	var bomb2 = create_normal_bomb(player_position.rotated(-PI/3) * -0.6, 0.3, 3)
	create_bomb_link(bomb1, bomb2)

func pattern_rotation():
	var player_position: Vector2 = PlayingFieldInterface.get_player_position()
	
	var bomb1 = create_rotationspeedup_bomb(Vector2(0, 0), 0.5, 1, 4*PI)
	await bomb1.tree_exited
	
	await  get_tree().create_timer(0.2).timeout
	PlayingFieldInterface.rotation_stop()
	for i in range(10):
		bomb1 = create_rotationspeedup_bomb(Vector2(0, 0), 0.5, 1, 4*PI)
		await bomb1.tree_exited
		
		await  get_tree().create_timer(0.2).timeout
		PlayingFieldInterface.rotation_stop()
