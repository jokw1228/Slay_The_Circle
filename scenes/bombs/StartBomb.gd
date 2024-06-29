extends Bomb
class_name StartBomb

signal started

func slayed():
	started.emit()
	super()
