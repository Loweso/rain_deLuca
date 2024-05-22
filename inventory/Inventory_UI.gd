extends Control

var is_Open = false
@onready var backButton = $Background/Button as Button

@onready var inv: Inv = preload("res://inventory/inventory.tres")
@onready var slots: Array = $Background/NinePatchRect/GridContainer.get_children()

func _ready():
	close()
	update_slots()
	backButton.pressed.connect(toggle)

func update_slots():
	for i in range(min(inv.items.size(), slots.size())):
		slots[i].update(inv.items[i])

func open():
	self.visible = true
	is_Open = true

func close():
	self.visible = false
	is_Open = false

func toggle():
	if is_Open:
		close()
	else:
		open()
