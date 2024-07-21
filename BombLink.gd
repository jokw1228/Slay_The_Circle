extends Node2D
class_name BombLink

var bomb1: Bomb
var bomb2: Bomb
var num_child_bombs: int = 2

# for scaling
const CircleFieldRadius = 128

func set_child_bombs(b1: Bomb, b2: Bomb):
	bomb1 = b1
	bomb2 = b2
	add_child(bomb1)
	add_child(bomb2)
	bomb1.player_body_entered.connect(on_bomb_slayed)
	bomb2.player_body_entered.connect(on_bomb_slayed)
	set_transform_of_link()
	
# set position, rotation, scale using bomb1, bomb2
func set_transform_of_link():
	# store the original bomb transform
	var bomb1_trans: Transform2D = bomb1.global_transform
	var bomb2_trans: Transform2D = bomb2.global_transform
	
	var bomb1_pos: Vector2 = bomb1.global_position
	var bomb2_pos: Vector2 = bomb2.global_position
	
	position = (bomb1_pos + bomb2_pos) / 2.0
	rotation = (bomb2_pos - bomb1_pos).angle()
	var d = bomb2_pos - position
	var distance: float = sqrt(d.x * d.x + d.y * d.y)
	# sprite scale was adjusted to circle field radius beforehand
	scale = Vector2(distance / CircleFieldRadius, 1.0)
	
	# restore the original bomb transform
	bomb1.global_transform = bomb1_trans
	bomb2.global_transform = bomb2_trans
	
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
		PlayingFieldInterface.game_over(self.position)
		queue_free()
	elif num_child_bombs == 0:
		# all linked bombs are safely slayed
		queue_free()
	else:
		# this is error case
		PlayingFieldInterface.game_over(self.position)
		queue_free()
