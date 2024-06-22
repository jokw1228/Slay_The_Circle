extends Area2D
class_name Bomb # virtual class

func slayed():
	# virtual method
	pass

func exploded():
	# virtual method
	pass

func _on_body_entered(body):
	if body is Player:
		slayed()
