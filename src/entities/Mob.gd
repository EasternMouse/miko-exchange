extends KinematicBody2D

signal on_death()

enum AiType {STATIONARY, CHASE}
enum ShootType {NONE, SIMPLE, SHORT, FAST, LASER}

const acceleration := 0.2
const friction := 0.1

export var max_lives := 10
export var max_velocity := Vector2(100, 120)
export(AiType) var ai = AiType.CHASE
export(ShootType) var shoot_type = ShootType.NONE
export var shoot_cooldown := 1
export var score_worth := 100

var player:KinematicBody2D
var node_bullets
var velocity:Vector2
var lives := max_lives
var is_dead := false

var bullet_scene = preload("res://src/entities/EnemyBullet.tscn")
var lazer_scene = preload("res://src/entities/EnemyLazer.tscn")

func _ready():
	player = get_tree().get_nodes_in_group("player")[0]
	node_bullets = get_tree().get_nodes_in_group("node_bullets")[0]
	if shoot_type != ShootType.NONE:
		$ShootingTimer.start(shoot_cooldown)


func _physics_process(_delta):
	if is_dead:
		return
	movement()


func movement():
	if ai == AiType.STATIONARY:
		pass
	elif ai == AiType.CHASE:
		if (global_position.distance_to(player.global_position) > 200 
				or global_position.distance_to(player.global_position) < 100):
			var target = player.global_position - global_position.direction_to(player.global_position) * 150
			var direction = global_position.direction_to(target)
			velocity = velocity.linear_interpolate(direction * max_velocity, acceleration)
		else:
			velocity = velocity.linear_interpolate(Vector2.ZERO, friction)
		velocity = move_and_slide(velocity)


func _process(_delta):
	if velocity.x > 1:
		$Sprite.flip_h = false
	elif velocity.x < -1:
		$Sprite.flip_h = true


func _on_ShootingTimer_timeout():
	if is_dead:
		return
	match shoot_type:
		ShootType.NONE:
			return
		ShootType.SIMPLE:
			var bullet = bullet_scene.instance()
			bullet.global_position = (
					global_position
					+ global_position.direction_to(player.global_position)
					* 10)
			bullet.velocity = (
					global_position.direction_to(player.global_position) 
					* bullet.speed)
			node_bullets.add_child(bullet)
		ShootType.SHORT:
			pass
		ShootType.LASER:
			if global_position.distance_to(player.global_position) <= 1000:
				$ShootingTimer.paused = false
				var lazer = lazer_scene.instance()
				lazer.global_position = (
						global_position
						+ global_position.direction_to(player.global_position)
						* 10)
				node_bullets.add_child(lazer)
				lazer.look_at(player.global_position)
			else:
				$ShootingTimer.paused = true
				yield(get_tree().create_timer(0.2), "timeout")
				_on_ShootingTimer_timeout()


func hurt(damage):
	lives -= damage
	if lives <= 0 and not is_dead:
		die()


func die():
	Events.emit_signal("scored", score_worth)
	is_dead = true
	$CollisionShape2D.set_deferred("disabled", true)
	$AnimationPlayer.play("death")
	yield($AnimationPlayer, "animation_finished")
	if is_inside_tree():
		get_parent().remove_child(self)
		emit_signal("on_death")
	queue_free()


func _on_CollisionWithSpawnerTimer_timeout():
	collision_mask = 7
	$VisibilityEnabler2D.freeze_bodies = true
	$VisibilityEnabler2D.physics_process_parent = true
	$VisibilityEnabler2D.process_parent = true


func _on_VisibilityEnabler2D_screen_exited():
	$ShootingTimer.paused = true


func _on_VisibilityEnabler2D_screen_entered():
	$ShootingTimer.paused = false
