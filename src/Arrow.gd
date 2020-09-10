extends Node2D


var target:Node

func _ready():
	pass

func _process(_delta):
	if is_inside_tree() and not is_queued_for_deletion():
		visible = true
		look_at(target.global_position)

func die():
	queue_free()
