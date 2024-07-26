extends BombGenerator

func _ready():

	'''

	#1번 패턴. 가장자리로 이동하게 하는 무난한 난이도의 패턴
	create_hazard_bomb(Vector2(100, 0), 3, 6)
	create_normal_bomb(Vector2(200, 0), 3, 6)
	
	create_hazard_bomb(Vector2(-100, 0), 3, 6)
	create_normal_bomb(Vector2(-200, 0), 3, 6)
	
	create_hazard_bomb(Vector2(0, 100), 3, 6)
	create_normal_bomb(Vector2(0, 200), 3, 6)
	
	create_hazard_bomb(Vector2(0, -100), 3, 6)
	create_normal_bomb(Vector2(0, -200), 3, 6)
	pass


	#2번 패턴. 일적선의 섬세한 컨트롤을 요구하는 패턴
	create_normal_bomb(Vector2(0, 0), 3, 6)
	
	create_hazard_bomb(Vector2(-75, -100), 3, 6)
	create_hazard_bomb(Vector2(-75, 0), 3, 6)
	create_hazard_bomb(Vector2(-75, 100), 3, 6)
	create_hazard_bomb(Vector2(75, -100), 3, 6)
	create_hazard_bomb(Vector2(75, 0), 3, 6)
	create_hazard_bomb(Vector2(75, 100), 3, 6)
	pass
	

	#3번 패턴. 빠른 연타를 요구하는 패턴.
	create_normal_bomb(Vector2(0, -200), 3, 6)
	create_normal_bomb(Vector2(0, -100), 3, 6)
	create_normal_bomb(Vector2(0, 0), 3, 6)
	create_normal_bomb(Vector2(0, 100), 3, 6)
	create_normal_bomb(Vector2(0, 200), 3, 6)
	
	create_normal_bomb(Vector2(100, -100), 3, 6)
	create_normal_bomb(Vector2(100, 0), 3, 6)
	create_normal_bomb(Vector2(100, 100), 3, 6)

	create_normal_bomb(Vector2(-100, -100), 3, 6)
	create_normal_bomb(Vector2(-100, 0), 3, 6)
	create_normal_bomb(Vector2(-100, 100), 3, 6)
	
	create_normal_bomb(Vector2(200, 0), 3, 6)

	create_normal_bomb(Vector2(-200, 0), 3, 6)
	pass

	#4번 패턴.<오류> 3번 패턴과 비슷하지만 속지말고 링크 폭탄을 잘 제거해야한다.
	var link1_1 = create_normal_bomb(Vector2(0, -200), 3, 6)
	create_normal_bomb(Vector2(0, -100), 3, 6)
	create_normal_bomb(Vector2(0, 0), 3, 6)
	create_normal_bomb(Vector2(0, 100), 3, 6)
	var link1_2 = create_normal_bomb(Vector2(0, 200), 3, 6)
	
	create_normal_bomb(Vector2(100, -100), 3, 6)
	create_normal_bomb(Vector2(100, 0), 3, 6)
	create_normal_bomb(Vector2(100, 100), 3, 6)

	create_normal_bomb(Vector2(-100, -100), 3, 6)
	create_normal_bomb(Vector2(-100, 0), 3, 6)
	create_normal_bomb(Vector2(-100, 100), 3, 6)
	
	var link2_1 = create_normal_bomb(Vector2(200, 0), 3, 6)

	var link2_2 = create_normal_bomb(Vector2(-200, 0), 3, 6)
	
	create_bomb_link(link1_1, link1_2)
	create_bomb_link(link2_1, link2_2)
	
	pass

	#4번 패턴 대체. 막 누르지 말라는 경고의 의미를 가지는 정지패턴
	create_hazard_bomb(Vector2(0, 0), 3, 6)
	create_hazard_bomb(Vector2(75, 75), 3, 6)
	create_hazard_bomb(Vector2(75, -75), 3, 6)
	create_hazard_bomb(Vector2(150, 150), 3, 6)
	create_hazard_bomb(Vector2(150, -150), 3, 6)
	
	create_hazard_bomb(Vector2(-75, 75), 3, 6)
	create_hazard_bomb(Vector2(-75, -75), 3, 6)
	create_hazard_bomb(Vector2(-150, 150), 3, 6)
	create_hazard_bomb(Vector2(-150, -150), 3, 6)
	pass

	#5번 패턴.<오류> 짜증나라고 만든 패턴. 순서를 잘 고려해야한다. <오류>
	create_numeric_bomb(Vector2(-150, 0), 3, 6 ,1)
	create_numeric_bomb(Vector2(75, 0), 3, 6, 2)
	create_numeric_bomb(Vector2(-75, 0), 3, 6, 3)
	create_numeric_bomb(Vector2(150, 0), 3, 6, 4)
	pass

	#5번 패턴 대체. 그림 모양 패턴도 있으면 예쁠 것 같아서 추가한 별 모양 패턴.

	for i in (5):
		create_normal_bomb(Vector2(cos(((2 * PI)/5 * i) + (1 * PI)/10), sin(((2 * PI)/5 * i) + (1 * PI)/10)) * 120, 3, 6)
		create_normal_bomb(Vector2(cos(((2 * PI)/5 * i) + (1 * PI)/10), sin(((2 * PI)/5 * i) + (1 * PI)/10)) * -200, 3, 6)

	#6번 패턴. 대각선 틈새로 이동하게 해 긴장감을 주는 패턴.
	create_normal_bomb(Vector2(100, 100), 3, 6)
	create_hazard_bomb(Vector2(100, 0), 3, 6)
	create_normal_bomb(Vector2(100, -100), 3, 6)
	
	create_hazard_bomb(Vector2(0, 100), 3, 6)
	create_normal_bomb(Vector2(0, 0), 3, 6)
	create_hazard_bomb(Vector2(0,-100), 3, 6)
	
	create_normal_bomb(Vector2(-100, 100), 3, 6)
	create_hazard_bomb(Vector2(-100, 0), 3, 6)
	create_normal_bomb(Vector2(-100, -100), 3, 6)

	'''
	pass

	
