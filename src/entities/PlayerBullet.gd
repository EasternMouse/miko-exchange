extends Area2D

var damage := 4
var speed := 2000
var velocity:Vector2
var hit_something := false


func _ready():
	pass


func _physics_process(delta):
	position += velocity * delta


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_PlayerBullet_body_entered(body):
	if body.is_in_group("enemies"):
		if not hit_something:
			hit_something = true
			if body.has_method("hurt"):
				body.hurt(damage)
			die()


func die():
	$VisibilityNotifier2D.disconnect("screen_exited", self, "_on_VisibilityNotifier2D_screen_exited")
	$CollisionShape2D.set_deferred("disabled", true)
	$Sprite.visible = false
	velocity = Vector2.ZERO
	$Particles2D.emitting = true
	yield(get_tree().create_timer(1.0), "timeout")
	queue_free()
