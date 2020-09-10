extends Node

signal scored(amunt)
signal game_over(new_score)

var score:int

func _ready():
	if connect("game_over", self, "on_game_over") != OK:
		print("Can't connect Game Over at Events.gd")


func on_game_over(new_score):
	score = new_score
