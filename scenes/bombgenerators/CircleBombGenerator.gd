extends BombGenerator
class_name CircleBombGenerator

var pattern_list: Array[Callable]

func _ready():
	pattern_list_initialization()
	
	await Utils.timer(1.0) # game start time offset
	
	pattern_shuffle_and_draw()

func pattern_list_initialization():
	pattern_list.append(Callable(self, "pattern_test_1"))
	pattern_list.append(Callable(self, "pattern_test_2"))

func pattern_shuffle_and_draw():
	print("pattern_shuffle_and_draw")
	
	randomize()
	var random_index: int = randi() % pattern_list.size()
	pattern_list[random_index].call()
	

###############################
# pattern_test_1 block start

func pattern_test_1():
	print("pattern_test_1 has been activated!")
	
	await Utils.timer(4.0) # pattern_test_1 is in progress...
	
	pattern_shuffle_and_draw()

# pattern_test_1 block end
###############################


###############################
# pattern_test_2 block start

func pattern_test_2():
	print("pattern_test_2 has been activated!")
	
	await Utils.timer(4.0) # pattern_test_2 is in progress...
	
	pattern_shuffle_and_draw()

# pattern_test_2 block end
###############################
