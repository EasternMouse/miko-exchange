extends Area2D

var damage := 20
var speed := 2000
var velocity:Vector2
var hit_something := false
var collided_objects:Array
var max_hits := 10


func _ready():
	pass


func _physics_process(delta):
	position += velocity*delta


func _on_VisibilityNotifier2D_screen_exited():
	die()


func _on_PlayerFire_area_entered(area):
	if area.is_in_group("enemies"):
		if not collided_objects.has(area):
			collided_objects.append(area)
			if area.has_method("hurt"):
				area.hurt(damage)
				if collided_objects.size() >= max_hits:
					die()


func _on_PlayerFire_body_entered(body):
	if body.is_in_group("enemies"):
		if not collided_objects.has(body):
			collided_objects.append(body)
			if body.has_method("hurt"):
				body.hurt(damage)
				if collided_objects.size() >= max_hits:
					die()


func die():
	queue_free()
