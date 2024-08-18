extends CircleBombGenerator
class_name HyperCircleBombGenerator

func _ready(): # override
	PlayingFieldInterface.set_theme_color(Color.DEEP_SKY_BLUE)
	PlayingFieldInterface.set_theme_bright(1)
	
	stage_phase = 5
	PlayingFieldInterface.game_speed_up(0.25)
	PlayingFieldInterface.rotation_speed_up(0.6)
	
	pattern_queue = PatternPriorityQueue.create()
	set_pattern_weight()
	await get_tree().create_timer(1.0).timeout # game start time offset
	pattern_shuffle_and_draw()

func set_pattern_weight():
	pattern_weight = {
		"pattern_numeric_center_then_link" = 1.0,
		"pattern_numeric_triangle_with_link" = 1.0,
		"pattern_star" = 1.0,
		"pattern_random_link" = 1.0,
		"pattern_diamond" = 1.0,
		
		"pattern_twisted_numeric" = 2.0,
		"pattern_numeric_choice" = 2.0,
		"pattern_369" = 2.0,
		
		"pattern_spiral" = 3.0,
		"pattern_roll" = 3.0,
		"pattern_diamond_with_hazard" = 3.0,
		"pattern_colosseum" = 3.0,
		
		"pattern_numeric_inversion" = 1.0
	}
