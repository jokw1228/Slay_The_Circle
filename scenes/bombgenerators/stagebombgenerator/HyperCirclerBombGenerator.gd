extends CirclerBombGenerator
class_name HyperCirclerBombGenerator

func _ready(): # override
	PlayingFieldInterface.set_theme_color(Color.MEDIUM_PURPLE)
	PlayingFieldInterface.set_theme_bright(1)
	
	stage_phase = 4
	PlayingFieldInterface.game_speed_up(0.45)
	PlayingFieldInterface.rotation_speed_up(0.6)
	
	pattern_list_initialization()
	await get_tree().create_timer(1.0).timeout # game start time offset
	pattern_shuffle_and_draw()

func pattern_list_initialization():
	pattern_dict = {
		"pattern_diamond_with_hazard_puzzled" = 2.0,
		"pattern_maze" = 2.0,
		"pattern_narrow_road" = 2.0,
		"pattern_blocking" = 2.0,
		"pattern_scattered_hazards" = 2.0,
		
		"pattern_hide_in_hazard" = 1.0,
		"pattern_wall_timing" = 1.0,
		"pattern_random_shape" = 1.0,
		"pattern_pizza" = 1.0,
		
		"pattern_hazard_at_player_pos" = 1.0,
		"pattern_321_go" = 1.0,
		"pattern_reactspeed_test" = 1.0,
		"pattern_link_free" = 1.0,
		
		"pattern_timing" = 1.0,
		"pattern_trafficlight" = 1.0
	}
