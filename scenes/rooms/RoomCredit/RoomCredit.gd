extends Control

var RoomMenu_room = "res://scenes/rooms/RoomMenu/RoomMenu.tscn"

@export var credits: Array = [
	["Team", "Slay The Circle(STC)"],
	["Korea University", "CAT&DOG"],
	["Jo Kangwoo", "Team Leader\n\nPlanning\n\nPM\n\nProgrammer\n\nGraphic Designer"],
	["Lee Jinwoong", "Programmer\n\nLevel Manager"],
	["Kang Geunho", "Programmer\n\nLevel Designer"],
	["Park jooyoung", "Programmer\n\nGraphic Designer"],
	["Jeong Seonghyeon", "Programmer\n\nGraphic Designer"],
	["Kim Kiyong", "Programmer\n\nLevel Manager"],
	["Kim Jinhyun", "Programmer\n\nLevel Designer"],
	["Bae Sekang", "Programmer\n\nLevel Designer"],
	["Hong Seokhee", "Programmer\n\nLevel Manager"],
	["Park Jaeyong", "Programmer\n\nSound Designer"],
]

@export var role_label: Label
@export var name_label: Label
@export var logo_text: Label

@export var display_duration: float = 2.0
@export var logo_display_duration: float = 2.0
@export var name_offset: float = 96.0
@export var interval_time: float = 0.2
@export var wait_time: float = display_duration * 0.5

@export var role_label_start_position: Vector2 = Vector2(400, 704)
@export var name_label_start_position: Vector2 = Vector2(500, 704 + name_offset)
@export var logo_text_start_position: Vector2 = Vector2(200, 704)

@export var role_label_mid_position: Vector2 = Vector2(400, 288)
@export var name_label_mid_position: Vector2 = Vector2(500, 288 + name_offset)
@export var logo_text_mid_position: Vector2 = Vector2(200, 288)

@export var role_label_end_position: Vector2 = Vector2(400, -128)
@export var name_label_end_position: Vector2 = Vector2(500, -128 + name_offset)
@export var logo_text_end_position: Vector2 = Vector2(200, -128)

var current_index = -1

func _ready():
	role_label.position = role_label_start_position
	name_label.position = name_label_start_position
	logo_text.position = logo_text_start_position

	name_label.set_scale(Vector2(0.6, 0.6))
	role_label.set_scale(Vector2(1.0, 1.0))
	logo_text.set_scale(Vector2(1.5, 1.5))

	await Utils.timer(0.5)
	start_credit_roll()
	
	#음악 트는 코드입니다. 혹시몰라서 넣어놨습니다...
	MusicManager.play("bgm_RC","main_slow",0,1)

func start_credit_roll():
	if current_index == -1:
		logo_text.text = "Slay The Circle"
		var logo_mid_tween: Tween = get_tree().create_tween()
		logo_mid_tween.set_ease(Tween.EASE_IN_OUT)
		logo_mid_tween.set_trans(Tween.TRANS_SINE)
		logo_mid_tween.tween_property(
			logo_text,
			"position",
			logo_text_mid_position,
			logo_display_duration
		)
		await Utils.timer(logo_display_duration + wait_time)

		var logo_end_tween: Tween = get_tree().create_tween()
		logo_end_tween.set_ease(Tween.EASE_IN_OUT)
		logo_end_tween.set_trans(Tween.TRANS_SINE)
		logo_end_tween.tween_property(
			logo_text,
			"position",
			logo_text_end_position,
			logo_display_duration
		)
		logo_end_tween.finished.connect(on_logo_finished)
	else:
		if current_index < credits.size():
			var role = credits[current_index][0]
			var name = credits[current_index][1]

			role_label.text = role
			name_label.text = name

			var role_mid_tween: Tween = get_tree().create_tween()
			role_mid_tween.set_ease(Tween.EASE_IN_OUT)
			role_mid_tween.set_trans(Tween.TRANS_SINE)
			role_mid_tween.tween_property(
				role_label,
				"position",
				role_label_mid_position,
				display_duration
			)

			var name_mid_tween: Tween = get_tree().create_tween()
			name_mid_tween.set_ease(Tween.EASE_IN_OUT)
			name_mid_tween.set_trans(Tween.TRANS_SINE)
			name_mid_tween.tween_property(
				name_label,
				"position",
				name_label_mid_position,
				display_duration
			)
			await Utils.timer(display_duration + wait_time)

			var role_end_tween: Tween = get_tree().create_tween()
			role_end_tween.set_ease(Tween.EASE_IN_OUT)
			role_end_tween.set_trans(Tween.TRANS_SINE)
			role_end_tween.tween_property(
				role_label,
				"position",
				role_label_end_position,
				display_duration
			)

			var name_end_tween: Tween = get_tree().create_tween()
			name_end_tween.set_ease(Tween.EASE_IN_OUT)
			name_end_tween.set_trans(Tween.TRANS_SINE)
			name_end_tween.tween_property(
				name_label,
				"position",
				name_label_end_position,
				display_duration
			)
			await Utils.timer(display_duration)
			on_role_tween_finished()
			on_name_tween_finished()
		else:
			await Utils.timer(3.0)
			current_index = -1
			start_credit_roll()

func on_logo_finished():
	current_index += 1
	start_credit_roll()

func on_role_tween_finished():
	current_index += 1

func on_name_tween_finished():
	if current_index < credits.size():
		role_label.visible = false
		name_label.visible = false
		role_label.position = role_label_start_position
		name_label.position = name_label_start_position
		role_label.visible = true
		name_label.visible = true
		start_credit_roll()


func _on_to_credit_pressed():
	get_tree().change_scene_to_file(RoomMenu_room)
