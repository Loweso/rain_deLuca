extends Control

var dialogues = [
	"Hah! You’re barking up the wrong tree…and with such vigor, de Luca!",
	"You chose to be a pathetic lying dog this time, not a lawyer? Save your breath.",
	"I thought we’re obliged to tell the truth AND only the truth, Atty. de Luca?",
	'Rain, pay attention! Let’s focus on the present matters about what Elay saw in the pool area.',
	'If our defendant Ms. Yala really is saying the truth, and was having flare ups during the time...',
	'There must be evidence at the crime scene that should not have been connected to her.',
	'(Something... at the crime scene...?)',
	"Are you okay over there, de Luca? You look like you're about to cry.",
	"(Alright, let’s give this a try… Focus, de Luca! More energy!)"
]

var char_names = [
	"Sunny",
	"Sunny",
	"Judge",
	"Ms. Cris",
	"Ms. Cris",
	"Rain",
	"Sunny",
	"Rain"
]

# Text style 1 = White, Spoken Dialogue
# Text style 2 = Blue, Inner Thoughts
# Text style 3 = Green, centered, Current setting (time and place)

var text_styles = [
	1,
	1, 
	1,
	1,
	1, 
	2,
	1,
	2
]

# spriteToDisplay 0 = No sprite to display
# spriteToDisplay 1 = Maya, looking forward
# spriteToDisplay 2 = Maya, talking

var spriteToDisplay = [
	0,
	0, 
	0,
	0,
	0,
	0, 
	0,
	0
]

# background 0 = Judge Side
# background 1 = Prosecutor Side
# background 2 = Defense Side
# background 3 = Co-Counsel Side
# background 4 = Witness Side

var backgrounds = [
	1,
	1,
	0,
	3,
	3,
	2,
	1,
	2
]

var current_index = 0
var current_no_mistakes = 0
var no_of_mistakes_path = "user://mistakes_num.txt"

@onready var background_sprite = $Background as TextureRect
@onready var dialogue_label = $DialogueText as Label
@onready var name_label = $PersonNameText as Label
@onready var personNameBox = $PersonNameBox as Polygon2D
@onready var dialogueBox = $DialogueBox as Polygon2D
@onready var dialogueBoxButton = $DialogueBoxButton as Button
@onready var courtRecButton = $CourtRecordButton as Button

@onready var inventory = $Inventory_UI
@onready var inv: Inv

func _ready():
	update_dialogue()
	name_label.horizontal_alignment = 1
	dialogueBoxButton.pressed.connect(dialogue_button_pressed)
	courtRecButton.pressed.connect(courtRecButton_pressed)
	
	var mistakesFile = FileAccess.open(no_of_mistakes_path, FileAccess.READ)
	if mistakesFile:
		current_no_mistakes = mistakesFile.get_var()
		current_no_mistakes += 1
		mistakesFile.close()
		save_num(current_no_mistakes, no_of_mistakes_path)
	else:
		save_num(0, no_of_mistakes_path)

func courtRecButton_pressed():
	inventory.toggle()

func save_num(num: int, filePath: String):
	var file = FileAccess.open(filePath, FileAccess.WRITE)
	file.store_var(num)
	file.close()

func dialogue_button_pressed():
	dialogueBox.visible = true
	personNameBox.visible = true
	courtRecButton.visible = true
		
	current_index += 1
	
	if current_index < dialogues.size():
		update_dialogue()
	else:
		SceneTransition.load_scene("res://scenes/crossExam1.tscn")

func update_dialogue():
	if current_index < dialogues.size():
		dialogue_label.text = dialogues[current_index]
		name_label.text = char_names[current_index]
		apply_text_style(text_styles[current_index])
		update_background(backgrounds[current_index])
	else:
		dialogue_label.text = "End of dialogues."
		
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
