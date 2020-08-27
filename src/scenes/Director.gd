extends Node

export var is_tutorial := false

const MAP_START = Vector2(400,400)
const MAP_EDGE = Vector2(3840,2160)-MAP_START


var scene_spawner = preload("res://src/entities/Spawner.tscn")

var mobs = {
	"Mob" : preload("res://src/entities/Mob.tscn"),
	"Friend" : preload("res://src/entities/mobs/Friend.tscn"),
	"GreenSpirit" : preload("res://src/entities/mobs/GreenSpirit.tscn"),
	"RedSpirit" : preload("res://src/entities/mobs/RedSpirit.tscn"),
	"Spirit" : preload("res://src/entities/mobs/Spirit.tscn"),
}

var levels = {
	0 : {
		"pack" : ["Mob"],
		"burst" : 3,
		"spawners" : 1,
	},
	1 : {
		"pack" : ["Spirit", "Spirit", "Spirit", "Spirit", "RedSpirit"],
		"burst" : 15,
		"spawners" : 3,
	},
	2 : {
		"pack" : ["Spirit", "Spirit", "Spirit", "RedSpirit"],
		"burst" : 20,
		"spawners" : 4,
	},
	3 : {
		"pack" : ["Spirit", "Spirit", "Spirit", "Spirit", "GreenSpirit"],
		"burst" : 20,
		"spawners" : 4,
	},
	4 : {
		"pack" : ["RedSpirit", "GreenSpirit"],
		"burst" : 8,
		"spawners" : 4,
		},
	5 : {
		"pack" : ["RedSpirit", "GreenSpirit"],
		"burst" : 20,
		"spawners" : 3,
	},
}


var current_level := 1
var tutorial_node

var player

func _ready():
	player = get_tree().get_nodes_in_group("player")[0]
	if is_tutorial:
		tutorial_node = get_parent().get_node("Tutorial/ColorRect/Label")
		tutorial_node.get_parent().visible = true
	
	process_new_level()


func process_new_level():
	if is_tutorial:
		tutorial_process_new_level()
	else:
		player.lives += 1
		player.update_ui()
		if current_level == 6:
			SceneChanger.change_scene("res://src/scenes/CutScene3.tscn", 4)
			return
		for _i in range(levels[current_level]["spawners"]):
			var position = get_random_position()
			create_spawner(current_level, position)

func tutorial_process_new_level():
	match current_level:
		1:
			tutorial_node.text = tr("CONTROLS_MOVEMENT")
			yield(get_tree().create_timer(5), "timeout")
			on_child_death()
		2:
			tutorial_node.text = tr("CONTROLS_SHOOT")
			
			var object_mob = mobs["Friend"]
			var clone = object_mob.instance()
			clone.global_position = Vector2(2400,1500)
			self.add_child(clone)
			clone.connect("on_death", self, "on_child_death")
			player.make_arrow(clone)
		3:
			tutorial_node.text = tr("CONTROLS_BURST")
			
			var object_mob = mobs["Friend"]
			var clone = object_mob.instance()
			clone.global_position = Vector2(2000,1500)
			self.add_child(clone)
			clone.connect("on_death", self, "on_child_death")
			player.make_arrow(clone)
			
			clone = object_mob.instance()
			clone.global_position = Vector2(1900,1500)
			self.add_child(clone)
			clone.connect("on_death", self, "on_child_death")
			player.make_arrow(clone)
			
			clone = object_mob.instance()
			clone.global_position = Vector2(1800,1500)
			self.add_child(clone)
			clone.connect("on_death", self, "on_child_death")
			player.make_arrow(clone)
		4:
			tutorial_node.text = tr("CONTROLS_FOCUS")
			yield(get_tree().create_timer(5), "timeout")
			on_child_death()
		5:
			tutorial_node.text = tr("CONTROLS_CIRCLE")
			var spawner = create_spawner(0, Vector2(1400,1000))
			spawner.get_node("AnimatedSprite").animation = "Friend"
		6:
			tutorial_node.text = tr("CONTROLS_MENU")
			SceneChanger.change_scene("res://src/scenes/CutScene2.tscn", 3)

func get_random_position() -> Vector2:
	var _vector = Vector2.ZERO
	var done = false
	while not done:
		done = true
		var _x = rand_range(MAP_START.x, MAP_EDGE.x)
		var _y = rand_range(MAP_START.y, MAP_EDGE.y)
		_vector = Vector2(_x, _y)
		for child in get_children():
			print(child.global_position.distance_to(_vector))
			if child.global_position.distance_to(_vector) < 500:
				done = false
		if player.global_position.distance_to(_vector) < 100:
			done = false
	
	return _vector

func create_spawner(level, position):
	var spawner = scene_spawner.instance()
	spawner.director = self
	spawner.current_pack = levels[level]["pack"]
	spawner.burst = levels[level]["burst"]
	spawner.global_position = position
	add_child(spawner)
	spawner.connect("on_death", self, "on_child_death")
	return spawner


func spawn_mob(spawner:Node2D, mob:String):
	var object_mob = mobs[mob]
	var clone = object_mob.instance()
	clone.velocity = Vector2(1,0).rotated(randf()* 2 * PI) * 2000
	spawner.add_child(clone)


func on_child_death():
	if get_child_count() == 0:
		current_level += 1
		process_new_level()
