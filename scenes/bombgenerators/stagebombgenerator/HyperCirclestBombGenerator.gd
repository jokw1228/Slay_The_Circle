extends CirclestBombGenerator
class_name HyperCirclestBombGenerator

func _ready(): # override
	PlayingFieldInterface.set_theme_color(Color.ORANGE_RED)
	PlayingFieldInterface.set_theme_bright(1)
	
	stage_phase = 4
	PlayingFieldInterface.game_speed_up(0.45)
	PlayingFieldInterface.rotation_speed_up(0.4)
	
	pattern_list_initialization()
	await get_tree().create_timer(1.0).timeout # game start time offset
	pattern_shuffle_and_draw()

func pattern_list_initialization():
	pattern_dict = {
		"pattern_moving_link" = 2.0,
		"pattern_survive_random_slay" = 2.0,
		"pattern_rotate_timing" = 2.0,
		"pattern_trickery" = 2.0,
		
		"pattern_cat_wheel" = 1.0,
		"pattern_fruitninja" = 1.0,
		"pattern_rain" = 1.0,
		
		"pattern_hazard_wave" = 1.0,
		"pattern_windmill" = 1.0,
		"pattern_timing_return" = 1.0,
		
		"pattern_shuffle_game" = 1.0,
		"pattern_darksight" = 1.0
	}
	pattern_dict = {"pattern_rotate_timing" = 1.0}
