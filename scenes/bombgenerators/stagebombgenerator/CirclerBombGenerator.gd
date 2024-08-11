extends BombGenerator
class_name CirclerBombGenerator

var pattern_list: Array[Callable]

var pattern_start_time: float

func _ready():
	pattern_list_initialization()
	
	await Utils.timer(1.0) # game start time offset
	
	pattern_shuffle_and_draw()

func pattern_list_initialization():
	pattern_list.append(Callable(self, "pattern_wall_timing"))
	pattern_list.append(Callable(self, "pattern_scattered_hazards"))
	pattern_list.append(Callable(self, "pattern_random_shape"))
	pattern_list.append(Callable(self, "pattern_random_rotation"))
	pattern_list.append(Callable(self, "pattern_blocking"))
	pattern_list.append(Callable(self, "pattern_maze"))
	pattern_list.append(Callable(self, "pattern_reactspeed_test")) 
	pattern_list.append(Callable(self, "pattern_link_free"))
	pattern_list.append(Callable(self, "pattern_diamond_with_hazard_puzzled"))
	pattern_list.append(Callable(self, "pattern_pizza"))
	pattern_list.append(Callable(self, "pattern_narrow_road"))
	

func pattern_shuffle_and_draw():
	randomize()
	var random_index: int = randi() % pattern_list.size()
	pattern_list[random_index].call()

###############################
# pattern_wall_timing start
# made by Jaeyong
# get_tree().call_group("group_hazard_bomb", "early_eliminate")가 경고를 안제거해서 곤란합니다...ㅠㅠ

const pattern_wall_timing_playing_time = 3
var pattern_wall_timing_bomb_count: int
var pattern_wall_timing_pos_nor: Vector2
var pattern_wall_timing_angle: float
const pattern_wall_timing_bomb_dist = 136

func pattern_wall_timing():
	pattern_wall_timing_bomb_count = 4
	pattern_wall_timing_pos_nor = PlayingFieldInterface.get_player_position().normalized()
	if (pattern_wall_timing_pos_nor == Vector2(0,0)):
		pattern_wall_timing_pos_nor = Vector2(1,0)
	pattern_wall_timing_angle = pattern_wall_timing_pos_nor.angle()

	var bomb1 = create_normal_bomb(pattern_wall_timing_auto_rotate(PI /4), 0.25, 2.75)
	bomb1.connect("player_body_entered", Callable(self, "pattern_wall_timing_end"))
	var bomb2 = create_normal_bomb(pattern_wall_timing_auto_rotate(3 * PI / 2 + PI/4), 0.25, 2.75)
	bomb2.connect("player_body_entered", Callable(self, "pattern_wall_timing_end"))
	create_bomb_link(bomb1, bomb2)
		
	var bomb3 = create_normal_bomb(pattern_wall_timing_auto_rotate(PI + PI/4), 0.25, 2.75)
	bomb3.connect("player_body_entered", Callable(self, "pattern_wall_timing_end"))
	var bomb4 = create_normal_bomb(pattern_wall_timing_auto_rotate(PI/2 + PI/4), 0.25, 2.75)
	bomb4.connect("player_body_entered", Callable(self, "pattern_wall_timing_end"))
	create_bomb_link(bomb3, bomb4)
	
	create_hazard_bomb(Vector2(0,0), 0.5, 0.5)
	for i in (5):
		create_hazard_bomb(pattern_wall_timing_pos_nor.rotated(PI/2) * 256 * i/5, 0.5, 0.5)
		create_hazard_bomb(pattern_wall_timing_pos_nor.rotated(PI/2) * 256 * -i/5, 0.5, 0.5)
		
	create_hazard_bomb(Vector2(0,0), 1.5, 0.5)
	for i in (5):
		create_hazard_bomb(pattern_wall_timing_pos_nor.rotated(PI/2) * 256 * i/5, 1.5, 0.5)
		create_hazard_bomb(pattern_wall_timing_pos_nor.rotated(PI/2) * 256 * -i/5, 1.5, 0.5)
		
	create_hazard_bomb(Vector2(0,0), 2.5, 0.5)
	for i in (5):
		create_hazard_bomb(pattern_wall_timing_pos_nor.rotated(PI/2) * 256 * i/5, 2.5, 0.5)
		create_hazard_bomb(pattern_wall_timing_pos_nor.rotated(PI/2) * 256 * -i/5, 2.5, 0.5)

func pattern_wall_timing_end():
	pattern_wall_timing_bomb_count -= 1
	if pattern_wall_timing_bomb_count == 0:
		get_tree().call_group("group_hazard_bomb", "early_eliminate")
		await PlayingFieldInterface.player_grounded
		PlayingFieldInterface.set_playing_time(pattern_start_time + (pattern_wall_timing_playing_time) / Engine.time_scale)
		pattern_shuffle_and_draw()

func pattern_wall_timing_auto_rotate(angle):
	return Vector2(pattern_wall_timing_bomb_dist*cos(pattern_wall_timing_angle+angle),pattern_wall_timing_bomb_dist*sin(pattern_wall_timing_angle+angle))
	
# pattern_wall_timing block end
###############################

###############################
# pattern_scattered_hazards start
# made by Jaeyong
const pattern_scattered_hazards_playing_time = 2
var pattern_scattered_hazards_bomb_count: int

func pattern_scattered_hazards():
	var left_bomb = 3
	pattern_scattered_hazards_bomb_count = 3
	pattern_start_time = PlayingFieldInterface.get_playing_time()
	
	var player_pos_normalized = PlayingFieldInterface.get_player_position().normalized()
	if (player_pos_normalized == Vector2(0,0)):
		player_pos_normalized = Vector2(1,0)
	
	for i in (8):
		create_hazard_bomb(player_pos_normalized.rotated(PI/4 * i).rotated(3 * PI/8) * 224 ,0.25,1.75)
	
	for i in (3):
		var bomb: NormalBomb = create_normal_bomb(player_pos_normalized.rotated(PI/3 * i * 2).rotated(PI/4) * 84 ,0.5, 1.5)
		bomb.connect("player_body_entered", Callable(self, "pattern_scattered_hazards_end"))
	
func pattern_scattered_hazards_end():
	pattern_scattered_hazards_bomb_count -= 1
	if pattern_scattered_hazards_bomb_count == 0:
		get_tree().call_group("group_hazard_bomb", "early_eliminate")
		await PlayingFieldInterface.player_grounded
		PlayingFieldInterface.set_playing_time(pattern_start_time + (pattern_scattered_hazards_playing_time) / Engine.time_scale)
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

###############################
# pattern_numeric_diamond_with_hazard_puzzled block start
# made by Bae Sekang

const pattern_diamond_with_hazard_puzzled_playing_time = 3.0

func pattern_diamond_with_hazard_puzzled():
	PlayingFieldInterface.set_theme_color(Color.ORANGE)
	
	pattern_start_time = PlayingFieldInterface.get_playing_time()
	var player_position: Vector2 = PlayingFieldInterface.get_player_position()
	var player_angle: float = player_position.angle()
	var player_angle2: float = player_position.angle() * -1
	var bomb_radius = 64
	create_hazard_bomb(Vector2(0,0), 0.5, 2.5)
	create_numeric_bomb(Vector2(2*bomb_radius*cos(player_angle+4*PI/2),2*bomb_radius*sin(player_angle+4*PI/2)), 0.5, 2.5, 1)
	create_numeric_bomb(Vector2(2*bomb_radius*cos(player_angle+1*PI/2),2*bomb_radius*sin(player_angle+1*PI/2)), 0.5, 2.5, 3)
	create_numeric_bomb(Vector2(2*bomb_radius*cos(player_angle+2*PI/2),2*bomb_radius*sin(player_angle+2*PI/2)), 0.5, 2.5, 2)
	var bomb: NumericBomb = create_numeric_bomb(Vector2(2*bomb_radius*cos(player_angle+3*PI/2),2*bomb_radius*sin(player_angle+3*PI/2)), 0.5, 2.5, 4)
	bomb.connect("no_lower_value_bomb_exists", Callable(self, "pattern_diamond_with_hazard_puzzled_end"))

func pattern_diamond_with_hazard_puzzled_end():
	await PlayingFieldInterface.player_grounded
	PlayingFieldInterface.set_playing_time(pattern_start_time + (pattern_diamond_with_hazard_puzzled_playing_time) / Engine.time_scale)
	pattern_shuffle_and_draw()
	
# pattern_diamond_with_hazard_puzzled block end
###############################

###############################
# pattern_pizza block start
# made by Bae Sekang

var pattern_pizza_bomb_count = 27
const pattern_pizza_playing_time = 3

func pattern_pizza():
	PlayingFieldInterface.set_theme_color(Color.ORANGE)
	var player_position: Vector2 = PlayingFieldInterface.get_player_position()
	var player_angle: float = player_position.angle()
	var bomb_radius = 220
	
	
	create_hazard_bomb(Vector2(0,0), 0.5,2.5)
	create_normal_bomb(Vector2(64*cos(player_angle+4*PI/2),64*sin(player_angle+4*PI/2)),0.5,2.5)
	create_normal_bomb(Vector2(64*cos(player_angle+4*PI/3),64*sin(player_angle+4*PI/3)),0.5,2.5)
	create_normal_bomb(Vector2(64*cos(player_angle+2*PI/3),64*sin(player_angle+2*PI/3)),0.5,2.5)
	
	for i in range(1, 25):
		var bomb: NormalBomb = create_normal_bomb(Vector2(bomb_radius * cos(player_angle+i * PI/12.0), bomb_radius * sin(player_angle+i * PI/12.0)), 0.5,2.5)
		bomb.connect("player_body_entered",Callable(self,"pattern_pizza_end"))
	await Utils.timer(3.0)
	pattern_shuffle_and_draw()

func pattern_pizza_end():
	pattern_pizza_bomb_count -= 1
	if pattern_pizza_bomb_count == 0:
		await PlayingFieldInterface.player_grounded
		PlayingFieldInterface.set_playing_time(pattern_start_time + (pattern_pizza_playing_time) / Engine.time_scale)
		pattern_shuffle_and_draw()
	
# pattern_pizza block end
###############################

###############################
# pattern_narrow_road block start
# made by Bae Sekang

const pattern_narrow_road_playing_time = 3.0

func pattern_narrow_road():
	PlayingFieldInterface.set_theme_color(Color.ORANGE)
	
	pattern_start_time = PlayingFieldInterface.get_playing_time()
	var player_position: Vector2 = PlayingFieldInterface.get_player_position()
	var player_angle: float = player_position.angle()
	var hazard1_angle: float = player_position.angle()+1*PI/5
	var hazard2_angle: float = player_position.angle()-1*PI/5
	var bomb_radius = 64
	var length = 64
	var rng = RandomNumberGenerator.new()
	var rng2 = RandomNumberGenerator.new()
	var is_upsidedown = rng2.randi_range(1, 2)
	var is_wide_or_length = rng2.randi_range(1, 2)
	if is_upsidedown==2:
		is_upsidedown = -1
	if is_wide_or_length==2:
		is_wide_or_length = -1
	var bomb: NumericBomb
	var first_hazard1: HazardBomb = create_hazard_bomb(Vector2(64*cos(player_angle+4*PI/2+PI/5),64*sin(player_angle+4*PI/2+PI/5)),0.5,2.5)
	var first_hazard2: HazardBomb = create_hazard_bomb(Vector2(64*cos(player_angle+4*PI/2-PI/5),64*sin(player_angle+4*PI/2-PI/5)),0.5,2.5)
	
	for i in range(0,3,1):
		create_numeric_bomb(Vector2(64*i*cos(player_angle+4*PI/2),64*i*sin(player_angle+4*PI/2)),0.5,2.5,i+1)
		
	#for i in range(0,5,1):
		#create_hazard_bomb(Vector2(random_range_integer-80,is_upsidedown*(-100+50*i)), 0.5,2.5)
		#create_hazard_bomb(Vector2(random_range_integer+80,is_upsidedown*(-100+50*i)), 0.5,2.5)
		#bomb = create_numeric_bomb(Vector2(random_range_integer,is_upsidedown*(-100+50*i)), 0.5, 2.5, i+1)
	#bomb.connect("no_lower_value_bomb_exists", Callable(self, "pattern_narrow_road_end"))

func pattern_narrow_road_end():
	get_tree().call_group("group_hazard_bomb", "early_eliminate")
	await PlayingFieldInterface.player_grounded
	PlayingFieldInterface.set_playing_time(pattern_start_time + (pattern_narrow_road_playing_time) / Engine.time_scale)
	pattern_shuffle_and_draw()
	
# pattern_narrow_road block end
###############################
