extends Node2D


var target:Node

func _ready():
	pass

func _process(_delta):
	if is_inside_tree() and not is_queued_for_deletion():
		visible = true
		if is_instance_valid(target):
			look_at(target.global_position)
		else:
			queue_free()
