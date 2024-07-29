extends BombGenerator

func _ready():
	# hazard 폭탄 고리. 카운트다운 이후 플레이 영역 원의 테두리 전체에 hazard 폭탄이 잠깐 나타났다 사라진다. 줄넘기하듯 피해야함.
	create_hazard_bomb(Vector2(250, 0), 3, 0.5)
	create_hazard_bomb(Vector2(-250, 0), 3, 0.5)
	create_hazard_bomb(Vector2(0,250), 3, 0.5)
	create_hazard_bomb(Vector2(0,-250), 3, 0.5)
	create_hazard_bomb(Vector2(177,177), 3, 0.5)
	create_hazard_bomb(Vector2(-177,177), 3, 0.5)
	create_hazard_bomb(Vector2(177,-177), 3, 0.5)
	create_hazard_bomb(Vector2(-177,-177), 3, 0.5)
	pass # 폭탄 개수를 촘촘하게 할 수도 있다.
# hazard 폭탄의 경우 이론상 가만히 앉아서 피할 수도 있는데, 이 패턴은 그 전술을 막는다.
