extends BombGenerator
class_name CirclerBombGenerator

var pattern_list: Array[Callable]

func _ready():
	pattern_list_initialization()
	
	await Utils.timer(1.0) # game start time offset
	
	pattern_shuffle_and_draw()

func pattern_list_initialization():
	pattern_list.append(Callable(self, "pattern_lightning"))
	pattern_list.append(Callable(self, "pattern_wall_timing"))
	pattern_list.append(Callable(self, "pattern_scattered_hazards"))
	pattern_list.append(Callable(self, "pattern_random_shape"))

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
	for i in range(6):
		create_normal_bomb(Vector2(0,0), 0, pattern_time)
		var rand_result = randi_range(0,4)
		while rand_result == prev_value:
			rand_result = randi_range(0,4)
		prev_value = rand_result
		var randomrotation = randf_range(0, 2*PI)
		pattern_random_shape_random(rand_result, randomrotation)
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
		3: # diamond
			var x = [150,75,75,0,0,-75,-75,-150]
			var y = [0,75,-75,150,-150,75,-75,0]
			for i in range(8):
				create_hazard_bomb(Vector2(x[i],y[i]).rotated(randomrotation), pattern_time, 0.1)
		4: # star
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
