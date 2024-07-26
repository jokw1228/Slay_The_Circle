extends Node2D

signal start

@export var timer0: Timer
@export var timer1: Timer
@export var start_button_effect: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	timer0.start()
	await get_tree().create_timer(0.3).timeout
	timer1.start()


func _on_button_pressed():
	SoundManager.play("sfx_menu","start")
	start.emit()



func _on_timer_timeout():
	var effect = start_button_effect.instantiate()
	effect.position = Vector2(-592.765, 203.985)
	add_child(effect)
