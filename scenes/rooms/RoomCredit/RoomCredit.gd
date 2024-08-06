extends Control

@export var Background_node: Sprite2D
@export var GameLogo: Label
@export var CreditText: Label

signal credit_on
signal credit_reset

var is_credit_on = 0
var start_pos = null
var end_pos = null
var credit_time = 14.0
var interval_time = 2.0

func _ready():
	GameLogo.visible = false
	CreditText.visible = true
	
	
	#Label 가운데 정렬
	GameLogo.anchor_left = 0.5
	GameLogo.anchor_top = 0.5
	GameLogo.anchor_right = 0.5
	GameLogo.anchor_bottom = 0.5
	# Pivot offset을 가운데로 설정 (Label 크기의 절반)
	GameLogo.pivot_offset = GameLogo.size / 2
	
	start_pos = Vector2(GameLogo.position.x,660)
	end_pos = Vector2(GameLogo.position.x,-100)
	
	GameLogo.position = start_pos
	CreditText.position = start_pos
	
	await get_tree().create_timer(interval_time*2).timeout
	emit_signal("credit_on")
	
	
	
	

func _on_credit_on():
	#Credit 음악 재생
	print("hi")
	for credit_var in range (1,5,1):
		if credit_var == 1:
			GameLogo.visible = true
			CreditText.visible = true
			var logo_tween: Tween = get_tree().create_tween()
			logo_tween.tween_property(GameLogo, "position", end_pos, credit_time)
			await get_tree().create_timer(interval_time).timeout	
			var text_tween: Tween = get_tree().create_tween()
			text_tween.tween_property(CreditText, "position", end_pos, credit_time)
			await get_tree().create_timer(credit_time).timeout	
		elif credit_var == 2:
			emit_signal("credit_reset")
		await get_tree().create_timer(2.0).timeout


func _on_credit_reset():
	GameLogo.visible = false
	CreditText.visible = false
	GameLogo.position = start_pos
	CreditText.position = start_pos
	await get_tree().create_timer(3.0).timeout
	emit_signal("credit_on")
