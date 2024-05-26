extends Control

var main_dialogues = [
	"Cross examination!",
	"First testimony.",
	"Second testimony.",
	"Third testimony.",
	"Fourth testimony."
]

var char_names = [
	"Judge",
	"Sunny",
	"Judge",
	"Serena",
	"Judge",
]

# Text style 1 = White, Spoken Dialogue
# Text style 2 = Blue, Inner Thoughts
# Text style 3 = Green, centered, Current setting (time and place)
# Text style 4 = Green, left-aligned, Witness Testimony Cross-examination

var text_styles = [
	4,
	4, 
	4,
	4,
	4
]

# spriteToDisplay 0 = No sprite to display
# spriteToDisplay 1 = Maya, looking forward
# spriteToDisplay 2 = Maya, talking

var spriteToDisplay = [
	2,
	1, 
	2,
	0,
	2
]

# background 0 = Judge Side
# background 1 = Prosecutor Side
# background 2 = Defense Side
# background 3 = Co-Counsel Side
# background 4 = Witness Side

var backgrounds = [
	4,
	4, 
	4,
	4,
	4
]

var current_index = -1

@onready var background_sprite = $Background as TextureRect
@onready var dialogue_label = $DialogueText as Label
@onready var name_label = $PersonNameText as Label
@onready var personNameBox = $PersonNameBox as Polygon2D
@onready var dialogueBox = $DialogueBox as Polygon2D
@onready var dialogueBoxButton = $DialogueBoxButton as Button
@onready var courtRecButton = $CourtRecordButton as Button

@onready var inventory = $Inventory_UI
@onready var inv: Inv

@onready var nextButton = $NextButton as Button
@onready var prevButton = $PrevButton as Button
@onready var pressButton = $PressButton as Button
@onready var holdItTransition = $HoldItTransition

func _ready():
	name_label.horizontal_alignment = 1
	personNameBox.visible = false
	courtRecButton.visible = false
	nextButton.visible = false
	prevButton.visible = false
	pressButton.visible = false
	
	dialogueBoxButton.pressed.connect(dialogue_button_pressed)
	nextButton.pressed.connect(dialogue_button_pressed)
	prevButton.pressed.connect(prev_button_pressed)
	courtRecButton.pressed.connect(courtRecButton_pressed)
	pressButton.pressed.connect(press_button_pressed)

func courtRecButton_pressed():
	inventory.toggle()

func dialogue_button_pressed():
	dialogueBoxButton.visible = false
	dialogueBox.visible = true
	personNameBox.visible = true
	courtRecButton.visible = true
	nextButton.visible = true
	pressButton.visible = true
	
	current_index += 1
	update_dialogue()
		
func prev_button_pressed():
	current_index -= 1
	update_dialogue()

func update_dialogue():
	if current_index >= main_dialogues.size():
		current_index = 0
		
	dialogue_label.text = main_dialogues[current_index]
	name_label.text = char_names[current_index]
	apply_text_style(text_styles[current_index])
	update_background(backgrounds[current_index])
	update_buttons_visibility()
		
func apply_text_style(style_value: int):
	var color := Color(1, 1, 1)
	match style_value:
		1:
			color = Color(1, 1, 1)
			dialogue_label.horizontal_alignment = 0
		2:
			color = Color(82 / 255.0, 165 / 255.0, 206 / 255.0)
			dialogue_label.horizontal_alignment = 0
		3:
			color = Color(15 / 255.0, 242 / 255.0, 79 / 255.0)
			dialogue_label.horizontal_alignment = 1
		4:
			color = Color(15 / 255.0, 242 / 255.0, 79 / 255.0)
			dialogue_label.horizontal_alignment = 0

	dialogue_label.add_theme_color_override("font_color", color)
	
func update_background(background_index: int):
	var background_texture: Texture
	match background_index:
		0:
			background_texture = preload("res://assets/backgrounds/judgesSide.png")
		1:
			background_texture = preload("res://assets/backgrounds/prosecutorSide.jpg")
		2:
			background_texture = preload("res://assets/backgrounds/defenseSide.png")
		3:
			background_texture = preload("res://assets/backgrounds/cocounselSide.png")
		4:
			background_texture = preload("res://assets/backgrounds/witnessSide.jpg") # Default background if needed
	
	background_sprite.texture = background_texture

func update_buttons_visibility():
	if current_index == 0:
		prevButton.visible = false
	else:
		prevButton.visible = true
		
func press_button_pressed():
	match current_index:
		0:
			dialogueBoxButton.visible = false
			dialogueBox.visible = false
			dialogue_label.visible = false
			personNameBox.visible = false
			name_label.visible = false
			courtRecButton.visible = false
			nextButton.visible = false
			pressButton.visible = false
			
			holdItTransition.load_scene("res://scenes/pressScene1_1.tscn")
		_:
			pass
