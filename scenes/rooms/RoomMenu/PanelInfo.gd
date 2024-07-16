extends Node2D
class_name PanelInfo

@export var info0: String
@export var info1: String
@export var info2: String

@export var label0: Label
@export var shadow0: Label
@export var label1: Label
@export var shadow1: Label
@export var label2: Label
@export var shadow2: Label

func _ready():
	label0.text = info0
	shadow0.text = info0
	label1.text = info1
	shadow1.text = info1
	label2.text = info2
	shadow2.text = info2
