extends GridContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	for i in get_child_count():
		var child = get_child(i)
		var hs = get("custom_constants/hseparation")
		var vs = get("custom_constants/vseparation")
		var row = floor(i / columns)
		child.rect_position = Vector2(i % columns * -hs, row * -vs)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
