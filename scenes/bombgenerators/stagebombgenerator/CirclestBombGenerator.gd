extends BombGenerator
class_name CirclestBombGenerator

var pattern_list: Array[Callable]

func _ready():
	pattern_list_initialization()
	
	await Utils.timer(1.0) # game start time offset
	
	pattern_shuffle_and_draw()

func pattern_list_initialization():
	#pattern_list.append(Callable(self, "pattern_test_1"))
	pattern_list.append(Callable(self, "pattern_cat_wheel"))

func pattern_shuffle_and_draw():
	randomize()
	var random_index: int = randi() % pattern_list.size()
	pattern_list[random_index].call()
	

###############################
# pattern_test_1 block start

func pattern_test_1():
	await Utils.timer(0.1) # do nothing
	pattern_shuffle_and_draw()

# pattern_test_1 block end
###############################

###############################
# pattern_cat_wheel block start
# made by Jo Kangwoo

func pattern_cat_wheel():
	PlayingFieldInterface.set_theme_color(Color.DEEP_SKY_BLUE)
	
	var player_position: Vector2 = PlayingFieldInterface.get_player_position()
	var angle_start: float = player_position.angle() * -1
	
	const CIRCLE_FIELD_RADIUS = 256
	const bomb_radius = CIRCLE_FIELD_RADIUS - 32
	
	var ccw: float = 1 if randi() % 2 else -1
	
	var hazard_bomb_list: Array[HazardBomb]
	
	const number_of_hazard_bombs = 16
	const warning_time = 0.5
	const bomb_time = 4.5
	for i in range(number_of_hazard_bombs):
		if i == 0 or i == number_of_hazard_bombs - 1 or i == number_of_hazard_bombs - 2:
			continue
		var inst: HazardBomb = create_hazard_bomb(Vector2(bomb_radius * cos(angle_start + i * (ccw * (2*PI) / number_of_hazard_bombs)), bomb_radius * -sin(angle_start + i * (ccw * (2*PI) / number_of_hazard_bombs))), warning_time, bomb_time)
		hazard_bomb_list.append(inst)
	
	const time_offset = 1.0
	await get_tree().create_timer(warning_time + time_offset).timeout
	
	var center: Node2D = Node2D.new()
	add_child(center)
	
	for i in range(number_of_hazard_bombs - 3):
		hazard_bomb_list[i].reparent(center)
	
	var tween_rotation: Tween = get_tree().create_tween()
	tween_rotation.tween_property(center, "rotation", ccw * (2*PI), bomb_time - time_offset)
	
	const rest_time = 0.5
	await get_tree().create_timer(bomb_time - time_offset + rest_time).timeout
	center.queue_free()
	pattern_shuffle_and_draw()

# pattern_cat_wheel end
###############################
