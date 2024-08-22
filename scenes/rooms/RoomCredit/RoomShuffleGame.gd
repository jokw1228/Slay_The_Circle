extends Node2D

@export var Player_node: Player
@export var circlefield: CircleField

var fail_waiting = false

signal fail_signal

func _ready():
	await Utils.timer(1.0)
	await pattern_shuffle_game()

func _process(delta):
	pattern_shuffle_game_process(delta)


var pattern_shuffle_game_bombs: Array[Node2D]
var pattern_shuffle_game_real_bomb: Bomb
var pattern_shuffle_game_moving: bool = false

var pattern_shuffle_game_rand = [0, 0, 0, 1]
const pattern_shuffle_game_const_position = [Vector2(-224 / sqrt(2), -224 / sqrt(2)), Vector2(224 / sqrt(2), -224 / sqrt(2)), Vector2(-224 / sqrt(2), 224 / sqrt(2)), Vector2(224 / sqrt(2), 224 / sqrt(2))]
var pattern_shuffle_game_bomb_pos = [1, 2, 3, 4] # 각 폭탄의 현재 위치

var pattern_shuffle_game_direction = [0,0,0,0]
var pattern_shuffle_game_distance = [0,0,0,0]
var pattern_shuffle_game_moveseed = [0,0,0,0]
var pattern_shuffle_game_speed = [0,0,0,0]
var pattern_shuffle_game_speed_increasing: float

func pattern_shuffle_game():
	var bomb_time = 0
	var calculation = 3.3
	for i in range(8):
		bomb_time += 0.1 + 1/calculation
		calculation += 0.3
	
	pattern_shuffle_game_speed_increasing = 3.3
	pattern_shuffle_game_bombs.clear()
	pattern_shuffle_game_moving = false

	pattern_shuffle_game_bomb_pos = [1, 2, 3, 4]
	pattern_shuffle_game_rand.shuffle()
	var prev_value = 5
	var real_bomb_position
	
	for i in range(4):
		if pattern_shuffle_game_rand[i]:
			pattern_shuffle_game_bombs.append(HazardBomb.create(Vector2(1000, 1000), bomb_time + 1.6, 0))
			pattern_shuffle_game_real_bomb = NormalBomb.create(pattern_shuffle_game_const_position[i], 0.8 + 1, 10)
			pattern_shuffle_game_real_bomb.get_node("BombTimer").disconnect("bomb_timeout", Callable(pattern_shuffle_game_real_bomb, "game_over"))
			pattern_shuffle_game_real_bomb.get_node("BombTimer").connect("bomb_timeout", Callable(self, "fail"))
			connect("fail_signal", Callable(pattern_shuffle_game_real_bomb, "queue_free"))
			add_child(pattern_shuffle_game_real_bomb)
			pattern_shuffle_game_real_bomb.position = pattern_shuffle_game_const_position[i]
			real_bomb_position = i
		else:
			pattern_shuffle_game_bombs.append(HazardBomb.create(pattern_shuffle_game_const_position[i], bomb_time + 1.6, 0.1))
			pattern_shuffle_game_bombs[i].position = pattern_shuffle_game_const_position[i]
			
	for i in pattern_shuffle_game_bombs:
		i.disconnect("player_body_entered", Callable(i, "game_over"))
		i.connect("player_body_entered", Callable(self, "fail"))
		connect("fail_signal", Callable(i, "queue_free"))
		connect("fail_signal", Callable(i, "hazard_bomb_ended_effect"))
		add_child(i)
		
	await Utils.timer(0.8)
	pattern_shuffle_game_bombs[real_bomb_position].position = pattern_shuffle_game_const_position[real_bomb_position]
	if is_instance_valid(pattern_shuffle_game_real_bomb):
		pattern_shuffle_game_real_bomb.queue_free()
	
	for i in range(8): 
		var rand_result = randi_range(0,4)
		while rand_result == prev_value:
			rand_result = randi_range(0,4)
		prev_value = rand_result
		await pattern_shuffle_game_random(rand_result)
		await Utils.timer(0.05)
		pattern_shuffle_game_speed_increasing += 0.3
	
	await Utils.timer(0.8)
	var bomb = NormalBomb.create(pattern_shuffle_game_const_position[pattern_shuffle_game_bomb_pos[real_bomb_position]-1], 0, 0.1)
	bomb.get_node("BombTimer").disconnect("bomb_timeout", Callable(bomb, "game_over"))
	bomb.get_node("BombTimer").connect("bomb_timeout", Callable(self, "fail"))
	connect("fail_signal", Callable(bomb, "queue_free"))
	bomb.connect("player_body_entered", Callable(self, "clear"))
	add_child(bomb)
	await Utils.timer(0.6)

func pattern_shuffle_game_random(pattern: int):
	match pattern:
		0:
			await pattern_shuffle_game_move([2, 4, 1, 3]) # Clockwise
		1:
			await pattern_shuffle_game_move([3, 1, 4, 2]) # Counterclockwise
		2:
			await pattern_shuffle_game_move([3, 4, 1, 2]) # Swap vertically
		3:
			await pattern_shuffle_game_move([2, 1, 4, 3]) # Swap horizontally
		4:
			await pattern_shuffle_game_move([4, 3, 2, 1]) # Swap diagonally

func pattern_shuffle_game_move(setseed: Array):
	for i in range(4):
		pattern_shuffle_game_moveseed[i] = setseed[i]
	for i in range(4):
		pattern_shuffle_game_speed[i] = (pattern_shuffle_game_const_position[pattern_shuffle_game_moveseed[pattern_shuffle_game_bomb_pos[i] - 1]- 1] - pattern_shuffle_game_bombs[i].position).length() * pattern_shuffle_game_speed_increasing
	pattern_shuffle_game_moving = true
	await Utils.timer(1/pattern_shuffle_game_speed_increasing + 0.05)
	pattern_shuffle_game_moving = false
	
	for i in range(4):
		pattern_shuffle_game_bomb_pos[i] = pattern_shuffle_game_moveseed[pattern_shuffle_game_bomb_pos[i] - 1]

func pattern_shuffle_game_process(delta):
	if pattern_shuffle_game_moving == true:
		for i in range(4):
			pattern_shuffle_game_direction[i] = (pattern_shuffle_game_const_position[pattern_shuffle_game_moveseed[pattern_shuffle_game_bomb_pos[i] - 1]- 1] - pattern_shuffle_game_bombs[i].position).normalized()
			pattern_shuffle_game_distance[i] = (pattern_shuffle_game_const_position[pattern_shuffle_game_moveseed[pattern_shuffle_game_bomb_pos[i] - 1]- 1] - pattern_shuffle_game_bombs[i].position).length()
			
			if pattern_shuffle_game_distance[i] > 3:
				pattern_shuffle_game_bombs[i].position += pattern_shuffle_game_direction[i] * pattern_shuffle_game_speed[i] * delta
			else:
				pattern_shuffle_game_bombs[i].position = pattern_shuffle_game_const_position[pattern_shuffle_game_moveseed[pattern_shuffle_game_bomb_pos[i] - 1]- 1]

func fail():
	if fail_waiting == false:
		fail_signal.emit()
		fail_waiting = true
		var tween_fail = get_tree().create_tween()
		tween_fail.tween_property(circlefield, "modulate", Color(1,0,0,1), 0.3)
		tween_fail.tween_property(circlefield, "modulate", Color(1,1,1,1), 0.7)
		await Utils.timer(1.0)
		fail_waiting = false
		pattern_shuffle_game()

func clear():
	await Utils.timer(0.5)
	pattern_shuffle_game()

var RoomMenu_room = "res://scenes/rooms/RoomMenu/RoomMenu.tscn"

func _on_exit_button_pressed():
	get_tree().change_scene_to_file(RoomMenu_room)
