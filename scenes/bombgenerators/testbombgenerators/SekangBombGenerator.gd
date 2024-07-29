extends BombGenerator

const pattern1_time: float = 6.0
const pattern2_time: float = 6.0
const pattern3_time: float = 6.0
const pattern4_time: float = 14.0
const pattern5_time: float = 10.0


var bomb1: Bomb
var bomb2: Bomb

func _ready():
	create_normal_bomb(Vector2(0, 200), 0, 3)
	create_normal_bomb(Vector2(0, -200), 0, 3)
	await get_tree().create_timer(3).timeout
	
	pattern1_2(100)
	await get_tree().create_timer(pattern1_time).timeout
	pattern2()
	await get_tree().create_timer(pattern2_time).timeout
	pattern3()
	await get_tree().create_timer(pattern3_time).timeout
	pattern4()
	await get_tree().create_timer(pattern4_time).timeout
	pattern5()
	await get_tree().create_timer(pattern5_time).timeout
	pattern1_1(100)


# normal pattern(diamond shape)
func pattern1_1(dist: float):
	create_hazard_bomb(Vector2(0,200), pattern2_time*0.3, pattern2_time*0.7)
	create_hazard_bomb(Vector2(0,-200), pattern2_time*0.3, pattern2_time*0.7)
	create_hazard_bomb(Vector2(200,0), pattern2_time*0.3, pattern2_time*0.7)
	create_hazard_bomb(Vector2(-200,0), pattern2_time*0.3, pattern2_time*0.7)
	for repeat in 2:
		create_normal_bomb(Vector2(0, -dist-10), 0.5, pattern1_time / 3.0)
		await get_tree().create_timer(0.5).timeout
		create_normal_bomb(Vector2(dist-20, 0), 0.5, pattern1_time / 3.0)
		await get_tree().create_timer(0.5).timeout
		create_normal_bomb(Vector2(0, dist+10), 0.5, pattern1_time / 3.0)
		await get_tree().create_timer(0.5).timeout
		create_normal_bomb(Vector2(-dist+20, 0), 0.5, pattern1_time / 3.0)
		await get_tree().create_timer(0.5).timeout
		
func pattern1_2(dist: float):
	for repeat in 2:
		create_normal_bomb(Vector2(0, -dist-10), 0.5, pattern1_time / 3.0)
		await get_tree().create_timer(0.5).timeout
		create_normal_bomb(Vector2(dist-20, 0), 0.5, pattern1_time / 3.0)
		await get_tree().create_timer(0.5).timeout
		create_normal_bomb(Vector2(0, dist+10), 0.5, pattern1_time / 3.0)
		await get_tree().create_timer(0.5).timeout
		create_normal_bomb(Vector2(-dist+20, 0), 0.5, pattern1_time / 3.0)
		await get_tree().create_timer(0.5).timeout
	
# link + hazard
func pattern2():
	create_hazard_bomb(Vector2(0,0), pattern2_time*0.4, pattern2_time*0.6)
	bomb1 = create_normal_bomb(PlayingFieldInterface.get_player_position() * 0.5,
						-0.5, pattern2_time * 0.5)
	bomb2 = create_normal_bomb(PlayingFieldInterface.get_player_position() * -0.5,
						0.5, pattern2_time * 0.5)
	create_bomb_link(bomb1, bomb2)
	await get_tree().create_timer(0.5).timeout
	
# 
func pattern3():
	for i in range(0, 8):
		create_hazard_bomb(Vector2(100 * cos(i * PI/4.0), 100 * sin(i * PI/4.0)), 1, pattern3_time)
	for i in range(0, 32):
		create_hazard_bomb(Vector2(200 * cos(i * PI/8.0), 200 * sin(i * PI/8.0)), 1, 0.7)
		await get_tree().create_timer(0.125).timeout
	create_normal_bomb(Vector2(0, 0), 1.0, 2.0)
		
		
# rotating hazard bomb with normal bombs
func pattern4():
	var pattern4_wait = 2
	for j in 8:
		if j%2==0:
			create_normal_bomb(Vector2(0, 0), 0.5, pattern4_wait*2)
		for i in range(1,4):
			create_hazard_bomb(PlayingFieldInterface.get_player_position() * 0.28 * i, pattern4_wait*0.5, pattern4_wait*0.5)
			create_hazard_bomb(PlayingFieldInterface.get_player_position() * -0.28 * i, pattern4_wait*0.5, pattern4_wait*0.5)
			
		await get_tree().create_timer(pattern4_wait*0.75).timeout
	

# 369 pattern
func pattern5():
	for i in range(1, 17):
		var i_ones_place=i%10
		if i_ones_place%3!=0 or i_ones_place==0:
			create_numeric_bomb(Vector2(200 * cos(i * PI/4.0), 200 * sin(i * PI/4.0)), 1.0, pattern5_time*0.15,0.4+i)
		else:
			create_hazard_bomb(Vector2(200 * cos(i * PI/4.0), 200 * sin(i * PI/4.0)), pattern5_time*0.15,1.5)
		await get_tree().create_timer(0.4).timeout

