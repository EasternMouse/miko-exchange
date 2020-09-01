extends AudioStreamPlayer

var option_music := true
var option_sound := true

func _ready():
	load_settings()


func start_playing(music:String):
	if music == "":
		stop()
	elif option_music:
		stream = load(music)
		play()


func save_settings():
	var options = {
		"option_music" : option_music,
		"option_sound" : option_sound,
	}
	var save_file = File.new()
	save_file.open("user://options.txt", File.WRITE)
	save_file.store_line(to_json(options))
	save_file.close()


func load_settings():
	var save_file = File.new()
	if not save_file.file_exists("user://options.txt"):
		return
	save_file.open("user://options.txt", File.READ)
	
	while save_file.get_position() < save_file.get_len():
		var data = parse_json(save_file.get_line())
		option_music = data["option_music"]
		option_sound = data["option_sound"]
	save_file.close()
