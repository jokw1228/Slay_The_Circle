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
	var player_position: Vector2 = PlayingFieldInterface.get_player_position()
	var angle_start: float = player_position.angle() * -1
	
	const CIRCLE_FIELD_RADIUS = 256
	const bomb_radius = CIRCLE_FIELD_RADIUS - 32
	
	var hazard_bomb_list: Array[HazardBomb]
	
	const pattern_time = 10.0
	
	const number_of_hazard_bombs = 16
	for i in range(number_of_hazard_bombs):
		if i == 0:
			continue
		var inst: HazardBomb = create_hazard_bomb(Vector2(bomb_radius * cos(angle_start + i * (2*PI / number_of_hazard_bombs)), bomb_radius * -sin(angle_start + i * (2*PI / number_of_hazard_bombs))), 0.5, pattern_time)
	
	await get_tree().create_timer(pattern_time).timeout
	pattern_shuffle_and_draw()

# pattern_cat_wheel end
###############################
