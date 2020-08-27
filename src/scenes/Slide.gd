extends TextureRect

var ending_position:Vector2
var remove = false

func _ready():
	ending_position = rect_global_position - Vector2(2000, -1000)

func _process(_delta):
	if remove:
		rect_global_position = rect_global_position.linear_interpolate(ending_position, 0.01)
		modulate = modulate.linear_interpolate(Color(1,1,1,0), 0.05)
		if rect_global_position == ending_position:
			queue_free()
