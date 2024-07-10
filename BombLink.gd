extends Node2D
class_name BombLink

var bomb1: Bomb
var bomb2: Bomb
var num_child_bombs: int = 2
	
func set_child_bombs(b1: Bomb, b2: Bomb):
	bomb1 = b1
	bomb2 = b2
	add_child(bomb1)
	add_child(bomb2)
	bomb1.player_body_entered.connect(on_bomb_slayed())
	bomb2.player_body_entered.connect(on_bomb_slayed())
	set_transform_of_link()
	
func set_transform_of_link():
	# set pos, rot, size using bomb1, bomb2
	pass
	
# connected to player_body_entered signal
func on_bomb_slayed():
	num_child_bombs -= 1

# signal by Player to PlayingField to BombLink
func on_player_grounded():
	if num_child_bombs == 2:
		# do nothing
		pass
	elif num_child_bombs == 1:
		# only one of linked bombs is slayed, game over
		PlayingFieldInterface.game_over()
		queue_free()
	elif num_child_bombs == 0:
		# all linked bombs are safely slayed
		queue_free()
	else:
		# this is error case
		PlayingFieldInterface.game_over()
		queue_free()
