extends Node2D

var color:Color

func _ready():
	color = Color(randf(), randf(), randf(), 0.5)
	modulate = color
	pass
