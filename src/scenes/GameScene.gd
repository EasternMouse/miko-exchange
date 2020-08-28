extends Node2D

onready var trail = $Trail

func _ready():
	if self.name == "TutorialGameScene":
		#BgmControl.start_playing("res://assets/bgm/01_shoujo_kisoukyoku_171.ogg")
		pass
	else:
		#BgmControl.start_playing("res://assets/bgm/02_koiiro_fms_167.ogg")
		pass
	
	var player = get_tree().get_nodes_in_group("player")[0]
	player.connect("player_died", self, "on_player_death")


func _unhandled_input(_event):
	if Input.is_key_pressed(KEY_ESCAPE):
		$PauseScreen/ColorRect.visible = true
		get_tree().paused = true
		$PauseScreen/ColorRect/MarginContainer/VBoxContainer/ButtonContinue.grab_focus()


func _physics_process(_delta):
	trail.add_point($Player.global_position)
	if trail.get_point_count() > 100:
		trail.remove_point(0)
	var end0 = trail.points[trail. get_point_count()-1]
	var begin0 = trail.points[trail. get_point_count()-2]

	if trail.get_point_count() > 51:
		for i in range(trail.get_point_count()-51):
			var intersection = get_segment_intersection(begin0, end0, 
					trail.points[i], trail.points[i+1])
			if intersection != null:
				trail.remove_point(trail.get_point_count()-1)
				for _j in range(i):
					trail.remove_point(0)
				
				var area = Area2D.new()
				area.collision_mask = 2
				var collision = CollisionPolygon2D.new()
				collision.polygon = trail.points
				area.add_child(collision)
				add_child(area)
				area.connect("body_entered", self, "spawner_detected")
				trail.clear_points()
				var timer = Timer.new()
				area.add_child(timer)
				timer.start(0.5)
				timer.connect("timeout", area, "queue_free")
				return


func spawner_detected(body:Node):
	if body.is_in_group("spawner"):
		body.die()

static func get_segment_intersection(a, b, c, d):
	var cd = d - c
	var ab = b - a
	var div = cd.y * ab.x - cd.x * ab.y

	if abs(div) > 0.001:
		var ua = (cd.x * (a.y - c.y) - cd.y * (a.x - c.x)) / div
		var ub = (ab.x * (a.y - c.y) - ab.y * (a.x - c.x)) / div
		var intersection = a + ua * ab
		if ua >= 0.0 and ua <= 1.0 and ub >= 0.0 and ub <= 1.0:
			return intersection
		return null
	return null

func on_player_death():
	$DeathScreen/ColorRect.visible = true
	get_tree().paused = true
	$DeathScreen/ColorRect/MarginContainer/VBoxContainer/ButtonRetry.grab_focus()

func _on_ButtonContinue_pressed():
	$PauseScreen/ColorRect.visible = false
	get_tree().paused = false
	$PauseScreen/ColorRect/MarginContainer/VBoxContainer/ButtonContinue.release_focus()
