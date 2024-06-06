extends Control

# This corresponds to the correct item at a given cross-examination scene.
# For example, correctItems[0] corresponds to the 1st cross-examination scene.
# Since correctItems[0] = 1, then the item at inv.items[1] is the correct item to present.
var correctItems = [
	2,
	9,
	9
]

# Same as correctItems, but checks if the evidence is presented at the correct statement.
var correctStatement = [
	5,
	9,
	9,
]

var mistakeScenes = [
	"res://scenes/crossExam1_mistakeScene.tscn",
	"res://scenes/crossExam2_mistakeScene.tscn",
	"res://scenes/crossExam3_mistakeScene.tscn",
]

var correctScenes = [
	"res://scenes/scene5.tscn",
	"N/A",
	"N/A"
]

var is_Open = false
var currentCrossExam = 0
var currentStatement = 0
var selectedItem = 0
var hasSelectedItem = 0

@onready var backButton = $Background/Button as Button
@onready var presentButton = $PresentButton as Button

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
		buttons[i].pressed.connect(_update_item_display.bind(i))
		buttons[i].pressed.connect(setSelectedItemVar.bind(i))
	
	close()
	update_slots()
	backButton.pressed.connect(toggle.bind(currentCrossExam, 0))
	presentButton.pressed.connect(presentEvidence)

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

func toggle(index: int, index2: int):
	currentCrossExam = index
	currentStatement = index2
	if is_Open:
		hasSelectedItem = 0
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

func setSelectedItemVar(index: int):
	selectedItem = index
	hasSelectedItem = 1
	print(selectedItem)
	
func presentEvidence():
	if hasSelectedItem == 1:
		if selectedItem == correctItems[currentCrossExam] and currentStatement == correctStatement[currentCrossExam]:
			print("Correct item!")
			$takeThat.load_scene(correctScenes[currentCrossExam])
		else:
			print("Wrong item!")
			$takeThat.load_scene(mistakeScenes[currentCrossExam])
			
