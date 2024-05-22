extends Panel

@onready var isSelected = false
@onready var item_visual = $item_display as Sprite2D
@onready var item_button = $Button as Button

func _ready():
	item_button.pressed.connect(selectItem)

func update(item: InvItem):
	if !item:
		item_visual.visible = false
		item_button.visible = false
	else:
		item_visual.visible = true
		item_button.visible = true
		item_visual.texture = item.texture
		item_visual.scale = Vector2(0.01725, 0.01725)
		
func selectItem():
	isSelected = true
