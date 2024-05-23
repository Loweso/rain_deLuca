extends Control

var is_Open = false
@onready var backButton = $Background/Button as Button

@onready var inv: Inv = preload("res://inventory/inventory.tres")
@onready var slots: Array = $Background/NinePatchRect/GridContainer.get_children()
@onready var buttons: Array = $Background/NinePatchRect/ButtonContainer.get_children()

@onready var item_display = $Background/Item_MainDisplay as Sprite2D
@onready var item_name = $Background/Item_Name as Label
@onready var item_desc = $Background/Item_Description as Label

func _ready():
	item_display.visible = false
	item_name.visible = false
	item_desc.visible = false
	
	for i in range(buttons.size()):
		buttons[i].visible = false
		buttons[i].pressed.connect(_update_item_display.bind(i))  # Connect using a lambda function
	
	close()
	update_slots()
	backButton.pressed.connect(toggle)

func update_slots():
	for i in range(slots.size()):
		if i < inv.items.size():
			slots[i].update(inv.items[i])
			buttons[i].visible = inv.items[i] != null
		else:
			slots[i].update(null)
			buttons[i].visible = false

func open():
	self.visible = true
	is_Open = true

func close():
	self.visible = false
	item_display.visible = false
	item_name.visible = false
	item_desc.visible = false
	is_Open = false

func toggle():
	if is_Open:
		close()
	else:
		open()

func _update_item_display(index: int):
	item_display.visible = true
	item_name.visible = true
	item_desc.visible = true
	
	item_display.texture = inv.items[index].texture
	item_display.scale = Vector2(0.003725, 0.007225)
	item_name.text = inv.items[index].name
	item_desc.text = inv.items[index].description
