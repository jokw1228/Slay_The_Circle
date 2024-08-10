extends BombGenerator
class_name CirclerBombGenerator

var pattern_list: Array[Callable]

var pattern_start_time: float

func _ready():
	pattern_list_initialization()
	
	await Utils.timer(1.0) # game start time offset
	
	pattern_shuffle_and_draw()

func pattern_list_initialization():
	pattern_list.append(Callable(self, "pattern_lightning"))
	pattern_list.append(Callable(self, "pattern_wall_timing"))
	pattern_list.append(Callable(self, "pattern_scattered_hazards"))
	pattern_list.append(Callable(self, "pattern_random_shape"))
	pattern_list.append(Callable(self, "pattern_random_rotation"))
	pattern_list.append(Callable(self, "pattern_blocking"))
	pattern_list.append(Callable(self, "pattern_maze"))
	pattern_list.append(Callable(self, "pattern_reactspeed_test")) 
	pattern_list.append(Callable(self, "pattern_link_free")) 

func pattern_shuffle_and_draw():
	randomize()
	var random_index: int = randi() % pattern_list.size()
	pattern_list[random_index].call()

###############################
# pattern_lightning block start
# made by jooyoung

func pattern_lightning():
	var player_position: Vector2 = PlayingFieldInterface.get_player_position()
	var player_angle: float = player_position.angle()
	
	var node: Array[Node2D] = [Node2D.new(),Node2D.new(),Node2D.new(),Node2D.new(),Node2D.new()]
	var direction: Array[int] = [1,-1,1,-1,1]
	var tween_lightning: Tween
	for i in range(5):
		tween_lightning = get_tree().create_tween().set_ease(Tween.EASE_OUT_IN).set_trans(Tween.TRANS_CUBIC)
		add_child(node[i])
		Utils.attach_node(node[i], create_numeric_bomb(node[i].global_position, 0.5,1,i+1))
		node[i].position = Vector2(96 * (2-i) * cos(player_angle), 96 * (2-i) * sin(player_angle))
		tween_lightning.tween_property(node[i],"position",Vector2(-node[i].position.x,node[i].position.y),1)
	
	await Utils.timer(2.5)
	pattern_shuffle_and_draw()

#pattern_lightning end
###############################

###############################
# pattern_wall_timing start
# made by Jaeyong

func pattern_wall_timing():
	var left_bomb = 4
	
	var player_pos_normalized = PlayingFieldInterface.get_player_position().normalized()
	if (player_pos_normalized == Vector2(0,0)):
		player_pos_normalized = Vector2(1,0)
	
	create_normal_bomb(player_pos_normalized * 256 * -0.6 + Vector2(randf_range(0,80),randf_range(0, 40)), 0.25, 2.75)
	create_normal_bomb(player_pos_normalized * 256 * -0.6 + Vector2(randf_range(-80,0),randf_range(-40,0)), 0.25, 2.75)
	
	create_normal_bomb(player_pos_normalized * 256 * 0.6 + Vector2(randf_range(0,80),randf_range(0, 40)), 0.25, 2.75)
	create_normal_bomb(player_pos_normalized * 256 * 0.6 + Vector2(randf_range(-80,0),randf_range(-40,0)), 0.25, 2.75)
	
	
	create_hazard_bomb(Vector2(0,0), 0.5, 0.5)
	for i in (6):
		create_hazard_bomb(player_pos_normalized.rotated(PI/2) * 256 * i/6, 0.5, 0.5)
		create_hazard_bomb(player_pos_normalized.rotated(PI/2) * 256 * -i/6, 0.5, 0.5)
		
	await get_tree().create_timer(1).timeout
	
	create_hazard_bomb(Vector2(0,0), 0.5, 0.5)
	for i in (6):
		create_hazard_bomb(player_pos_normalized.rotated(PI/2) * 256 * i/6, 0.5, 0.5)
		create_hazard_bomb(player_pos_normalized.rotated(PI/2) * 256 * -i/6, 0.5, 0.5)
	
	await get_tree().create_timer(1).timeout
	
	create_hazard_bomb(Vector2(0,0), 0.5, 0.5)
	for i in (6):
		create_hazard_bomb(player_pos_normalized.rotated(PI/2) * 256 * i/6, 0.5, 0.5)
		create_hazard_bomb(player_pos_normalized.rotated(PI/2) * 256 * -i/6, 0.5, 0.5)

	await Utils.timer(1) # do nothing
	pattern_shuffle_and_draw()

# pattern_wall_timing block end
###############################

###############################
# pattern_scattered_hazards start
# made by Jaeyong

func pattern_scattered_hazards():
	var left_bomb = 3
	
	var player_pos_normalized = PlayingFieldInterface.get_player_position().normalized()
	if (player_pos_normalized == Vector2(0,0)):
		player_pos_normalized = Vector2(1,0)
	
	for i in (8):
		create_hazard_bomb(player_pos_normalized.rotated(PI/4 * i).rotated(PI/4) * 240 ,1,2)
	
	for i in (3):
		create_normal_bomb(player_pos_normalized.rotated(PI/3 * i * 2) * 80 ,0.5,2.5)

	await Utils.timer(3) # do nothing
	pattern_shuffle_and_draw()

# pattern_scattered_hazards block end
###############################

###############################
# pattern_random_shape block start
# made by kiyong

func pattern_random_shape():
	PlayingFieldInterface.set_theme_color(Color.AQUAMARINE)
	var prev_value
	const pattern_time = 0.9
	
	create_normal_bomb(Vector2(0,0), 0, pattern_time)
	var randomrotation = randf_range(0, 2*PI)
	pattern_random_shape_random(0, randomrotation)
	await Utils.timer(pattern_time)
	
	create_normal_bomb(Vector2(0,0), 0, pattern_time)
	randomrotation = randf_range(0, 2*PI)
	pattern_random_shape_random(3, randomrotation)
	await Utils.timer(pattern_time)
	
	create_normal_bomb(Vector2(0,0), 0, pattern_time)
	randomrotation = randf_range(0, 2*PI)
	pattern_random_shape_random(2, randomrotation)
	await Utils.timer(pattern_time)
	
	pattern_shuffle_and_draw()

func pattern_random_shape_random(pattern: int, randomrotation: float):
	const pattern_time = 0.7
	match pattern:
		0: # cross
			for i in range(1, 4):
				create_hazard_bomb(Vector2(256/3*i,0).rotated(randomrotation), pattern_time, 0.1)
				create_hazard_bomb(Vector2(-256/3*i,0).rotated(randomrotation), pattern_time, 0.1)
				create_hazard_bomb(Vector2(0,256/3*i).rotated(randomrotation), pattern_time, 0.1)
				create_hazard_bomb(Vector2(0,-256/3*i).rotated(randomrotation), pattern_time, 0.1)
		#1: # outer circle
		#	var rotation_value = 0
		#	for i in range(16):
		#		create_hazard_bomb(Vector2(256*sin(rotation_value), 256*cos(rotation_value)), 1, 0.05)
		#		rotation_value += PI / 8
		1: # x
			for i in range(1, 4):
				create_hazard_bomb(Vector2(256/3*i,0).rotated(randomrotation+PI/4), pattern_time, 0.1)
				create_hazard_bomb(Vector2(-256/3*i,0).rotated(randomrotation+PI/4), pattern_time, 0.1)
				create_hazard_bomb(Vector2(0,256/3*i).rotated(randomrotation+PI/4), pattern_time, 0.1)
				create_hazard_bomb(Vector2(0,-256/3*i).rotated(randomrotation+PI/4), pattern_time, 0.1)
		2: # *
			pattern_random_shape_random(0, randomrotation)
			pattern_random_shape_random(1, randomrotation)
		#3: # diamond
		#	var x = [150,75,75,0,0,-75,-75,-150]
		#	var y = [0,75,-75,150,-150,75,-75,0]
		#	for i in range(8):
		#		create_hazard_bomb(Vector2(x[i],y[i]).rotated(randomrotation), pattern_time, 0.1)
		3: # star
			var rotation_value = 0
			const inner_pentagon = 256 * tan(PI*3/20) / (tan(PI*1/5) + tan(PI*3/20)) / cos(PI/10)
			const outer_pentagon = sqrt(pow(256 - (256 * tan(PI*1/5) / (tan(PI*1/5) + tan(PI*3/20))) / 2, 2) + pow((inner_pentagon * sin(PI/10) / 2), 2))
			const outer_pentagon_angle = asin((inner_pentagon * sin(PI/10) / 2) / outer_pentagon)
			for i in range(5):
				create_hazard_bomb(Vector2(256*sin(rotation_value), 256*cos(rotation_value)).rotated(randomrotation), pattern_time, 0.1)
				create_hazard_bomb(Vector2(outer_pentagon*sin(rotation_value+outer_pentagon_angle), outer_pentagon*cos(rotation_value+outer_pentagon_angle)).rotated(randomrotation), pattern_time, 0.1)
				create_hazard_bomb(Vector2(outer_pentagon*sin(rotation_value-outer_pentagon_angle), outer_pentagon*cos(rotation_value-outer_pentagon_angle)).rotated(randomrotation), pattern_time, 0.1)
				rotation_value += PI / 2.5
			rotation_value = PI / 5
			for i in range(5):
				create_hazard_bomb(Vector2(90*sin(rotation_value), 90*cos(rotation_value)).rotated(randomrotation), pattern_time, 0.1)
				rotation_value += PI / 2.5

# pattern_random_shape block end
###############################

###############################
# pattern_random_rotation block start
# made by jinhyun

var pattern_random_rotation_timer: float
var pattern_random_rotation_timer_tween: Tween

func pattern_random_rotation():
	PlayingFieldInterface.set_theme_color(Color.VIOLET)
	
	pattern_random_rotation_timer = 2.0
	if pattern_random_rotation_timer_tween != null:
		pattern_random_rotation_timer_tween.kill()
	pattern_random_rotation_timer_tween = get_tree().create_tween()
	pattern_random_rotation_timer_tween.tween_property(self,"pattern_random_rotation_timer",0.0,2.0)
	
	var player_position: Vector2
	var rand: int
	var bomb1: Bomb
	
	randomize()
	player_position = PlayingFieldInterface.get_player_position()
	rand = randi() % 2
	if rand == 0:
		bomb1 = create_rotationspeedup_bomb(player_position.rotated(PI/2) * 0.6, 0.2, 0.8, 4*PI)
		await bomb1.tree_exited
		
		if is_inside_tree():
			await get_tree().create_timer(0.2).timeout
		PlayingFieldInterface.rotation_stop()
	else:
		bomb1 = create_rotationspeedup_bomb(player_position.rotated(-PI/2) * 0.6, 0.2, 0.8, 4*PI)
		await bomb1.tree_exited
		
		if is_inside_tree():
			await get_tree().create_timer(0.2).timeout
		PlayingFieldInterface.rotation_stop()
	
	for i in range(5):
		player_position = PlayingFieldInterface.get_player_position()
		rand = randi() % 3
		if rand == 0:
			bomb1 = create_rotationspeedup_bomb(player_position.rotated(PI/2) * 0.6, 0.2, 0.5, 4*PI)
			await bomb1.tree_exited
			
			if is_inside_tree():
				await get_tree().create_timer(0.2).timeout
			PlayingFieldInterface.rotation_stop()
		elif rand == 1:
			bomb1 = create_rotationspeedup_bomb(player_position * -0.6, 0.2, 0.5, 4*PI)
			await bomb1.tree_exited
			
			if is_inside_tree():
				await get_tree().create_timer(0.2).timeout
			PlayingFieldInterface.rotation_stop()
		else:
			bomb1 = create_rotationspeedup_bomb(player_position.rotated(-PI/2) * 0.6, 0.2, 0.5, 4*PI)
			await bomb1.tree_exited
			
			if is_inside_tree():
				await get_tree().create_timer(0.2).timeout
			PlayingFieldInterface.rotation_stop()
	
	if is_inside_tree():
		await get_tree().create_timer(0.5).timeout
	var bomb = create_normal_bomb(Vector2(0, 0), 0.3, 3)
	bomb.connect("player_body_entered",Callable(self,"pattern_random_rotation_end"))

func pattern_random_rotation_end():
	PlayingFieldInterface.add_playing_time(pattern_random_rotation_timer)
	pattern_shuffle_and_draw()
	
# pattern_random_rotation end
###############################

###############################
# pattern_blocking block start
# made by jinhyun

const pattern_blocking_playing_time = 2.3

func pattern_blocking():
	PlayingFieldInterface.set_theme_color(Color.VIOLET)
	pattern_start_time = PlayingFieldInterface.get_playing_time()
	
	var player_position: Vector2 = PlayingFieldInterface.get_player_position()
	
	for i in range(9):
		create_hazard_bomb(player_position.rotated((i-4)*PI/8) * 0.6, 0.2, 2)
	
	var bomb1 = create_normal_bomb(player_position.rotated(3.0*PI/4.0) * 0.6, 0.1, 2)
	var bomb2 = create_normal_bomb(player_position.rotated(-3.0*PI/4.0) * 0.6, 0.1, 2)
	var link = create_bomb_link(bomb1, bomb2)
	
	link.connect("both_bombs_removed", Callable(self, "pattern_blocking_end"))

func pattern_blocking_end():
	get_tree().call_group("group_hazard_bomb", "early_eliminate")
	PlayingFieldInterface.set_playing_time(pattern_start_time + (pattern_blocking_playing_time) / Engine.time_scale)
	pattern_shuffle_and_draw()
	
# pattern_blocking end
###############################

###############################
# pattern_maze block start
# made by jinhyun

const pattern_maze_playing_time = 2.5

func pattern_maze():
	PlayingFieldInterface.set_theme_color(Color.VIOLET)
	pattern_start_time = PlayingFieldInterface.get_playing_time()
	
	var player_position: Vector2 = PlayingFieldInterface.get_player_position()
	var player_mul =  player_position * 0.35
	var magnitude = player_mul.length()
	var perpendicular = Vector2(-player_mul.y / magnitude, player_mul.x / magnitude)
	
	for i in range(5):
		create_hazard_bomb(player_mul + perpendicular * (i-3.1) * 64, 0.1, 2.3)
		create_hazard_bomb(-(player_mul + perpendicular * (i-3.1) * 64), 0.1, 2.3)
	
	var bomb = create_normal_bomb(-player_position * 0.8, 0.1, 2.3)
	bomb.connect("player_body_entered", Callable(self, "pattern_maze_end"))

func pattern_maze_end():
	get_tree().call_group("group_hazard_bomb", "early_eliminate")
	await PlayingFieldInterface.player_grounded
	PlayingFieldInterface.set_playing_time(pattern_start_time + (pattern_maze_playing_time) / Engine.time_scale)
	pattern_shuffle_and_draw()
	
# pattern_maze end
###############################

###############################
# pattern_reactspeed_test block start
# made by seokhee

#반응속도 테스트
#핸드폰으로 하면 circler 정도일듯 

var pattern_reactspeed_test_timer : float
var pattern_reactspeed_test_timer_tween : Tween
var num_id : int = 0

func pattern_reactspeed_test():
	PlayingFieldInterface.set_theme_color(Color.BISQUE)
	
	pattern_reactspeed_test_timer = 7.0
	
	if pattern_reactspeed_test_timer_tween != null:
		pattern_reactspeed_test_timer_tween.kill()
	pattern_reactspeed_test_timer_tween = get_tree().create_tween()
	pattern_reactspeed_test_timer_tween.tween_property(self, "pattern_reactspeed_test_timer", 0.0, 10.5)
	
	var num_rng = RandomNumberGenerator.new()
	num_rng.randomize()
	var my_array = []
	
	var pos_rng = RandomNumberGenerator.new()
	pos_rng.randomize()
	
	
	for i in range(10):  
		var random_value = num_rng.randi_range(0, 2)
		my_array.append(random_value)
	for i in range(my_array.size()):
		var value = my_array[i]
		var random_pos_value = pos_rng.randi_range(0, 200)
		match value:
			0:
				make_random_bomb(0, i, random_pos_value)
			1:
				make_random_bomb(1, i, random_pos_value)
			2:
				make_random_bomb(2, i, random_pos_value)
				num_id+=1
		await Utils.timer(0.3)
	await Utils.timer(1.1)
	pattern_shuffle_and_draw()
func make_random_bomb(num, cnt, pos):
	if num == 0:
		var bomb : NormalBomb = create_normal_bomb(Vector2(pos * pow(-1, cnt + 1), pos * pow(-1, cnt)), 0.7, 0.7)
	if num == 1:
		var bomb : HazardBomb = create_hazard_bomb(Vector2(pos * pow(-1, cnt + 1), pos * pow(-1, cnt)), 0.7, 0.7)
	if num == 2:
		var bomb : NumericBomb = create_numeric_bomb(Vector2(pos * pow(-1, cnt + 1), pos * pow(-1, cnt)), 0.7, 0.7, num_id)
	
	

func pattern_reactspeed_test_end():
	PlayingFieldInterface.add_playing_time(pattern_reactspeed_test_timer)
	pattern_shuffle_and_draw()
	
#pattern_reactspeed_test block end
###############################

###############################
# pattern_link_free block start
# made by seokhee

#링크를 구하기 위해선 기다림도 필요한 법..
#컴퓨터 기준으로 개어려워서 circlest 정도일 듯

var pattern_link_free_timer : float
var pattern_link_free_timer_tween : Tween

func pattern_link_free():
	PlayingFieldInterface.set_theme_color(Color.BISQUE)
	
	pattern_link_free_timer = 6.0
	
	if pattern_link_free_timer_tween != null:
		pattern_link_free_timer_tween.kill()
	pattern_link_free_timer_tween = get_tree().create_tween()
	pattern_link_free_timer_tween.tween_property(self, "pattern_link_free_timer", 0.0, 6.0)
	
	var bomb1: NormalBomb = create_normal_bomb(Vector2(133, -100), 1.5, 3.0)
	var bomb2: NormalBomb = create_normal_bomb(Vector2(133, 100), 1.5, 3.0)
	
	create_bomb_link(bomb1, bomb2)
	
	var bomb3: HazardBomb = create_hazard_bomb(Vector2(0, -100), 0.5, 4.5)
	var bomb4: HazardBomb = create_hazard_bomb(Vector2(0, 0), 0.5, 4.5)
	var bomb5: HazardBomb = create_hazard_bomb(Vector2(0, 100), 0.5, 4.5)
	
	var bomb6: NormalBomb = create_normal_bomb(Vector2(70,-200), 1.5, 3.0)
	var bomb7: NormalBomb = create_normal_bomb(Vector2(-70, -200), 1.5, 3.0)
	
	create_bomb_link(bomb6, bomb7)
	
	var bomb8: NormalBomb = create_normal_bomb(Vector2(-133, -100), 1.5, 3.0)
	var bomb9: NormalBomb = create_normal_bomb(Vector2(-133, 100), 1.5, 3.0)
	
	create_bomb_link(bomb8, bomb9)
	
	var bomb10: NormalBomb = create_normal_bomb(Vector2(70, 200), 1.5, 3.0)
	var bomb11: NormalBomb = create_normal_bomb(Vector2(-70, 200), 1.5, 3.0)
	
	create_bomb_link(bomb10, bomb11)
	
	var bomb_main_link_1: NumericBomb = create_numeric_bomb(Vector2(-170, 0), 5.0, 1.0, 1)
	var bomb_main_link_2: NumericBomb = create_numeric_bomb(Vector2(170, 0), 5.0, 1.0, 2)
	
	await Utils.timer(6.0)
	pattern_shuffle_and_draw()
	
	#var bomb4: RotationSpeedUpBomb = create_rotationspeedup_bomb(Vector2(-256, 0), 0.5, 1.8, 0.3)
	#var bomb5: RotationSpeedUpBomb = create_rotationspeedup_bomb(Vector2(0, 0), 0.5, 1.8, 0.3)

func pattern_link_free_end():
	PlayingFieldInterface.add_playing_time(pattern_link_free_timer)
	pattern_shuffle_and_draw()
	
#pattern_link_free block end
###############################
