extends Area2D

var damage := 1
var speed := 100
var velocity:Vector2
var friction := 0
var hit_something := false


func _ready():
	pass


func _physics_process(delta):
	if not hit_something:
		velocity = velocity.linear_interpolate(Vector2.ZERO, friction)
		position += velocity * delta
		if velocity == Vector2.ZERO:
			hit_something = true
			die()


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func die():
	yield(get_tree().create_timer(2), "timeout")
	queue_free()


func _on_EnemyBullet_body_entered(body):
	if body.is_in_group("player_hitbox"):
		if not hit_something:
			hit_something = true
			if body.has_method("hurt"):
				body.hurt()
			queue_free()


func _on_EnemyBullet_area_entered(area):
	if area.is_in_group("player_hitbox"):
		if not hit_something:
			hit_something = true
			if area.has_method("hurt"):
				area.hurt()
			queue_free()
