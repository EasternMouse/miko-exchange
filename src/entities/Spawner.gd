extends StaticBody2D

signal on_death

const MAP_EDGE = Vector2(3840,2160)

var sound = preload("res://assets/se/seal.wav")
var director:Node

var burst:int
var current_pack:Array = ["Mob"]
var is_dead := false

func _ready():
	director = get_parent()
	var player = get_tree().get_nodes_in_group("player")[0]
	player.make_arrow(self)


func burst_spawn():
	for _i in range(burst):
		spawn_random_mob()
		yield(get_tree().create_timer(0.1), "timeout")


func spawn_random_mob():
	var number = randi() % current_pack.size()
	spawn_mob(current_pack[number]) 


func spawn_mob(mob):
	director.spawn_mob(self.get_node("Mobs"), mob)


func _on_Timer_timeout():
	if not is_dead:
		burst_spawn()

func die():
	if not is_dead:
		is_dead = true
		$CollisionShape2D.set_deferred("disabled", true)
		play_sound()
		$AnimationPlayer.play("death")
		for child in $Mobs.get_children():
			child.die()
			yield(get_tree().create_timer(0.01), "timeout")
		if $AnimationPlayer.is_playing():
			yield($AnimationPlayer, "animation_finished")
		get_parent().remove_child(self)
		emit_signal("on_death")
		queue_free()

func play_sound():
	if BgmControl.option_sound:
		$AudioStreamPlayer.stream = sound
		$AudioStreamPlayer.play()
