extends BombGenerator

func _ready():
	
	#pattern1
	create_hazard_bomb(Vector2(50,50),1.0,0.5)
	create_hazard_bomb(Vector2(50,-50),1.0,0.5)
	create_hazard_bomb(Vector2(-50,50),1.0,0.5)
	create_hazard_bomb(Vector2(-50,-50),1.0,0.5)
	create_normal_bomb(Vector2(0,0),1.0,1.5)
	await get_tree().create_timer(5.0).timeout
	
	#pattern2
	create_hazard_bomb(Vector2(200,0),1.0,0.5)
	create_hazard_bomb(Vector2(-200,0),1.0,0.5)
	create_hazard_bomb(Vector2(0,0),1.0,0.5)
	create_normal_bomb(Vector2(100,0),1.0,1.5)
	create_normal_bomb(Vector2(-100,0),1.0,1.5)
	await get_tree().create_timer(5.0).timeout

	#pattern3
	create_hazard_bomb(Vector2(200,0),1.0,0.1)
	create_hazard_bomb(Vector2(-200,0),1.0,0.1)
	create_hazard_bomb(Vector2(0,200),1.0,0.1)
	create_hazard_bomb(Vector2(0,-200),1.0,0.1)
	create_hazard_bomb(Vector2(141,141),1.0,0.1)
	create_hazard_bomb(Vector2(-141,141),1.0,0.1)
	create_hazard_bomb(Vector2(141,-141),1.0,0.1)
	create_hazard_bomb(Vector2(-141,-141),1.0,0.1)
	await get_tree().create_timer(5.0).timeout
	
	#pattern4
	create_hazard_bomb(Vector2(200,0),1.0,0.1)
	create_hazard_bomb(Vector2(-200,0),1.0,0.1)
	await get_tree().create_timer(1.0).timeout
	create_hazard_bomb(Vector2(100,0),1.0,0.1)
	create_hazard_bomb(Vector2(-100,0),1.0,0.1)
	await get_tree().create_timer(1.0).timeout
	create_normal_bomb(Vector2(0,0),1.0,0.5)
	await get_tree().create_timer(5.0).timeout
	
	#pattern5
	create_hazard_bomb(Vector2(200,0),0.25,0.1)
	create_hazard_bomb(Vector2(100,0),0.25,0.1)
	create_hazard_bomb(Vector2(0,0),0.25,0.1)
	await get_tree().create_timer(0.25).timeout
	create_hazard_bomb(Vector2(141,141),0.25,0.1)
	create_hazard_bomb(Vector2(70,70),0.25,0.1)
	create_hazard_bomb(Vector2(0,0),0.25,0.1)
	await get_tree().create_timer(0.25).timeout
	create_hazard_bomb(Vector2(0,200),0.25,0.1)
	create_hazard_bomb(Vector2(0,100),0.25,0.1)
	create_hazard_bomb(Vector2(0,0),0.25,0.1)
	await get_tree().create_timer(0.25).timeout
	create_hazard_bomb(Vector2(-141,141),0.25,0.1)
	create_hazard_bomb(Vector2(-70,70),0.25,0.1)
	create_hazard_bomb(Vector2(0,0),0.25,0.1)
	await get_tree().create_timer(0.25).timeout
	create_hazard_bomb(Vector2(-200,0),0.25,0.1)
	create_hazard_bomb(Vector2(-100,0),0.25,0.1)
	create_hazard_bomb(Vector2(0,0),0.25,0.1)
	await get_tree().create_timer(0.25).timeout
	create_hazard_bomb(Vector2(-141,-141),0.25,0.1)
	create_hazard_bomb(Vector2(-70,-70),0.25,0.1)
	create_hazard_bomb(Vector2(0,0),0.25,0.1)
	await get_tree().create_timer(0.25).timeout
	create_hazard_bomb(Vector2(0,-200),0.25,0.1)
	create_hazard_bomb(Vector2(0,-100),0.25,0.1)
	create_hazard_bomb(Vector2(0,0),0.25,0.1)
	await get_tree().create_timer(0.25).timeout
	create_hazard_bomb(Vector2(141,-141),0.25,0.1)
	create_hazard_bomb(Vector2(70,-70),0.25,0.1)
	create_hazard_bomb(Vector2(0,0),0.25,0.1)
	await get_tree().create_timer(0.25).timeout	
	await get_tree().create_timer(5.0).timeout
