extends Panel

@onready var item_visual = $item_display as Sprite2D

func update(item: InvItem):
	if !item:
		item_visual.visible = false
	else:
		item_visual.visible = true
		item_visual.texture = item.texture
		item_visual.scale = Vector2(0.01725, 0.01725)
