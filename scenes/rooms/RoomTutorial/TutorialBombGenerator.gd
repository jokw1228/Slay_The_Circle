extends BombGenerator
class_name TutorialBombGenerator

@export var Player_node: Player
@export var tutorialtext: Label
@export var explaintext: Label

signal tutorial_end

signal pattern_2_fail_signal
signal pattern_2_clear_signal

signal pattern_3_fail_signal

signal pattern_4_fail_signal

var pattern_1_count_value: int
var pattern_2_count_value: int
var pattern_3_count_value: bool
var pattern_4_count_value: bool

func _ready():
	tutorialtext.modulate = Color(1,1,1,0)
	if tutorialtext.visible == false:
		tutorialtext.visible = true
	
	var tween_tutorial_start = get_tree().create_tween()
	tween_tutorial_start.tween_property(tutorialtext, "modulate", Color(1,1,1,1), 1.3)
	tween_tutorial_start.tween_property(tutorialtext, "modulate", Color(1,1,1,0), 0.7)
	await get_tree().create_timer(2.0).timeout
	if explaintext.visible == false:
		explaintext.visible = true
	explaintext.text = "Aim and Slay!"
	pattern_1_start()
	

################################
# pattern_1 : normal bomb tutorial

func pattern_1_start():
	pattern_1_count_value = 0
	
	var inst1: NormalBomb = create_normal_bomb(Vector2(-128, 0), 1.0, 5.0)
	var inst2: NormalBomb = create_normal_bomb(Vector2(128, 0), 1.0, 5.0)
	
	inst1.get_node("BombTimer").disconnect("bomb_timeout", Callable(inst1, "game_over"))
	inst2.get_node("BombTimer").disconnect("bomb_timeout", Callable(inst2, "game_over"))
	
	inst1.get_node("BombTimer").connect("bomb_timeout", Callable(self, "pattern_1_fail"))
	inst2.get_node("BombTimer").connect("bomb_timeout", Callable(self, "pattern_1_fail"))
	
	inst1.connect("player_body_entered", Callable(self, "pattern_1_count"))
	inst2.connect("player_body_entered", Callable(self, "pattern_1_count"))
	
func pattern_1_fail():
	if pattern_1_count_value != -1:
		pattern_1_count_value = -1
		var tween_fail_color = get_tree().create_tween()
		tween_fail_color.tween_property(explaintext, "modulate", Color(1,0,0,1), 0.3)
		tween_fail_color.tween_property(explaintext, "modulate", Color(1,1,1,1), 0.7)
		await get_tree().create_timer(1.0).timeout
		pattern_1_start()

func pattern_1_count():
	pattern_1_count_value += 1
	if pattern_1_count_value == 2:
		pattern_1_clear()

func pattern_1_clear():
	explaintext.text = "Nice job."
	await get_tree().create_timer(1.0).timeout
	explaintext.text = "Do Not Slay 'the red'!"
	pattern_2_start()

################################
# pattern_2 : hazard bomb tutorial

func pattern_2_start():
	pattern_2_count_value = 0
	
	var inst1: NormalBomb = create_normal_bomb(Vector2(-128, 0), 1.0, 5.0)
	var inst2: NormalBomb = create_normal_bomb(Vector2(128, 0), 1.0, 5.0)
	var inst3: HazardBomb = create_hazard_bomb(Vector2(0, 0), 1.0, 5.0)
	
	inst1.get_node("BombTimer").disconnect("bomb_timeout", Callable(inst1, "game_over"))
	inst2.get_node("BombTimer").disconnect("bomb_timeout", Callable(inst2, "game_over"))
	inst3.disconnect("player_body_entered", Callable(inst3, "game_over"))
	
	inst1.get_node("BombTimer").connect("bomb_timeout", Callable(self, "pattern_2_fail"))
	inst2.get_node("BombTimer").connect("bomb_timeout", Callable(self, "pattern_2_fail"))
	inst3.connect("player_body_entered", Callable(self, "pattern_2_fail"))
	
	inst1.connect("player_body_entered", Callable(self, "pattern_2_count"))
	inst2.connect("player_body_entered", Callable(self, "pattern_2_count"))
	
	connect("pattern_2_fail_signal", Callable(inst1, "queue_free"))
	connect("pattern_2_fail_signal", Callable(inst1, "exploded"))
	connect("pattern_2_fail_signal", Callable(inst2, "queue_free"))
	connect("pattern_2_fail_signal", Callable(inst2, "exploded"))
	
	connect("pattern_2_clear_signal", Callable(inst3, "queue_free"))
	connect("pattern_2_clear_signal", Callable(inst3, "hazard_bomb_ended_effect"))

func pattern_2_fail():
	if pattern_2_count_value != -1:
		pattern_2_count_value = -1
		pattern_2_fail_signal.emit()
		var tween_fail_color = get_tree().create_tween()
		tween_fail_color.tween_property(explaintext, "modulate", Color(1,0,0,1), 0.3)
		tween_fail_color.tween_property(explaintext, "modulate", Color(1,1,1,1), 0.7)
		await get_tree().create_timer(1.0).timeout
		pattern_2_start()

func pattern_2_count():
	pattern_2_count_value += 1
	if pattern_2_count_value == 2:
		pattern_2_clear()

func pattern_2_clear():
	explaintext.text = "Nice job."
	pattern_2_clear_signal.emit()
	await get_tree().create_timer(1.0).timeout
	explaintext.text = "Just, slay it in order"
	pattern_3_start()

################################
# pattern_3 : numeric bomb tutorial

func pattern_3_start():
	pattern_3_count_value = true
	
	const radius = 128
	var inst1: NumericBomb = create_numeric_bomb(Vector2(radius * cos(PI/2), radius * -sin(PI/2)), 1.0, 5.0, 1)
	var inst2: NumericBomb = create_numeric_bomb(Vector2(radius * cos(7*PI/6), radius * -sin(7*PI/6)), 1.0, 5.0, 2)
	var inst3: NumericBomb = create_numeric_bomb(Vector2(radius * cos(11*PI/6), radius * -sin(11*PI/6)), 1.0, 5.0, 3)
	
	inst1.get_node("BombTimer").disconnect("bomb_timeout", Callable(inst1, "game_over"))
	inst1.disconnect("lower_value_bomb_exists", Callable(inst1, "game_over"))
	inst2.get_node("BombTimer").disconnect("bomb_timeout", Callable(inst2, "game_over"))
	inst2.disconnect("lower_value_bomb_exists", Callable(inst2, "game_over"))
	inst3.get_node("BombTimer").disconnect("bomb_timeout", Callable(inst3, "game_over"))
	inst3.disconnect("lower_value_bomb_exists", Callable(inst3, "game_over"))
	
	inst1.get_node("BombTimer").connect("bomb_timeout", Callable(self, "pattern_3_fail"))
	inst2.get_node("BombTimer").connect("bomb_timeout", Callable(self, "pattern_3_fail"))
	inst3.get_node("BombTimer").connect("bomb_timeout", Callable(self, "pattern_3_fail"))
	
	inst2.connect("lower_value_bomb_exists", Callable(self, "pattern_3_fail"))
	inst3.connect("lower_value_bomb_exists", Callable(self, "pattern_3_fail"))
	
	connect("pattern_3_fail_signal", Callable(inst1, "queue_free"))
	connect("pattern_3_fail_signal", Callable(inst1, "exploded"))
	connect("pattern_3_fail_signal", Callable(inst2, "queue_free"))
	connect("pattern_3_fail_signal", Callable(inst2, "exploded"))
	connect("pattern_3_fail_signal", Callable(inst3, "queue_free"))
	connect("pattern_3_fail_signal", Callable(inst3, "exploded"))
	
	inst3.connect("no_lower_value_bomb_exists", Callable(self, "pattern_3_clear"))

func pattern_3_fail():
	if pattern_3_count_value == true:
		pattern_3_count_value = false
		pattern_3_fail_signal.emit()
		var tween_fail_color = get_tree().create_tween()
		tween_fail_color.tween_property(explaintext, "modulate", Color(1,0,0,1), 0.3)
		tween_fail_color.tween_property(explaintext, "modulate", Color(1,1,1,1), 0.7)
		await get_tree().create_timer(1.0).timeout
		pattern_3_start()

func pattern_3_clear():
	explaintext.text = "Nice job."
	await get_tree().create_timer(1.0).timeout
	explaintext.text = "Slay the link 'at once'!"
	pattern_4_start()

################################
# pattern_4 : bomb link tutorial

func pattern_4_start():
	pattern_4_count_value = true
	
	var inst1: NormalBomb = create_normal_bomb(Vector2(-128, 0), 1.0, 5.0)
	var inst2: NormalBomb = create_normal_bomb(Vector2(128, 0), 1.0, 5.0)
	var link = create_bomb_link(inst1, inst2)
	Player_node.connect("grounded", Callable(link, "on_player_grounded"))
	
	inst1.get_node("BombTimer").disconnect("bomb_timeout", Callable(inst1, "game_over"))
	inst2.get_node("BombTimer").disconnect("bomb_timeout", Callable(inst2, "game_over"))
	link.disconnect("single_bomb_removed", Callable(link, "game_over"))
	
	inst1.get_node("BombTimer").connect("bomb_timeout", Callable(self, "pattern_4_fail"))
	inst2.get_node("BombTimer").connect("bomb_timeout", Callable(self, "pattern_4_fail"))
	link.connect("single_bomb_removed", Callable(self, "pattern_4_fail"))
	
	connect("pattern_4_fail_signal", Callable(inst1, "queue_free"))
	connect("pattern_4_fail_signal", Callable(inst1, "exploded"))
	connect("pattern_4_fail_signal", Callable(inst2, "queue_free"))
	connect("pattern_4_fail_signal", Callable(inst2, "exploded"))
	connect("pattern_4_fail_signal", Callable(link, "queue_free"))

	link.connect("both_bombs_removed", Callable(self, "pattern_4_clear"))

func pattern_4_fail():
	if pattern_4_count_value == true:
		pattern_4_count_value = false
		pattern_4_fail_signal.emit()
		var tween_fail_color = get_tree().create_tween()
		tween_fail_color.tween_property(explaintext, "modulate", Color(1,0,0,1), 0.3)
		tween_fail_color.tween_property(explaintext, "modulate", Color(1,1,1,1), 0.7)
		await get_tree().create_timer(1.0).timeout
		pattern_4_start()

func pattern_4_clear():
	explaintext.text = "Well done!"
	await get_tree().create_timer(1.0).timeout
	tutorial_end.emit()
