extends CirclerBombGenerator
class_name HyperCirclerBombGenerator

func _ready(): # override
	randomize()
	PlayingFieldInterface.set_theme_color(Color.MEDIUM_PURPLE)
	PlayingFieldInterface.set_theme_bright(1)
	
	stage_phase = 4 # We don't do pattern_level_up_phase_4(). So not 4-1, but 4.
	PlayingFieldInterface.game_speed_up(0.25)
	PlayingFieldInterface.rotation_speed_up(0.6)
	
	pattern_queue = PatternPriorityQueue.create()
	set_pattern_weight()
	await get_tree().create_timer(1.5).timeout # game start time offset
	set_hyper_pattern_queue()
	pattern_shuffle_and_draw()

func pattern_shuffle_and_draw(): # override
	var current_time: float = PlayingFieldInterface.get_playing_time()
	if (stage_phase + 1) * stage_phase_length < current_time + 100.0:
		stage_phase += 1
		choose_level_up_pattern()
	else:
		choose_random_pattern()

func set_hyper_pattern_queue():
	pattern_queue.min_heap_insert( { "pattern_key" = "pattern_diamond_with_hazard_puzzled", "pattern_value" = randf_range(-0.1, 0.0) } )
	pattern_queue.min_heap_insert( { "pattern_key" = "pattern_maze", "pattern_value" = randf_range(-0.1, 0.0) } )
	pattern_queue.min_heap_insert( { "pattern_key" = "pattern_narrow_road", "pattern_value" = randf_range(-0.1, -0.1) } )
	pattern_queue.min_heap_insert( { "pattern_key" = "pattern_blocking", "pattern_value" = randf_range(-0.1, 0.0) } )
	pattern_queue.min_heap_insert( { "pattern_key" = "pattern_scattered_hazards", "pattern_value" = randf_range(-0.1, 0.0) } )

	pattern_queue.min_heap_insert( { "pattern_key" = "pattern_hide_in_hazard", "pattern_value" = randf_range(-0.1, 0.0) } )
	pattern_queue.min_heap_insert( { "pattern_key" = "pattern_wall_timing", "pattern_value" = randf_range(-0.1, 0.0) } )
	pattern_queue.min_heap_insert( { "pattern_key" = "pattern_random_shape", "pattern_value" = randf_range(-0.1, 0.0) } )
	pattern_queue.min_heap_insert( { "pattern_key" = "pattern_pizza", "pattern_value" = randf_range(-0.1, 0.0) } )
	
	pattern_queue.min_heap_insert( { "pattern_key" = "pattern_hazard_at_player_pos", "pattern_value" = randf_range(-0.1, 0.0) } )
	pattern_queue.min_heap_insert( { "pattern_key" = "pattern_321_go", "pattern_value" = randf_range(-0.1, 0.0) } )
	pattern_queue.min_heap_insert( { "pattern_key" = "pattern_reactspeed_test", "pattern_value" = randf_range(-0.1, 0.0) } )
	
	pattern_queue.min_heap_insert( { "pattern_key" = "pattern_timing", "pattern_value" = randf_range(-0.1, 0.0) } )
	pattern_queue.min_heap_insert( { "pattern_key" = "pattern_trafficlight", "pattern_value" = randf_range(-0.1, 0.0) } )
