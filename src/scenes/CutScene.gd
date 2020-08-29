extends Control

export(String, FILE) var music = ""
export var next_scene:String = ""

onready var slides = $Slides

func _ready():
	if music != "":
		BgmControl.start_playing(music)


func _input(_event):
	if Input.is_action_just_pressed("ui_accept"):
		next()
	elif Input.is_key_pressed(KEY_ESCAPE):
		SceneChanger.change_scene("res://src/scenes/MainMenu.tscn")


func next():
	var slides_array = slides.get_children()
	slides_array.invert()
	for slide in slides_array:
		if slide is Label:
			continue
		if not slide.remove:
			slide.remove = true
			if slide.get_child_count() == 0:
				return
			else:
				SceneChanger.change_scene(next_scene, 0)
