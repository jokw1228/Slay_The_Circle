extends CircleBombGenerator
class_name HyperCircleBombGenerator

func _ready(): # override
	PlayingFieldInterface.set_theme_color(Color.DEEP_SKY_BLUE)
	PlayingFieldInterface.set_theme_bright(1)
	
	stage_phase = 4
	PlayingFieldInterface.game_speed_up(0.45)
	PlayingFieldInterface.rotation_speed_up(0.6)
	
	pattern_list_initialization()
	await get_tree().create_timer(1.0).timeout # game start time offset
	pattern_shuffle_and_draw()

func pattern_list_initialization(): # override
	pattern_dict = {
		"pattern_numeric_center_then_link" = 2.0,
		"pattern_numeric_triangle_with_link" = 2.0,
		"pattern_star" = 2.0,
		"pattern_random_link" = 2.0,
		"pattern_diamond" = 2.0,
		
		"pattern_twisted_numeric" = 1.0,
		"pattern_numeric_choice" = 1.0,
		"pattern_369" = 1.0,
		
		"pattern_spiral" = 1.0,
		"pattern_roll" = 1.0,
		"pattern_diamond_with_hazard" = 1.0,
		"pattern_colosseum" = 1.0,
		
		"pattern_numeric_inversion" = 3.0
	}
	pattern_dict={"pattern_star" = 1.0}
