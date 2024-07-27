extends BombGenerator

const pattern1_time: float = 6.0
const pattern2_time: float = 9.0
const pattern3_time: float = 8.0
const pattern4_time: float = 1.0
const pattern5_time: float = 6.0
const pattern6_time: float = 9.0
const pattern7_time: float = 9.0

var bomb1: Bomb
var bomb2: Bomb

func _ready():
	create_normal_bomb(Vector2(0, 200), 0, 3)
	await get_tree().create_timer(3).timeout
	
	pattern1(75)
	await get_tree().create_timer(pattern1_time).timeout
	pattern1(150)
	await get_tree().create_timer(pattern1_time).timeout
	
	pattern2()
	await get_tree().create_timer(pattern2_time).timeout
	pattern2()
	await get_tree().create_timer(pattern2_time).timeout
	
	pattern4()
	await get_tree().create_timer(pattern4_time).timeout
	pattern4()
	await get_tree().create_timer(pattern4_time).timeout
	pattern4()
	await get_tree().create_timer(pattern4_time).timeout
	pattern4()
	await get_tree().create_timer(pattern4_time).timeout
	
	await get_tree().create_timer(2).timeout
	
	pattern6()
	await get_tree().create_timer(pattern6_time).timeout
	pattern6()
	await get_tree().create_timer(pattern6_time).timeout
	
	pattern7()
	await get_tree().create_timer(pattern7_time).timeout
	
	pattern5()
	await get_tree().create_timer(pattern5_time).timeout
	pattern5()
	await get_tree().create_timer(pattern5_time).timeout
	pattern5()
	await get_tree().create_timer(pattern5_time).timeout
	
	create_gamespeedup_bomb(Vector2.ZERO, 0, 3, -1.2)
	await get_tree().create_timer(3).timeout
	
	create_rotationspeedup_bomb(Vector2.ZERO, 1, 1.5, 1)
	await get_tree().create_timer(3.5).timeout
	
	# rotation start
	
	pattern3()
	await get_tree().create_timer(pattern3_time).timeout
	pattern3()
	await get_tree().create_timer(pattern3_time).timeout
	pattern3()
	await get_tree().create_timer(pattern3_time).timeout
	
	create_gamespeedup_bomb(Vector2.ZERO, 3, 3, -1.5)
	await get_tree().create_timer(6).timeout
	
	pattern1(100)
	await get_tree().create_timer(pattern1_time).timeout
	
	pattern2()
	await get_tree().create_timer(pattern2_time).timeout
	pattern2()
	await get_tree().create_timer(pattern2_time).timeout
	
	pattern4()
	await get_tree().create_timer(pattern4_time).timeout
	pattern4()
	await get_tree().create_timer(pattern4_time).timeout
	pattern4()
	await get_tree().create_timer(pattern4_time).timeout
	pattern4()
	await get_tree().create_timer(pattern4_time).timeout
	
	await get_tree().create_timer(2).timeout
	
	pattern5()
	await get_tree().create_timer(pattern5_time).timeout
	pattern5()
	await get_tree().create_timer(pattern5_time).timeout
	
	create_gamespeedup_bomb(Vector2.ZERO, 3, 3, -0.8)
	await get_tree().create_timer(6).timeout
	
	pattern6()
	await get_tree().create_timer(pattern6_time).timeout
	pattern6()
	await get_tree().create_timer(pattern6_time).timeout
	
	pattern7()
	await get_tree().create_timer(pattern7_time).timeout
	
	pattern3()
	await get_tree().create_timer(pattern3_time).timeout
	pattern3()
	await get_tree().create_timer(pattern3_time).timeout
	pattern3()
	await get_tree().create_timer(pattern3_time).timeout

# normal pattern
func pattern1(dist: float):
	create_normal_bomb(Vector2(0, -dist), 0.5, pattern1_time / 4.0)
	await get_tree().create_timer(pattern1_time / 4.0).timeout
	create_normal_bomb(Vector2(dist, 0), 0.5, pattern1_time / 4.0)
	await get_tree().create_timer(pattern1_time / 4.0).timeout
	create_normal_bomb(Vector2(0, dist), 0.5, pattern1_time / 4.0)
	await get_tree().create_timer(pattern1_time / 4.0).timeout
	create_normal_bomb(Vector2(-dist, 0), 0.5, pattern1_time / 4.0)
	await get_tree().create_timer(pattern1_time / 4.0).timeout
	
# numeric bomb + link pattern
func pattern2():
	create_numeric_bomb(Vector2(0, 0), pattern2_time / 3.0, pattern2_time / 3.0, 1)
	bomb1 = create_numeric_bomb(PlayingFieldInterface.get_player_position() * -0.5,
						pattern2_time / 3.0, pattern2_time * 1.5, 2)
	bomb2 = create_numeric_bomb(PlayingFieldInterface.get_player_position() * 0.5,
						pattern2_time / 3.0, pattern2_time * 1.5, 3)
	create_bomb_link(bomb1, bomb2)
	
# inversion + speedup pattern
func pattern3():
	create_hazard_bomb(PlayingFieldInterface.get_player_position() * 0.8, pattern3_time / 4.0, pattern3_time / 4.0)
	await get_tree().create_timer(pattern3_time / 4.0).timeout
	bomb1 = create_rotationinversion_bomb(PlayingFieldInterface.get_player_position() * 0.5,
											pattern3_time / 4.0, pattern3_time / 2.0)
	bomb2 = create_gamespeedup_bomb(PlayingFieldInterface.get_player_position() * -0.5,
											pattern3_time / 4.0, pattern3_time / 2.0, 0.5)
	create_bomb_link(bomb1, bomb2)

# hazard bomb pattern
func pattern4():
	create_hazard_bomb(PlayingFieldInterface.get_player_position() * 0.8, pattern4_time, pattern4_time)
	create_hazard_bomb(PlayingFieldInterface.get_player_position() * -0.8, pattern4_time, pattern4_time)
	await get_tree().create_timer(pattern4_time).timeout

# timing pattern
func pattern5():
	# pattern ready 1s
	for i in range(0, 8):
		create_hazard_bomb(Vector2(128 * cos(i * PI / 4.0), 128 * sin(i * PI / 4.0)), 1, 1)
	await get_tree().create_timer(1).timeout
	
	# pattern 5s
	var player_position: Vector2 = PlayingFieldInterface.get_player_position()
	var time_offset: float = 1.0 / 6.0
	#var pattern5_time: float = pattern5_time - 2.0
	create_hazard_bomb(player_position.rotated(PI), pattern5_time, time_offset)
	for i in range(1, 6):
		await get_tree().create_timer(time_offset).timeout
		create_hazard_bomb(player_position.rotated(PI * (6 - i) / 6.0), pattern5_time, time_offset)
		create_hazard_bomb(player_position.rotated(PI * (6 + i) / 6.0), pattern5_time, time_offset)
	await get_tree().create_timer(time_offset).timeout
	create_hazard_bomb(player_position, pattern5_time, time_offset)
	create_numeric_bomb(PlayingFieldInterface.get_player_position() * 0.5, 0, pattern5_time, 1)
	await get_tree().create_timer(pattern5_time / 4.0).timeout
	create_gamespeedup_bomb(Vector2.ZERO, 0, pattern5_time * 3.0 / 4.0, 0.4)
	await get_tree().create_timer(pattern5_time / 4.0).timeout
	create_numeric_bomb(PlayingFieldInterface.get_player_position() * -0.5, 0, pattern5_time / 2.0, 2)
	await get_tree().create_timer(pattern5_time / 4.0).timeout

# numeric + link pattern 2
func pattern6():
	create_hazard_bomb(Vector2.ZERO, 0.5, pattern6_time / 1.5)
	create_numeric_bomb(PlayingFieldInterface.get_player_position().rotated(PI / -2.0) * 0.5, 0.5, pattern6_time, 1)
	bomb1 = create_numeric_bomb(PlayingFieldInterface.get_player_position() * -0.5, 0.5, pattern6_time, 2)
	bomb2 = create_numeric_bomb(PlayingFieldInterface.get_player_position() * 0.5, 0.5, pattern6_time, 3)
	create_bomb_link(bomb1, bomb2)
	create_numeric_bomb(PlayingFieldInterface.get_player_position().rotated(PI / 2.0) * 0.5, 0.5, pattern6_time, 4)

# numeric bomb pattern
func pattern7():
	create_numeric_bomb(PlayingFieldInterface.get_player_position() * -0.5, 0.5, pattern7_time, 1)
	create_numeric_bomb(PlayingFieldInterface.get_player_position().rotated(PI / 2.0) * 0.5, 0.5, pattern7_time, 2)
	create_numeric_bomb(PlayingFieldInterface.get_player_position().rotated(PI / -2.0) * 0.5, 0.5, pattern7_time, 3)
	create_numeric_bomb(PlayingFieldInterface.get_player_position() * 0.5, 0.5, pattern7_time, 4)
