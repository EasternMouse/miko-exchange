extends Control

export(String, FILE) var music = ""

var sounds = {
	"select" : preload("res://assets/se/select.wav"),
	"start" : preload("res://assets/se/start.wav"),
	}


func _ready():
	$MarginContainer/VBoxContainer/ButtonStart.grab_focus()
	BgmControl.start_playing(music)


func _input(_event):
	if (Input.is_action_just_pressed("ui_down")
			or Input.is_action_just_pressed("ui_up")
			or Input.is_action_just_pressed("ui_right")
			or Input.is_action_just_pressed("ui_left")):
		play_sound("select")
	elif Input.is_action_just_pressed("ui_accept"):
		play_sound("start")


func _on_ButtonExit_pressed():
	SceneChanger.quit()


func _on_ButtonLanguage_pressed():
	if TranslationServer.get_locale() == "en":
		TranslationServer.set_locale("ja")
	else:
		TranslationServer.set_locale("en")


func _on_ButtonMusic_pressed():
	BgmControl.option_music = not BgmControl.option_music
	if BgmControl.option_music:
		BgmControl.start_playing(music)
		pass
	else:
		BgmControl.start_playing("")
	
	BgmControl.save_settings()
	load_text()


func _on_ButtonSound_pressed():
	BgmControl.option_sound = not BgmControl.option_sound
	if BgmControl.option_sound:
		BgmControl.start_playing(music)
		pass
	else:
		BgmControl.start_playing("")
	
	BgmControl.save_settings()
	load_text()


func play_sound(sound):
	if BgmControl.option_sound:
		$AudioStreamPlayer.stream = sounds[sound]
		$AudioStreamPlayer.play()


func load_text():
	if BgmControl.option_music:
		$MarginContainer/VBoxContainer/HBoxContainer/ButtonMusic.text = ("BGM : " + "On")
	else:
		$MarginContainer/VBoxContainer/HBoxContainer/ButtonMusic.text = ("BGM : " + "Off")
	
	if BgmControl.option_sound:
		$MarginContainer/VBoxContainer/HBoxContainer/ButtonSound.text = ("SE : " + "On")
	else:
		$MarginContainer/VBoxContainer/HBoxContainer/ButtonSound.text = ("SE : " + "Off")


func _on_ButtonCreditsMusic_pressed():
	OS.shell_open("https://soundcloud.com/frogmask")
