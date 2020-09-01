extends Node

signal scored(amount)
signal game_over(new_score)

var score:int

func _ready():
	connect("game_over", self, "on_game_over")


func on_game_over(new_score):
	score = new_score
