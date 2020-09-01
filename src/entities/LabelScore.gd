extends Label

var score := 0


func _ready():
	if not Events.connect("scored", self, "_add_score"):
		print("can't add signal")


func _add_score(amount):
	score += amount
	text = str(score)
