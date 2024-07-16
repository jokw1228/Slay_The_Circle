extends Node2D
class_name PanelStage

@export var difficulty: int
@export var stage_name: String

@export var label: Label
@export var shadow: Label
@export var star0: Sprite2D
@export var star1: Sprite2D
@export var star2: Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	label.text = stage_name
	shadow.text = stage_name
	if difficulty < 2: star2.visible = false
	if difficulty < 1: star1.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
