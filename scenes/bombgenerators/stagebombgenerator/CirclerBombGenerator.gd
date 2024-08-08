extends BombGenerator
class_name CirclerBombGenerator

var pattern_list: Array[Callable]

func _ready():
	pattern_list_initialization()
	
	await Utils.timer(1.0) # game start time offset
	
	pattern_shuffle_and_draw()

func pattern_list_initialization():
	pattern_list.append(Callable(self, "pattern_test_1"))
	pattern_list.append(Callable(self, "pattern_lightning"))

func pattern_shuffle_and_draw():
	randomize()
	var random_index: int = randi() % pattern_list.size()
	pattern_list[random_index].call()
	

###############################
# pattern_test_1 block start

func pattern_test_1():
	await Utils.timer(0.1) # do nothing
	pattern_shuffle_and_draw()

# pattern_test_1 block end
###############################


###############################
# pattern_lightning block start
# made by jooyoung

func pattern_lightning():
	var player_position: Vector2 = PlayingFieldInterface.get_player_position()
	var player_angle: float = player_position.angle()
	
	var node: Array[Node2D] = [Node2D.new(),Node2D.new(),Node2D.new(),Node2D.new(),Node2D.new()]
	var direction: Array[int] = [1,-1,1,-1,1]
	var tween_lightning: Tween
	for i in range(5):
		tween_lightning = get_tree().create_tween().set_ease(Tween.EASE_OUT_IN).set_trans(Tween.TRANS_CUBIC)
		add_child(node[i])
		Utils.attach_node(node[i], create_numeric_bomb(node[i].global_position, 0.5,1,i+1))
		node[i].position = Vector2(96 * (2-i) * cos(player_angle), 96 * (2-i) * sin(player_angle))
		tween_lightning.tween_property(node[i],"position",Vector2(-node[i].position.x,node[i].position.y),1)
	
	await Utils.timer(2.5)
	pattern_shuffle_and_draw()

#pattern_lightning end
###############################


