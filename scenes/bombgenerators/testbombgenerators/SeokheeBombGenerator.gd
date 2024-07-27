extends BombGenerator


func _ready():
	await get_tree().create_timer(1.0).timeout
	#pattern5()
	#await get_tree().create_timer(0.2).timeout
	#pattern6()
	#await get_tree().create_timer(0.2).timeout
	#pattern5()
	#await get_tree().create_timer(0.2).timeout
	#pattern6()
	#await get_tree().create_timer(0.2).timeout
	#pattern5()
	#await get_tree().create_timer(0.2).timeout
	#pattern6()
	#await get_tree().create_timer(0.2).timeout
	#pattern5()
	#await get_tree().create_timer(0.2).timeout
	#pattern6()
	#await get_tree().create_timer(0.2).timeout
	pattern1() 
func pattern1(): # cross_easy
	create_hazard_bomb(Vector2(0,0), 1.2, 4)
	create_hazard_bomb(Vector2(120,0), 1.2, 4)
	create_hazard_bomb(Vector2(-120,0), 1.2, 4)
	create_hazard_bomb(Vector2(0,120), 1.2, 4)
	create_hazard_bomb(Vector2(0,-120), 1.2, 4)
	create_hazard_bomb(Vector2(180,0), 1.2, 4)
	create_hazard_bomb(Vector2(-180,0), 1.2, 4)
	create_hazard_bomb(Vector2(0,180), 1.2, 4)
	create_hazard_bomb(Vector2(0,-180), 1.2, 4)
	
	
func pattern2(): #cross_hard
	create_hazard_bomb(Vector2(160,0), 1.2, 4)
	create_hazard_bomb(Vector2(-160,0), 1.2, 4)
	create_hazard_bomb(Vector2(0,160), 1.2, 4)
	create_hazard_bomb(Vector2(0,-160), 1.2, 4)
	var bomb1 = create_normal_bomb(Vector2(90,90), 1.2, 4)
	var bomb2 = create_normal_bomb(Vector2(-90,-90), 1.2, 4)
	create_bomb_link(bomb1, bomb2)
	var bomb3 = create_normal_bomb(Vector2(90,-90), 1.2, 4)
	var bomb4 = create_normal_bomb(Vector2(-90,90), 1.2, 4)
	create_bomb_link(bomb3, bomb4)
	
func pattern3(): #rotation-inversion&speedup
	create_rotationspeedup_bomb(Vector2(0,0), 0.5, 2, 0.1)
	create_rotationinversion_bomb(Vector2(0,180), 1, 4)
	create_rotationinversion_bomb(Vector2(0,-180), 1, 4)
	create_rotationspeedup_bomb(Vector2(180,0), 1, 4, 0.05)
	create_rotationspeedup_bomb(Vector2(-180,0), 1, 4, 0.05)

func pattern4(): #confined
	create_normal_bomb(Vector2(0,0), 0.5, 1)
	create_hazard_bomb(Vector2(120,0), 1.2, 4)
	create_hazard_bomb(Vector2(-120,0), 1.2, 4)
	create_hazard_bomb(Vector2(0,120), 1.2, 4)
	create_hazard_bomb(Vector2(0,-120), 1.2, 4)

func pattern5(): #random (seed random, x)
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var random_int = rng.randi_range(-180, 180)
	create_normal_bomb(Vector2(random_int,0), 0.7, 1.6)
	
func pattern6(): #random (seed random, y)
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var random_int = rng.randi_range(-180, 180)
	create_normal_bomb(Vector2(0,random_int), 0.7, 1.6)	

func pattern7(warning:float, exist:float): #dodge
	warning = 2
	exist = 0.1
	create_hazard_bomb(Vector2(180,0),warning, exist)
	create_hazard_bomb(Vector2(120,134),warning, exist)
	create_hazard_bomb(Vector2(60,170),warning, exist)
	create_hazard_bomb(Vector2(0,180),warning, exist)
	create_hazard_bomb(Vector2(-60,170),warning, exist)
	create_hazard_bomb(Vector2(-120,134),warning, exist)
	create_hazard_bomb(Vector2(-180,0),warning, exist)
	create_hazard_bomb(Vector2(-120,-134),warning, exist)
	create_hazard_bomb(Vector2(-60,-170),warning, exist)
	create_hazard_bomb(Vector2(0,-180),warning, exist)
	create_hazard_bomb(Vector2(60,-170),warning, exist)
	create_hazard_bomb(Vector2(120,-134),warning, exist)
	
func pattern8(warning:float, timelimit:float): #urgent defuse
	create_normal_bomb(Vector2(180,0),warning, timelimit)
	create_normal_bomb(Vector2(120,134),warning, timelimit)
	create_normal_bomb(Vector2(60,170),warning, timelimit)
	create_normal_bomb(Vector2(0,180),warning, timelimit)
	create_normal_bomb(Vector2(-60,170),warning, timelimit)
	create_normal_bomb(Vector2(-120,134),warning, timelimit)
	create_normal_bomb(Vector2(-180,0),warning, timelimit)
	create_normal_bomb(Vector2(-120,-134),warning, timelimit)
	create_normal_bomb(Vector2(-60,-170),warning, timelimit)
	create_normal_bomb(Vector2(0,-180),warning, timelimit)
	create_normal_bomb(Vector2(60,-170),warning, timelimit)
	create_normal_bomb(Vector2(120,-134),warning, timelimit)

#create_normal_bomb()
#create_hazard_bomb()
#create_numeric_bomb()
#create_rotationinversion_bomb()
#create_rotationspeedup_bomb()
#create_gamespeedup_bomb()
