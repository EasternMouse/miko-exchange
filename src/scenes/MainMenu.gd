extends Control

export(String, FILE) var music = ""

var sounds = {
	"select" : preload("res://assets/se/select.wav"),
	"start" : preload("res://assets/se/start.wav"),
	}


func _ready():
	$MarginContainer/VBoxContainer/ButtonStart.grab_focus()
	BgmControl.start_playing(music)
	load_text()

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
	$LanguagePopupMenu.popup()


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
	
	BgmControl.save_settings()
	load_text()


func play_sound(sound):
	if BgmControl.option_sound:
		$AudioStreamPlayer.stream = sounds[sound]
		$AudioStreamPlayer.play()


func load_text():
	if BgmControl.option_music:
		$MarginContainer/VBoxContainer/HBoxContainer/ButtonMusic.text = ("BGM : " + tr("ON"))
	else:
		$MarginContainer/VBoxContainer/HBoxContainer/ButtonMusic.text = ("BGM : " + tr("OFF"))
	
	if BgmControl.option_sound:
		$MarginContainer/VBoxContainer/HBoxContainer/ButtonSound.text = ("SE : " + tr("ON"))
	else:
		$MarginContainer/VBoxContainer/HBoxContainer/ButtonSound.text = ("SE : " + tr("OFF"))


func _on_ButtonCreditsMusicFrogMask_pressed():
	OS.window_fullscreen = false
	if OS.shell_open("https://soundcloud.com/frogmask") != OK:
		print("Can't open website!")


func _on_ButtonCreditsMusicMatthew_pressed():
	OS.window_fullscreen = false
	if OS.shell_open("https://opengameart.org/content/undead-rising") != OK:
		print("Can't open website!")


func _on_ButtonCreditsGame_pressed():
	OS.window_fullscreen = false
	if OS.shell_open("https://easternmouse.itch.io") != OK:
		print("Can't open website!")


func _on_LanguagePopupMenu_id_pressed(id: int) -> void:
	match id:
		0: TranslationServer.set_locale("en")
		1: TranslationServer.set_locale("ja")
		2: TranslationServer.set_locale("ru")
		3: TranslationServer.set_locale("zh")
	print("locale set: ", TranslationServer.get_locale())
	load_text()


func _on_LanguagePopupMenu_about_to_show() -> void:
	pass # Replace with function body.
