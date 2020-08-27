extends KinematicBody2D

signal player_died

enum States {ALIVE, DEAD, SLEEP}

const max_velocity := Vector2(1000, 1200)
const max_focused_velocity := Vector2(500, 600)
const acceleration := 0.1
const friction := 0.05

const max_v_angle := 45
const max_h_angle := 15

const max_lives := 2


var state = States.ALIVE
var lives := max_lives

var input_velocity:Vector2
var velocity:Vector2
var is_focused = false

var scene_bullet := preload("res://src/entities/PlayerBullet.tscn")
var scene_fire := preload("res://src/entities/PlayerFire.tscn")
var scene_heart := preload("res://src/TextureHeart.tscn")

var scene_arrow := preload("res://src/Arrow.tscn")

var node_bullets:Node

var sounds = {
	"shot" : preload("res://assets/se/shot.wav"),
	"hurt" : preload("res://assets/se/player_hurt.wav"),
	"burst" : preload("res://assets/se/fire.wav"),
	"pichun" : preload("res://assets/se/pichun.wav"),
	"warning" : preload("res://assets/se/warning.wav"),
	}

onready var animation_player := $AnimationPlayer


func _ready():
	node_bullets = get_tree().get_nodes_in_group("node_bullets")[0]
	set_text()


func set_text():
	$CanvasLayer/UI/Score/Label.text = tr("SCORE")


func _unhandled_key_input(_event):
	if state == States.DEAD:
		return
	get_movement()
	if Input.is_action_pressed("ui_accept") and not animation_player.is_playing():
		animation_player.play("shoot")
	elif Input.is_action_just_released("ui_accept"):
		animation_player.play("shoot_fire")
	
	# DEBUG
	if Input.is_key_pressed(KEY_MINUS):
		hurt()

func _physics_process(_delta):
	if input_velocity.length() > 0:
		velocity = velocity.linear_interpolate(input_velocity, acceleration)
	else:
		velocity = velocity.linear_interpolate(Vector2.ZERO, friction)
	velocity = move_and_slide(velocity)


func _process(_delta):
	if state == States.DEAD:
		return
	if is_focused:
		$HitboxShot.visible = true
	else:
		$HitboxShot.visible = false
	
	if velocity.x > 10:
		$RotationHelper.scale.x = -1
	elif velocity.x < -10:
		$RotationHelper.scale.x = 1
	
	$RotationHelper.rotation_degrees = (
			$RotationHelper.scale.x *  
			-1 * max_v_angle * velocity.y / max_velocity.y
			)
	$RotationHelper/Sprite.rotation_degrees = (
		$RotationHelper.scale.x * max_h_angle * velocity.x / max_velocity.x
	)

func get_movement():
	var _x = (Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"))
	var _y = (Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up"))
	
	if Input.get_action_strength("focus") > 0:
		is_focused = true
		input_velocity = Vector2(_x, _y) * max_focused_velocity
	else:
		is_focused = false
		input_velocity = Vector2(_x, _y) * max_velocity


func shoot():
	var weapons = get_tree().get_nodes_in_group("weapons")
	weapons.shuffle()
	for weapon in weapons:
		var bullet = scene_bullet.instance()
		bullet.global_position = weapon.global_position
		bullet.velocity = Vector2(-$RotationHelper.scale.x, 0).rotated(deg2rad($RotationHelper.rotation_degrees)) * bullet.speed
		
		node_bullets.add_child(bullet)
		
		play_sound("shot")


func shoot_fire():
	var weapon = $RotationHelper/Weapon
	
	var bullet = scene_fire.instance()
	bullet.global_position = weapon.global_position
	bullet.velocity = Vector2(-$RotationHelper.scale.x, 0).rotated(deg2rad($RotationHelper.rotation_degrees)) * bullet.speed
	bullet.get_node("Sprite").rotate(bullet.velocity.angle())
	
	node_bullets.add_child(bullet)
	
	play_sound("burst")


func hurt():
	if lives > 0:
		play_sound("hurt")
		lives -= 1
		if lives <= 0:
			die()
		if lives == 1:
			play_sound("warning")
		update_ui()
		var bullets = get_tree().get_nodes_in_group("enemy_bullets")
		for bullet in bullets:
			bullet.queue_free()


func die():
	state = States.DEAD
	play_sound("pichun")
	$AnimationPlayer.play("die")
	yield($AnimationPlayer, "animation_finished")
	emit_signal("player_died")


func update_ui():
	while $CanvasLayer/UI/Lives.get_child_count() > lives:
		var heart = $CanvasLayer/UI/Lives.get_child(0)
		$CanvasLayer/UI/Lives.remove_child(heart)
		heart.queue_free()
		$CanvasLayer/UI/AnimationPlayer.play("hurt")
	while $CanvasLayer/UI/Lives.get_child_count() < lives:
		var heart = scene_heart.instance()
		$CanvasLayer/UI/Lives.add_child(heart)
		$CanvasLayer/UI/AnimationPlayer.play("heal")


func make_arrow(target):
	var arrow = scene_arrow.instance()
	arrow.target = target
	$Arrows.add_child(arrow)


func play_sound(sound):
	if BgmControl.option_sound:
		$AudioStreamPlayer.stream = sounds[sound]
		$AudioStreamPlayer.play()
