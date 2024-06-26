extends Control

var dialogues = [
	'...!',
	"Rain!",
	"Yes, Ms. Cris?",
	"I just got the results from forensic analysis of the CCTV footage from the crime scene.",
	"I can’t believe I almost forgot we have that! That will finally clear things up. Let’s present it immediately!",
	"Excuse me, Your Honor.",
	"What is it Ms. Cris?",
	"I just received news from our forensics laboratory.",
	"A thorough forensic analysis of the CCTV footage previously thought to be unreliable.",
	"This critical evidence! Please elaborate.",
	"The corrected footage reveals Sunny Flower entering the pool area just before the crime.",
	"She quickly left the scene, constantly looking around to make sure she wasn't noticed.",
	"And if you examine closely as she went, you can see she's holding a handkerchief identical to the one discovered at the crime scene.",
	"And as she left, she was slightly drenched, with her gloves torn apart."
]

var char_names = [
	'Ms. Cris',
	"Ms. Cris",
	"Rain",
	"Ms. Cris",
	"Rain",
	"Ms. Cris",
	"Judge",
	"Ms. Cris",
	"Ms. Cris",
	"Judge",
	"Ms. Cris",
	"Ms. Cris",
	"Ms. Cris",
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
	1
]

# background 0 = Judge Side
# background 1 = Prosecutor Side
# background 2 = Defense Side
# background 3 = Co-Counsel Side
# background 4 = Witness Side

var backgrounds = [
	3,
	3,
	2,
	3,
	2,
	3,
	0,
	3,
	3,
	0,
	3,
	3,
	3,
	3
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
	judge_sprite.visible = false
	mscris_sprite.visible = false
	rain_sprite.visible = false
	sunny_sprite.visible = false
	match sprite:
		1:
			judge_sprite.visible = true
			judge_sprite_animation.play("Talking")
			if is_typing:
				await start_text_update()
			judge_sprite_animation.play("Blinking")
		2:
			mscris_sprite.visible = true
			mscris_sprite_animation.play("Talking")
			if is_typing:
				await start_text_update()
			mscris_sprite_animation.play("Blinking")
		3:
			rain_sprite.visible = true
			rain_sprite_animation.play("Talking")
			if is_typing:
				await start_text_update()
			rain_sprite_animation.play("Blinking")
		4:
			sunny_sprite.visible = true
			if current_index == 15:
				sunny_sprite_animation.play("Table_Whip")
				whip.play()
				await get_tree().create_timer(0.65).timeout
			sunny_sprite_animation.play("Talking")
			if is_typing:
				await start_text_update()
			sunny_sprite_animation.play("Blinking")
		5:
			rain_sprite.visible = true
			rain_sprite_animation.play("Embarassed")
			if is_typing:
				await start_text_update()
			rain_sprite_animation.play("Embarassed_Blinking")
		6:
			rain_sprite.visible = true
			rain_sprite_animation.play("Embarassed_Blinking")
			if is_typing:
				await start_text_update()
