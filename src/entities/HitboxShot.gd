extends Area2D


func _ready():
	pass

func hurt():
	get_parent().hurt()
