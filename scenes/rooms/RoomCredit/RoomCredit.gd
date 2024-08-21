extends Control

var RoomMenu_room = "res://scenes/rooms/RoomMenu/RoomMenu.tscn"
var RoomShuffleGame_room = "res://scenes/rooms/RoomCredit/RoomShuffleGame.tscn"

@export var credits: Array = [
	["Team", "Slay The Circle\n(STC)"],
	["Korea Univ.", "CAT&DOG"],
	["Jo Kangwoo", "Team Leader\nPM\nProgrammer\nGraphic Designer"],
	["Lee Jinwoong", "Programmer\nLevel Manager"],
	["Kang Geunho", "Programmer\nLevel Designer"],
	["Park jooyoung", "Programmer\nGraphic Designer"],
	["J. Seonghyeon", "Programmer\nGraphic Designer\n\nToo long name.."],
	["Kim Kiyong", "Programmer\nLevel Manager"],
	["Kim Jinhyun", "Programmer\nLevel Designer"],
	["Bae Sekang", "Programmer\nLevel Designer"],
	["Hong Seokhee", "Programmer\nLevel Manager"],
	["Park Jaeyong", "Programmer\nSound Designer"],
]

@export var role_label: Label
@export var name_label: Label
@export var logo_text: Label

@export var display_duration: float = 2.0
@export var logo_display_duration: float = 2.0
@export var name_offset: float = 96.0
@export var interval_time: float = 0.2
@export var wait_time: float = display_duration * 0.5

@export var role_label_start_position: Vector2 = Vector2(0, 512)
@export var logo_text_start_position: Vector2 = Vector2(200, 704)

@export var role_label_mid_position: Vector2 = Vector2(0, 0)
@export var logo_text_mid_position: Vector2 = Vector2(200, 288)

@export var role_label_end_position: Vector2 = Vector2(0, -512)
@export var logo_text_end_position: Vector2 = Vector2(200, -128)

var current_index = -1

func _ready():
	PlayingFieldInterface.set_theme_color(Color.WHITE)
	PlayingFieldInterface.set_theme_bright(0)

	await Utils.timer(0.5)
	start_credit_roll()
	
	#음악 트는 코드입니다. 혹시몰라서 넣어놨습니다...
	MusicManager.play("bgm_RC","main_slow",0,1)

func start_credit_roll():
	if current_index == -1:
		logo_text.position = logo_text_start_position
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
				%TextBox,
				"position",
				role_label_mid_position,
				display_duration
			)

			await Utils.timer(display_duration + wait_time)

			var role_end_tween: Tween = get_tree().create_tween()
			role_end_tween.set_ease(Tween.EASE_IN_OUT)
			role_end_tween.set_trans(Tween.TRANS_SINE)
			role_end_tween.tween_property(
				%TextBox,
				"position",
				role_label_end_position,
				display_duration
			)

			await Utils.timer(display_duration)
			on_role_tween_finished()
			on_name_tween_finished()
		else:
			Utils.tween().set_ease(Tween.EASE_IN_OUT).tween_property(%Circle, "modulate", Color(1, 1, 1, 0.1), 3)
			await Utils.timer(3.0)
			current_index = -1
			start_credit_roll()

func on_logo_finished():
	current_index += 1
	Utils.tween().set_ease(Tween.EASE_IN_OUT).tween_property(%Circle, "modulate", Color.WHITE, 2)
	start_credit_roll()

func on_role_tween_finished():
	current_index += 1

func on_name_tween_finished():
	%TextBox.position = role_label_start_position
	start_credit_roll()

func _on_to_credit_pressed():
	SoundManager.play("sfx_RC","select")
	get_tree().change_scene_to_file(RoomMenu_room)

func _on_to_shuffle_game_pressed():
	SoundManager.play("sfx_RC","select")
	get_tree().change_scene_to_file(RoomShuffleGame_room)
