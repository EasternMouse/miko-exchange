extends Node

signal scene_changed()

onready var animation_player:AnimationPlayer = $AnimationPlayer
onready var fade:ColorRect = $FadeLayer/ColorRect


func _ready():
	pass


func change_scene(path, delay = 0.0):
	if delay > 0.0:
		yield(get_tree().create_timer(delay), "timeout")
	animation_player.play("fade")
	yield(animation_player, "animation_finished")
	if not get_tree().change_scene(path) == OK:
		print("Can't change scene!")
	get_tree().paused = false
	animation_player.play_backwards("fade")
	yield(animation_player, "animation_finished")
	emit_signal("scene_changed")


func quit():
	animation_player.play("fade")
	yield(animation_player, "animation_finished")
	get_tree().quit()
