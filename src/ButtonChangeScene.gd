extends Button

export(String) var path
export var delay := 0

func _ready():
	pass


func _on_ButtonChangeScene_pressed():
	SceneChanger.change_scene(path, delay)

