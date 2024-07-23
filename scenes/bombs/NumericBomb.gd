extends Bomb
class_name NumericBomb

var id = 0

func _ready():
	$BombId.text = str(id)

func slayed():
	if has_smaller_id_numeric_bomb():
		#queue free test
		#for i in get_parent().get_children():
			#if i is NumericBomb:
				#i.queue_free()
		PlayingFieldInterface.game_over(self.position)
	super()
	
	SoundManager.play("sfx_Num_bomb","slay")

func has_smaller_id_numeric_bomb():
	for bomb in get_parent().get_children():
		if bomb is NumericBomb and bomb.id < id:
			return true
	return false
