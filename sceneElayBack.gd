extends Control

var dialogues = [
	'Elay, please return to the witness stand for further questions.',
	"Of course, Your Honor.",
	"Let’s get this straight.",
	"Ms. Cris claims you can confirm Mr. Rain's alibi – that he was at the tennis venue the entire time the crime took place. Is this true?",
	"Yes, Your Honor. I did see Mr. de Luca at the venue during the known time that the crime took place.",
	"Please elaborate.",
	"Sure. As I mentioned during the cross-examination, after finishing my duties at around 3:00 PM, I headed to the match venue.",
	"And there I saw Mr. de Luca. Given that he and Alex Yala were childhood friends and share a passion for tennis, it made sense for him to be there.",
	"Are you certain about this?",
	"Yes, Your Honor. I’m certain. I saw him with my own eyes.",
	"I was at the match venue from around 3:00 PM to 4:00 PM.",
	"During that time, Mr. de Luca was there as well, watching the preparations and interacting with other tennis fans.",
	"So you’re confident he didn’t leave the venue during that period?",
	"Absolutely, Your Honor. He was there the entire time.",
	"This strengthens Rain’s case. We need to find another angle to identify the true culprit.",
	"...",
	"While it strengthens Rain’s case, it doesn’t quite help Ayala’s case – your client’s – does it?",
	"...!",
	"If anything, we’ve established one thing… Only Ayala, who is a close friend of Rain’s, could have dropped the merch with her friend’s DNA on the crime scene.",
	"That’s not conclusive yet, Your Honor!",
	"Oh, really? How would you explain that handkerchief then?",
	"...Tsk!",
	"(...Is this really it? Is this really the truth?)"
]

var char_names = [
	'Judge',
	"Elay",
	"Judge",
	"Judge",
	"Elay",
	"Judge",
	"Elay",
	"Elay",
	"Judge",
	"Elay",
	"Elay",
	"Elay",
	"Judge",
	"Elay",
	"Ms. Cris",
	"Sunny",
	"Sunny",
	"Ms. Cris",
	"Sunny",
	"Rain",
	"Sunny",
	"Rain",
	"Ms. Cris"
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
	2
]

# spriteToDisplay 0 = No sprite to display
# spriteToDisplay 1 = Elay, talking and then blinking

var spriteToDisplay = [
	0,
	1,
	0,
	0,
	1,
	0,
	1,
	1,
	0,
	1,
	1,
	1,
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
	1
]

# background 0 = Judge Side
# background 1 = Prosecutor Side
# background 2 = Defense Side
# background 3 = Co-Counsel Side
# background 4 = Witness Side

var backgrounds = [
	0,
	4,
	0,
	0,
	4,
	0,
	4,
	4,
	0,
	4,
	4,
	4,
	0,
	4,
	2,
	1,
	1,
	2,
	1,
	3,
	1,
	3,
	2
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
		SceneTransition.load_scene("res://scenes/sceneCCTV.tscn")

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
