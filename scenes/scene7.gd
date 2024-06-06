extends Control

var dialogues = [
	'The court is now back in session. Ms. Flower, do you have the results of the DNA test?',
	"Yes, Your Honor. Let me brief you on the case again.",
	"At first, it seemed to be an open-and-shut case against Ms. Yala, which is why we are here today.",
	"Objection, Your Honor. The presence of a handkerchief alone does not prove my client’s guilt.",
	"Well, I am not finished, Mr. de Luca.",
	"Overruled. Continue, Prosecutor.",
	"As I was saying before I was interrupted, the handkerchief pointed to Ms. Yala because of the embroidery on it.",
	"However... after conducting a DNA test...",
	"The results appear to be quite revealing.",
	"(This doesn’t sound so good...)",
	"The handkerchief had traces of DNA from none other than Rain de Luca, the so-called loyal friend of Alexa Yala.",
	"That’s preposterous!",
	"I am pretty, and I am sure that this is a setup!!",
	"Order! Order in the court!",
	"Perhaps Mr. de Luca would like to explain how his DNA was found on an item directly linked to the defendant.",
	"Don’t fret, Rain. She probably had this all planned.",
	"(What is she going on about?)",
	"I... I don’t know!",
	"Think this through Rain! You probably have ideas as to how this came to be.",
	"Order! Mr. de Luca, you will have your chance to speak.",
	"Given the new evidence, Mr. de Luca, you need legal representation. I appoint you a new defense attorney.",
	"Your Honor, this is outrageous! I am innocent!",
	"Regardless, Mr. de Luca, you have the right to legal counsel.",
	"Ms. Flower, you will continue as the prosecutor in this case.",
	"Of course, Your Honor. I am ready to proceed.",
	"But who will represent me?",
	"I will, Rain. I believe in your innocence, and I will fight for you.",
	"Ms. Cris, are you sure about this? It’s a huge risk...",
	"I am sure. Trust me, Rain. We’ll get through this together.",
	"Very well. Ms. Cris, you are hereby appointed as the defense attorney for Mr. de Luca.",
	"Court will reconvene in fifteen minutes."
]

var char_names = [
	'Judge',
	"Sunny",
	"Sunny",
	"Rain",
	"Sunny",
	"Judge",
	"Sunny",
	"Sunny",
	"Sunny",
	"Rain",
	"Sunny",
	"Rain",
	"Rain",
	"Judge",
	"Sunny",
	"Ms. Cris",
	"Rain",
	"Rain",
	"Ms. Cris",
	"Judge",
	"Judge",
	"Rain",
	"Judge",
	"Judge",
	"Sunny",
	"Rain",
	"Ms. Cris",
	"Rain",
	"Ms. Cris",
	"Judge",
	"Judge"
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
	1,
	1,
	1,
	1,
	2,
	1,
	1,
	1,
	1,
	1,
	1,
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
	1
]

# spriteToDisplay 0 = No sprite to display
# spriteToDisplay 1 = Elay, talking and then blinking

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
	1,
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
	0
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
	1,
	1,
	1,
	1,
	1,
	1,
	1,
	1,
	1
]

# background 0 = Judge Side
# background 1 = Prosecutor Side
# background 2 = Defense Side
# background 3 = Co-Counsel Side
# background 4 = Witness Side

var backgrounds = [
	0,
	1,
	1,
	2,
	1,
	0,
	1,
	1,
	1,
	2,
	1,
	2,
	2,
	0,
	1,
	3,
	2,
	2,
	3,
	0,
	0,
	2,
	0,
	0,
	1,
	2,
	3,
	3,
	3,
	0,
	0
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

@onready var elay_sprite = $Background/ElaySprite
@onready var elay_animation = $Background/ElaySprite/AnimationPlayer

func _ready():
	var file = FileAccess.open("user://current_index.txt", FileAccess.WRITE)
	file.store_var(0)
	file.close()
	
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
		SceneTransition.load_scene("res://scenes/crossExam2.tscn")

func update_dialogue():
	is_typing = true
	if current_index < dialogues.size():
		current_text = dialogues[current_index]
		dialogue_label.text = ""
		name_label.text = char_names[current_index]
		apply_text_sound(text_sound[current_index]) 
		apply_text_style(text_styles[current_index])
		update_background(backgrounds[current_index])
		update_sprites(spriteToDisplay[current_index])
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
	
	background_sprite.texture = background_texture
	
func update_sprites(sprite: int):
	elay_sprite.visible = false
	match sprite:
		0:
			if is_typing:
				await start_text_update()
		1:
			elay_sprite.visible = true
			elay_animation.play("talking")
			if is_typing:
				await start_text_update()
			elay_animation.play("blinking")
		_:
			if is_typing:
				await start_text_update()
