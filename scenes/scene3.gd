extends Control

var dialogues = [
	'...',
	"I did not kill her.",
	"Now, now. Let’s not get ahead of ourselves.",
	'Ms. Yala, wasn’t there a scheduled game between you and the victim on the day of the crime?',
	'Yes.',
	'And before that day, didn’t you have a long undefeated streak that you so want to defend?',
	'Yes. But that doesn’t mean I would go this far just to protect that.',
	'Oh, really',
	'Huh',
	'Moments before the victim’s untimely death, a witness saw you as you entered the scene of the crime',
	'..!',
	'I was on my way there to have some peace in the restroom',
	'I find that hard to believe, you were spotted, coincidentally, around the same time the victim was still alive',
	'I have IBS medications to prove the flare ups',
	'Well, that doesn’t save you from suspicions. The witness found you rather odd that day',
	'Of course I was odd! I was having an internal battle',
	'Oh! And who might this witness be',
	'It’s none other than the pool cleaner, who saw the defendant enter the pool alone with the victim...',
	'...Less than an hour after, he once again discovered the victim’s lifeless body floating in the pool...',
	'long with a handkerchief embroidered with the name of Ms. Alexa Yala',
	'Ms. Sunny, with that, the prosecution may call its witness',
	"Yes, Your Honor.",
]

var char_names = [
	"Alexa Yala",
	"Alexa Yala",
	"Sunny Flower",
	"Sunny Flower",
	"Alexa Yala",
	"Sunny Flower",
	"Alexa Yala",
	"Sunny Flower",
	"Alexa Yala",
	"Sunny Flower",
	"Alexa Yala",
	"Alexa Yala",
	"Sunny Flower",
	"Alexa Yala",
	"Sunny Flower",
	"Alexa Yala",
	"Judge",
	"Sunny Flower",
	"Sunny Flower",
	"Sunny Flower",
	"Judge",
	"Sunny Flower",
]

# Text style 1 = White, Spoken Dialogue
# Text style 2 = Blue, Inner Thoughts
# Text style 3 = Green, centered, Current setting (time and place)

var text_styles = [
	2,
	1,
	1,
	1,
	1,
	1,
	1,
	1,
	1,
	1,
	1,
	1,
	1,
	1,
	1,
	1,
	1,
	1,
	1,
	1,
	1,
	1,
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
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
]

var text_sound = [
	1,
	1,
	1,
	1,
	1,
	1,
	1,
	1,
	1,
	1,
	1,
	1,
	1,
	1,
	1,
	1,
	1,
	1,
	1,
	1,
	1,
	1,
]

# background 0 = Judge Side
# background 1 = Prosecutor Side
# background 2 = Defense Side
# background 3 = Co-Counsel Side
# background 4 = Witness Side

var backgrounds = [
	4,
	4,
	1,
	1,
	4,
	1,
	4,
	1,
	4,
	1,
	4,
	4,
	1,
	4,
	1,
	4,
	0,
	1,
	1,
	1,
	0,
	1,
]

var current_index = 0
var char_index = 0
var is_typing = false
var text_speed = 0.05
var current_text = ""
var current_audio

@onready var background_sprite = $Background as TextureRect
@onready var dialogue_label = $DialogueText as Label
@onready var name_label = $PersonNameText as Label
@onready var personNameBox = $PersonNameBox as Polygon2D
@onready var dialogueBox = $DialogueBox as Polygon2D
@onready var dialogueBoxButton = $DialogueBoxButton as Button
@onready var courtRecButton = $CourtRecordButton as Button

@onready var inventory = $Inventory_UI
@onready var inv: Inv

@onready var defense_bench = $"defense-bench"
@onready var prosecutor_bench = $"prosecutor-bench"
@onready var witness_stand = $"witness-stand"

@onready var blip = $blip
@onready var typewrite = $typewrite

func _ready():
	update_dialogue()
	name_label.horizontal_alignment = 1
	dialogueBoxButton.pressed.connect(dialogue_button_pressed)
	courtRecButton.pressed.connect(courtRecButton_pressed)

func courtRecButton_pressed():
	inventory.toggle()

func dialogue_button_pressed():
	if current_index == dialogues.size():
		dialogueBoxButton.visible = false
	
	if current_index < dialogues.size():
		dialogueBox.visible = true
		personNameBox.visible = true
		courtRecButton.visible = true
		if is_typing:
			complete_dialogue()
		else:
			update_dialogue()
	else:
		complete_dialogue()
		SceneTransition.load_scene("res://scenes/scene4.tscn")

func update_dialogue():
	is_typing = true
	if current_index < dialogues.size():
		current_text = dialogues[current_index]
		dialogue_label.text = ""
		name_label.text = char_names[current_index]
		apply_text_sound(text_sound[current_index])
		apply_text_style(text_styles[current_index])
		update_background(backgrounds[current_index])
	if is_typing:
		await start_text_update()
	current_index += 1
		
	
		
func start_text_update():
	char_index = 0
	while char_index < current_text.length():
		if not is_typing:
			return
		if current_audio == typewrite:
			if char_index % 3 == 0:
				current_audio.play()
		else:
			current_audio.play()
		dialogue_label.text += current_text[char_index]
		char_index += 1
		await get_tree().create_timer(text_speed).timeout
	dialogue_label.text = current_text
	is_typing = false

func complete_dialogue():
	dialogue_label.text = current_text
	is_typing = false
	current_audio.stop() 

func apply_text_sound(text_value:int):
	match text_value:
		1: 
			current_audio = blip
		2:
			current_audio = typewrite
		
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
	defense_bench.visible = false
	prosecutor_bench.visible = false
	witness_stand.visible = false
	match background_index:
		0:
			background_texture = preload("res://assets/backgrounds/judgesSide.png")
		1:
			background_texture = preload("res://assets/backgrounds/prosecutorSide.jpg")
			prosecutor_bench.visible = true
		2:
			background_texture = preload("res://assets/backgrounds/defenseSide.png")
			defense_bench.visible = true
		3:
			background_texture = preload("res://assets/backgrounds/cocounselSide.png")
		4:
			background_texture = preload("res://assets/backgrounds/witnessSide.jpg")
			witness_stand.visible = true
			# Default background if needed
	
	background_sprite.texture = background_texture
