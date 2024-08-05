extends Control

signal pressed

@export var start_button_effect: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	%Timer1.start()
	await get_tree().create_timer(0.3).timeout
	%Timer2.start()


func _on_button_pressed():
	SoundManager.play("sfx_menu","start")
	pressed.emit()

# TODO 타이머로부터 시그널 받아서 Panel 복제하여 scale 키우는 이펙트 구현하기

func _on_timer_timeout():
	var new_effect: Panel = %Effect.duplicate()
	%EffectHolder.add_child(new_effect)
	new_effect.visible = true
	Utils.tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)\
		.tween_property(new_effect, "modulate", Color(255, 255, 255, 0), 0.5)
	var tween = Utils.tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(new_effect, "scale", Vector2(1.3, 1.3), 0.5)
	tween.tween_callback(new_effect.queue_free)