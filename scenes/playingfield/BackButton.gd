extends Node2D

signal back

@export var timer0: Timer
@export var timer1: Timer
@export var back_button_effect: PackedScene

func _ready():
	timer0.start()
	await get_tree().create_timer(0.3).timeout
	timer1.start()

func _on_button_pressed():
	back.emit()

func _on_timer_timeout():
	var effect = back_button_effect.instantiate()
	effect.position = Vector2(242.235, 89.985)
	add_child(effect)
