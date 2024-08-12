extends BombGenerator
class_name CirclerBombGenerator

var pattern_list: Array[Callable]
var levelup_list: Array[Callable]

var pattern_start_time: float
var levelup_queued: int = 0

func _ready():
	pattern_list_initialization()
	levelup_list_initialization()
	
	await Utils.timer(1.0) # game start time offset
	
	pattern_shuffle_and_draw()
	
	await Utils.timer(25.0)
	
	while 1:
		levelup_queued += 1
		await Utils.timer(15.0)

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

func levelup_list_initialization():
	levelup_list.append(Callable(self, "pattern_inversion_speedup"))
	levelup_list.append(Callable(self, "pattern_speed_and_rotation"))

func pattern_shuffle_and_draw():
	if levelup_queued < 1:
		randomize()
		var random_index: int = randi() % pattern_list.size()
		pattern_list[random_index].call()
	else:
		randomize()
		var random_index: int = randi() % levelup_list.size()
		levelup_list[random_index].call()
		levelup_queued -= 1


###############################
# pattern_wall_timing start
# made by Jaeyong

const pattern_wall_timing_playing_time = 3
var pattern_wall_timing_bomb_count: int
var pattern_wall_timing_pos_nor: Vector2
var pattern_wall_timing_angle: float
const pattern_wall_timing_bomb_dist = 136

func pattern_wall_timing():
	pattern_start_time = PlayingFieldInterface.get_playing_time()
	
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
	
	for i in (4):
		create_hazard_bomb(pattern_wall_timing_pos_nor.rotated(PI/2) * 256 * i/4, 0.5, 0.5)
		create_hazard_bomb(pattern_wall_timing_pos_nor.rotated(PI/2) * 256 * -i/4, 0.5, 0.5)
	
	await get_tree().create_timer(1.0).timeout
	for i in (4):
		create_hazard_bomb(pattern_wall_timing_pos_nor.rotated(PI/2) * 256 * i/4, 0.5, 0.5)
		create_hazard_bomb(pattern_wall_timing_pos_nor.rotated(PI/2) * 256 * -i/4, 0.5, 0.5)
	
	await get_tree().create_timer(1.0).timeout
	for i in (4):
		create_hazard_bomb(pattern_wall_timing_pos_nor.rotated(PI/2) * 256 * i/4, 0.5, 0.5)
		create_hazard_bomb(pattern_wall_timing_pos_nor.rotated(PI/2) * 256 * -i/4, 0.5, 0.5)

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
const pattern_scattered_hazards_playing_time = 3.5
var pattern_scattered_hazards_bomb_count: int

func pattern_scattered_hazards():
	var left_bomb = 3
	pattern_scattered_hazards_bomb_count = 3
	pattern_start_time = PlayingFieldInterface.get_playing_time()
	
	var player_pos_normalized = PlayingFieldInterface.get_player_position().normalized()
	if (player_pos_normalized == Vector2(0,0)):
		player_pos_normalized = Vector2(1,0)
	
	for i in (8):
		create_hazard_bomb(player_pos_normalized.rotated(PI/4 * i).rotated(3 * PI/8) * (256 - 32) ,0.25,3.25)
	
	var rotation_offset: float = randf_range(0, PI/6)
	for i in (3):
		var bomb: NormalBomb = create_normal_bomb(player_pos_normalized.rotated(PI/3 * i * 2).rotated(rotation_offset) * 64 ,0.5, 3)
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
	const pattern_time = 1.2
	
	await Utils.timer(0.3)
	create_normal_bomb(Vector2(0,0), 0, pattern_time)
	var randomrotation = randf_range(0, 2*PI)
	pattern_random_shape_random(1, randomrotation)
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
	const pattern_time = 1
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
var original_rotation_amount: float = 0

func pattern_random_rotation():
	PlayingFieldInterface.set_theme_color(Color.VIOLET)
	original_rotation_amount = PlayingFieldInterface.current_PlayingField_node.PlayingFieldCamera_node.rotation_amount
	print(original_rotation_amount)
	
	PlayingFieldInterface.rotation_stop()
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
	var bomb = create_rotationspeedup_bomb(Vector2(0, 0), 0.3, 3, original_rotation_amount)
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
	
	var bomb = create_normal_bomb(-player_position * (256-32) / (256-16), 0.1, 2.3)
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

#const pattern_reactspeed_test_playing_time = 5

func pattern_reactspeed_test():
	pattern_start_time = PlayingFieldInterface.get_playing_time()
	PlayingFieldInterface.set_theme_color(Color.BISQUE)
	var indicator: Indicator = Indicator.create()
	add_child(indicator)
	
	await Utils.timer(0.5)
	for i in range(6):
		randomize()
		var which_bomb_decide_num: int = 1 if randi() % 3 else -1
		if which_bomb_decide_num == 1:
			var bomb : NormalBomb = create_normal_bomb(Vector2(0,0), 0.2, 0.5)
		else:
			var bomb : HazardBomb = create_hazard_bomb(Vector2(0,0), 0.2, 0.5)
		await Utils.timer(0.7)
	
	indicator.queue_free()
	await get_tree().create_timer(0.3)
	pattern_shuffle_and_draw()
	
#pattern_reactspeed_test block end
###############################

###############################
# pattern_link_free block start
# made by seokhee

#링크를 구하기 위해선 기다림도 필요한 법..
#컴퓨터 기준으로 개어려워서 circlest 정도일 듯

const pattern_link_free_playing_time = 5

var pattern_link_free_between_bomb2: HazardBomb
var pattern_link_free_between_bomb3: HazardBomb

func pattern_link_free():
	pattern_start_time = PlayingFieldInterface.get_playing_time()
	PlayingFieldInterface.set_theme_color(Color.BISQUE)
	
	var player_position: Vector2 = PlayingFieldInterface.get_player_position()
	var angle_offset: float = player_position.angle() * -1
	
	const CIRCLE_FIELD_RADIUS = 256
	var bomb_radius: float = CIRCLE_FIELD_RADIUS * sqrt(3) / 3
	
	var ccw: float = 1 if randi() % 2 else -1
	
	var bomb1: NormalBomb = create_normal_bomb(Vector2(bomb_radius * cos(angle_offset + ccw * PI/6), bomb_radius * -sin(angle_offset + ccw * PI/6)), 2, 0.75)
	var bomb2: NormalBomb = create_normal_bomb(Vector2(bomb_radius * cos(angle_offset + ccw * PI/2), bomb_radius * -sin(angle_offset + ccw * PI/2)), 2, 0.75)
	
	var link1: BombLink = create_bomb_link(bomb1, bomb2)
	link1.connect("both_bombs_removed", Callable(self, "pattern_link_free_link1_slayed"))
	
	var between_bomb1: HazardBomb = create_hazard_bomb((bomb1.position + bomb2.position) / 2, 0.5, 1.5)
	between_bomb1.add_child(Indicator.new())
	
	var bomb3: NormalBomb = create_normal_bomb(Vector2(bomb_radius * cos(angle_offset + ccw * 5*PI/6), bomb_radius * -sin(angle_offset + ccw * 5*PI/6)), 3, 0.75)
	var bomb4: NormalBomb = create_normal_bomb(Vector2(bomb_radius * cos(angle_offset + ccw * 7*PI/6), bomb_radius * -sin(angle_offset + ccw * 7*PI/6)), 3, 0.75)
	
	var link2: BombLink = create_bomb_link(bomb3, bomb4)
	link2.connect("both_bombs_removed", Callable(self, "pattern_link_free_link2_slayed"))
	
	pattern_link_free_between_bomb2 = create_hazard_bomb((bomb3.position + bomb4.position) / 2, 0.5, 2.5)
	
	var bomb5: NormalBomb = create_normal_bomb(Vector2(bomb_radius * cos(angle_offset + ccw * 3*PI/2), bomb_radius * -sin(angle_offset + ccw * 3*PI/2)), 4, 0.75)
	var bomb6: NormalBomb = create_normal_bomb(Vector2(bomb_radius * cos(angle_offset + ccw * 11*PI/6), bomb_radius * -sin(angle_offset + ccw * 11*PI/6)), 4, 0.75)
	
	create_bomb_link(bomb5, bomb6)
	
	pattern_link_free_between_bomb3 = create_hazard_bomb((bomb5.position + bomb6.position) / 2, 0.5, 3.5)
	
	var center_hazard_bomb: HazardBomb = create_hazard_bomb(Vector2(0,0), 0.5, 4.0)
	
	await Utils.timer(4.0)
	
	var bomb7: NormalBomb = create_normal_bomb(144*Vector2(cos(angle_offset), -sin(angle_offset)), 0.5, 0.5)
	var bomb8: NormalBomb = create_normal_bomb(-144*Vector2(cos(angle_offset), -sin(angle_offset)), 0.5, 0.5)
	
	var main_link = create_bomb_link(bomb7, bomb8)
	
	main_link.connect("both_bombs_removed", Callable(self, "pattern_link_free_end"))

func pattern_link_free_link1_slayed():
	pattern_link_free_between_bomb2.add_child(Indicator.new())
	
func pattern_link_free_link2_slayed():
	pattern_link_free_between_bomb3.add_child(Indicator.new())

func pattern_link_free_end():
	await PlayingFieldInterface.player_grounded
	PlayingFieldInterface.set_playing_time(pattern_start_time + (pattern_link_free_playing_time) / Engine.time_scale)
	pattern_shuffle_and_draw()
	
#pattern_link_free block end
###############################

###############################
# pattern_numeric_diamond_with_hazard_puzzled block start
# made by Bae Sekang

const pattern_diamond_with_hazard_puzzled_playing_time = 3.5

func pattern_diamond_with_hazard_puzzled():
	PlayingFieldInterface.set_theme_color(Color.ORANGE)
	
	pattern_start_time = PlayingFieldInterface.get_playing_time()
	var player_position: Vector2 = PlayingFieldInterface.get_player_position()
	var player_angle: float = player_position.angle()
	player_angle += PI/4
	# var player_angle2: float = player_position.angle() * -1
	var bomb_radius = 64
	create_hazard_bomb(Vector2(0,0), 0.5, 3)
	create_numeric_bomb(Vector2(2*bomb_radius*cos(player_angle+4*PI/2),2*bomb_radius*sin(player_angle+4*PI/2)), 0.5, 3, 1)
	create_numeric_bomb(Vector2(2*bomb_radius*cos(player_angle+1*PI/2),2*bomb_radius*sin(player_angle+1*PI/2)), 0.5, 3, 3)
	create_numeric_bomb(Vector2(2*bomb_radius*cos(player_angle+2*PI/2),2*bomb_radius*sin(player_angle+2*PI/2)), 0.5, 3, 2)
	var bomb: NumericBomb = create_numeric_bomb(Vector2(2*bomb_radius*cos(player_angle+3*PI/2),2*bomb_radius*sin(player_angle+3*PI/2)), 0.5, 3, 4)
	bomb.connect("no_lower_value_bomb_exists", Callable(self, "pattern_diamond_with_hazard_puzzled_end"))

func pattern_diamond_with_hazard_puzzled_end():
	get_tree().call_group("group_hazard_bomb", "early_eliminate")
	await PlayingFieldInterface.player_grounded
	PlayingFieldInterface.set_playing_time(pattern_start_time + (pattern_diamond_with_hazard_puzzled_playing_time) / Engine.time_scale)
	pattern_shuffle_and_draw()
	
# pattern_diamond_with_hazard_puzzled block end
###############################

###############################
# pattern_pizza block start
# made by Bae Sekang

const pattern_pizza_playing_time = 3

func pattern_pizza():
	pattern_start_time = PlayingFieldInterface.get_playing_time()
	PlayingFieldInterface.set_theme_color(Color.ORANGE)
	
	var player_position: Vector2 = PlayingFieldInterface.get_player_position()
	var player_angle: float = player_position.angle()
	var bomb_radius = 220
	
	var center_bomb = create_normal_bomb(Vector2(0,0), 0.5,2.5)
	
	for i in range(6):
		create_hazard_bomb(Vector2(64*cos(player_angle+i*PI/3),64*sin(player_angle+i*PI/3)),0.5,2)
	
	for i in range(1, 25):
		create_normal_bomb(Vector2(bomb_radius * cos(player_angle+i * PI/12.0), bomb_radius * sin(player_angle+i * PI/12.0)), 0.5, 2)
	
	await Utils.timer(1.0)
	center_bomb.connect("player_body_entered",Callable(self,"pattern_pizza_end"))

func pattern_pizza_end():
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
	var rng2 = RandomNumberGenerator.new()
	var random_rotate = rng2.randi_range(0, 4)	
	var player_angle: float = player_position.angle()
	player_angle+=random_rotate*PI/2
	var hazard1_angle: float = player_position.angle()+1*PI/5
	var hazard2_angle: float = player_position.angle()-1*PI/5
	var bomb_radius = 64
	var length = 64
	var bomb: NumericBomb
	#var first_hazard1: HazardBomb = create_hazard_bomb(Vector2(2.4*bomb_radius*cos(player_angle+PI/5),2.4*bomb_radius*sin(player_angle+PI/5)),0,0)
	#var first_hazard2: HazardBomb = create_hazard_bomb(Vector2(2.4*bomb_radius*cos(player_angle-PI/5),2.4*bomb_radius*sin(player_angle-PI/5)),0,0)
	var first_numeric: NumericBomb = create_numeric_bomb(Vector2(2*bomb_radius*cos(player_angle+4*PI/2),2*bomb_radius*sin(player_angle+4*PI/2)),0.5,2.5,1)
	#var first_hazard1_position = first_hazard1.position
	#var first_hazard2_position = first_hazard2.position
	var first_numeric_position = first_numeric.position
	for t in range(1,5,1):
		if t<4 :
			create_hazard_bomb(Vector2(2.4*bomb_radius*cos(player_angle+PI/5),2.4*bomb_radius*sin(player_angle+PI/5))+t*Vector2(bomb_radius*cos(player_angle+PI),bomb_radius*sin(player_angle+PI)),0.5,2.5)
			create_hazard_bomb(Vector2(2.4*bomb_radius*cos(player_angle-PI/5),2.4*bomb_radius*sin(player_angle-PI/5))+t*Vector2(bomb_radius*cos(player_angle+PI),bomb_radius*sin(player_angle+PI)),0.5,2.5)
			create_numeric_bomb(first_numeric_position+t*Vector2(bomb_radius*cos(player_angle+PI),bomb_radius*sin(player_angle+PI)),0.5,2.5,t+1)
	var end_bomb: NumericBomb
	end_bomb = create_numeric_bomb(first_numeric_position+4*Vector2(bomb_radius*cos(player_angle+PI),bomb_radius*sin(player_angle+PI)),0.5,2.5,5)
	end_bomb.connect("no_lower_value_bomb_exists", Callable(self, "pattern_narrow_road_end"))

func pattern_narrow_road_end():
	get_tree().call_group("group_hazard_bomb", "early_eliminate")
	await PlayingFieldInterface.player_grounded
	PlayingFieldInterface.set_playing_time(pattern_start_time + (pattern_narrow_road_playing_time) / Engine.time_scale)
	pattern_shuffle_and_draw()
	
# pattern_narrow_road block end
###############################

###############################
# pattern_inversion_speedup block start
# made by Lee Jinwoong

const pattern_inversion_speedup_playing_time = 4.0

func pattern_inversion_speedup():
	PlayingFieldInterface.set_theme_color(Color.DEEP_SKY_BLUE)
	
	pattern_start_time = PlayingFieldInterface.get_playing_time()
	
	var player_position: Vector2 = PlayingFieldInterface.get_player_position()
	
	create_rotationinversion_bomb(Vector2.ZERO, 1.0, 3.0)
	var bomb1: RotationSpeedUpBomb = create_rotationspeedup_bomb(player_position.rotated(PI / 2.0) * 0.5, 1.0, 3.0, 0.3)
	var bomb2: GameSpeedUpBomb = create_gamespeedup_bomb(player_position.rotated(PI / -2.0) * 0.5, 1.0, 3.0, 0.12)
	var link: BombLink = create_bomb_link(bomb1, bomb2)
	
	link.connect("both_bombs_removed", Callable(self, "pattern_inversion_speedup_end"))

func pattern_inversion_speedup_end():
	await PlayingFieldInterface.player_grounded
	PlayingFieldInterface.set_playing_time(pattern_start_time + (pattern_inversion_speedup_playing_time) / Engine.time_scale)
	pattern_shuffle_and_draw()

# pattern_inversion_speedup block end
###############################

###############################
# pattern_speed_and_roation block start
# made by jooyoung

const pattern_speed_or_rotation_playing_time = 2.5
const pattern_speed_or_rotation_rest_time = 0.5

func pattern_speed_and_rotation():
	pattern_start_time = PlayingFieldInterface.get_playing_time()
	
	var player_position: Vector2 = PlayingFieldInterface.get_player_position()
	var player_angle: float = player_position.angle()
	const bomb_radius = 64
	
	var bomb1: NumericBomb = create_numeric_bomb(Vector2(2 * bomb_radius * cos(player_angle), 2 * bomb_radius * sin(player_angle)),0.5,2.0,1)
	var bomb2: RotationSpeedUpBomb = create_rotationspeedup_bomb(Vector2(bomb_radius * cos(player_angle), bomb_radius * sin(player_angle)),0.5,2.0,0.3)
	
	create_bomb_link(bomb1,bomb2)
	
	var bomb3: GameSpeedUpBomb = create_gamespeedup_bomb(Vector2(bomb_radius * cos(player_angle+PI), bomb_radius * sin(player_angle+PI)),0.5,2.0,0.12)
	var bomb4: NumericBomb = create_numeric_bomb(Vector2(2 * bomb_radius * cos(player_angle+PI), 2 * bomb_radius * sin(player_angle+PI)),0.5,2.0,2)
	
	var link2: BombLink = create_bomb_link(bomb3,bomb4)
	
	link2.connect("both_bombs_removed",Callable(self,"pattern_speed_and_roation_end"))

func pattern_speed_and_roation_end():
	PlayingFieldInterface.set_playing_time(pattern_start_time + (pattern_speed_or_rotation_playing_time) / Engine.time_scale)
	await get_tree().create_timer(pattern_speed_or_rotation_rest_time).timeout
	pattern_shuffle_and_draw()
	
#pattern_speed_and_roation end
###############################
