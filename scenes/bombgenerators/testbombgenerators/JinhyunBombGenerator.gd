extends BombGenerator

func _ready():
	await get_tree().create_timer(3.0).timeout
	await pattern_numeric(5)
	#await pattern_spiral()
	await pattern_blocking()
	await pattern_blocking()
	await pattern_rotation(6)
	await pattern_timing()
	await simple_effect()

func pattern_numeric(num: int):
	var player_position: Vector2 = PlayingFieldInterface.get_player_position()
	var rotation_box: Array = [PI/2, PI, -PI/2, 0]
	
	for i in range(num):
		create_numeric_bomb(player_position.rotated(rotation_box[i%4]) * 0.8, 0.3, 1, i+1)
		await get_tree().create_timer(0.3).timeout
	
	var last_bomb = create_normal_bomb(player_position, 0, 1)
	await last_bomb.tree_exited
	return true

func pattern_numeric_inv(num: int):
	var player_position: Vector2 = PlayingFieldInterface.get_player_position()
	var rotation_box: Array[float] = [-PI/2, PI, PI/2, 0]
	
	for i in range(num):
		create_numeric_bomb(player_position.rotated(rotation_box[i%4]) * 0.8, 0.3, 1, i+1)
		await get_tree().create_timer(0.3).timeout
	
	player_position = PlayingFieldInterface.get_player_position()
	var last_bomb = create_normal_bomb(player_position, 0, 1)
	await last_bomb.tree_exited
	return true

func pattern_spiral():
	var init_position: Vector2 = Vector2.UP
	
	for i in range(16):
		create_normal_bomb(init_position.rotated(i*PI/3) * (i+1) * 14, 0.3, 3)
		await get_tree().create_timer(0.2).timeout
	
	var last_bomb = create_normal_bomb(Vector2(0,0), 0.5, 2)
	await last_bomb.tree_exited
	return true

func pattern_blocking():
	var player_position: Vector2 = PlayingFieldInterface.get_player_position()
	
	for i in range(5):
		create_hazard_bomb(player_position.rotated((i-2)*PI/6) * 0.6, 0.5, 4)
	
	var bomb1 = create_normal_bomb(player_position.rotated(PI/3) * -0.6, 0.3, 3)
	var bomb2 = create_normal_bomb(player_position.rotated(-PI/3) * -0.6, 0.3, 3)
	create_bomb_link(bomb1, bomb2)
	
	player_position = PlayingFieldInterface.get_player_position()
	var last_bomb = create_normal_bomb(player_position, 0, 1)
	await last_bomb.tree_exited
	return true

func pattern_rotation(num: int):
	var player_position: Vector2
	var rand: int
	var bomb1: Bomb
	
	for i in range(num):
		player_position = PlayingFieldInterface.get_player_position()
		rand = randi() % 2
		if rand == 0:
			bomb1 = create_rotationspeedup_bomb(player_position.rotated(PI/2) * 0.6, 0.5, 1, 4*PI)
			await bomb1.tree_exited
			
			await get_tree().create_timer(0.3).timeout
			PlayingFieldInterface.rotation_stop()
		else:
			bomb1 = create_rotationspeedup_bomb(player_position.rotated(-PI/2) * 0.6, 0.5, 1, 4*PI)
			await bomb1.tree_exited
			
			await get_tree().create_timer(0.3).timeout
			PlayingFieldInterface.rotation_stop()
	
	player_position = PlayingFieldInterface.get_player_position()
	var last_bomb = create_hazard_bomb(player_position.rotated(-PI/2) * 0.6, 0.5, 1)
	await last_bomb.tree_exited
	return true

func pattern_timing():
	var player_position: Vector2
	player_position = PlayingFieldInterface.get_player_position()
	
	create_hazard_bomb(player_position.rotated(PI/3) * 0.7, 0.5, 0.5)
	create_hazard_bomb(player_position.rotated(PI/2) * 0.7, 0.5, 1)
	create_hazard_bomb(player_position.rotated(2*PI/3) * 0.7, 0.5, 1.5)
	
	create_normal_bomb(Vector2(0, 0), 0.5, 1.8)
	create_hazard_bomb(Vector2(0, 0), 0.5, 1.6)
	
	var lasting= get_tree().create_timer(2.5)
	
	while lasting.time_left > 0:
		if player_position != PlayingFieldInterface.get_player_position():
			player_position = PlayingFieldInterface.get_player_position()
			
			await get_tree().create_timer(0.05).timeout
			for i in range(7):
				create_normal_bomb(player_position * 0.3 * (i-3), 0.2, 1 - i*0.05)
				await get_tree().create_timer(0.07).timeout
		await get_tree().create_timer(0.02).timeout
	
	player_position = PlayingFieldInterface.get_player_position()
	var last_bomb = create_normal_bomb(player_position, 0, 1)
	await last_bomb.tree_exited
	return true

func simple_effect():
	var player_position: Vector2
	var lasting = get_tree().create_timer(2.5)
	
	while lasting.time_left > 0:
		await get_tree().create_timer(0.05).timeout
		player_position = PlayingFieldInterface.get_player_position()
		create_normal_bomb(player_position, 0, 1)
	
	player_position = PlayingFieldInterface.get_player_position()
	var last_bomb = create_normal_bomb(player_position, 0, 1)
	await last_bomb.tree_exited
	return true
