extends Area2D

var hit_something := false

func _ready():
	pass


func _on_EnemyBullet_area_entered(area):
	if area.is_in_group("player_hitbox"):
		if not hit_something:
			hit_something = true
			if area.has_method("hurt"):
				area.hurt()
			queue_free()


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	queue_free()
