extends Control

var dialogues = [
	'(This is bad...)',
	'Our witness was a pool cleaner finishing his last shift of the day at the pool.',
	'I’d like to call our witness Elay to the stand.',
	'...',
	'Thank you, Your Honor. Elay, please state your name and occupation for the court.',
	'My name is Elay, and I work as a pool cleaner at the venue where the incident occurred.',
	'Elay, could you tell the court what you witnessed on the day of the crime?',
	'Yes, ma’am. I was finishing up my last shift of the day near the pool area when I saw Ms. Yala rushing to the pool area alone.',
	'I didn’t think of it as anything suspicious, so I just left.',
	'And did you see anyone else in the vicinity?',
	'Not really.',
	'What time was this?',
	"It was around 3:00 PM, almost an hour before I discovered the victim's body floating in the pool...",
	'As well as a handkerchief with Alexa Yala’s name by the poolside.',
	'So you’re certain that Ms. Yala was the last person seen with the victim before her death?',
	'Yes, ma’am. I’m sure of it.',
]

var char_names = [
	"Rain",
	"Sunny",
	"Sunny",
	"Judge",
	"Sunny",
	"Elay",
	"Sunny",
	"Elay",
	"Elay",
	"Sunny",
	"Elay",
	"Sunny",
	"Elay",
	"Elay",
	"Sunny",
	"Elay",
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
	
]

# spriteToDisplay 0 = No sprite to display
# spriteToDisplay 1 = judge
# spriteToDisplay 2 = sunny
# 4 rain
# 3 sunny

var spriteToDisplay = [
	4,
	2,
	2,
	1,
	2,
	5,
	2,
	5,
	5,
	2,
	5,
	3,
	5,
	5,
	3,
	5,
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
]

# background 0 = Judge Side
# background 1 = Prosecutor Side
# background 2 = Defense Side
# background 3 = Co-Counsel Side
# background 4 = Witness Side

var backgrounds = [
	2,
	1,
	1,
	0,
	1,
	4,
	1,
	4,
	4,
	1,
	4,
	1,
	4,
	4,
	1,
	4,
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

@onready var stand = $stand as TextureRect

@onready var blip = $blip
@onready var typewrite = $typewrite

@onready var rain_sprite = $rain_sprite
@onready var rain_sprite_animation = $rain_sprite/rain_sprite_animation
@onready var sunny_sprite = $sunny_sprite
@onready var sunny_sprite_animation = $sunny_sprite/sunny_sprite_animation
@onready var judge_sprite = $judge_sprite
@onready var judge_sprite_animation = $judge_sprite/judge_sprite_animation
@onready var elay_sprite = $ElaySprite
@onready var elay_animation = $ElaySprite/AnimationPlayer

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
			current_index += 1
			update_dialogue()
	else:
		complete_dialogue()
		SceneTransition.load_scene("res://scenes/crossExam1.tscn")

func update_dialogue():
	is_typing = true
	if current_index < dialogues.size():
		
		current_text = dialogues[current_index]
		print(current_text)
		dialogue_label.text = ""
		name_label.text = char_names[current_index]
		apply_text_sound(text_sound[current_index]) 
		apply_text_style(text_styles[current_index])
		update_background(backgrounds[current_index])
		update_sprites(spriteToDisplay[current_index])
		
	
		
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
	
func update_sprites(sprite: int):
	elay_sprite.visible = false
	judge_sprite.visible = false
	sunny_sprite.visible = false
	rain_sprite.visible = false
	match sprite:
		0:
			if is_typing:
				await start_text_update()
		1:
			judge_sprite.visible = true
			judge_sprite_animation.play("Talking")
			if is_typing:
				await start_text_update()
			judge_sprite_animation.play("Blinking")
		2:
			sunny_sprite.visible = true
			sunny_sprite_animation.play("Talking")
			if is_typing:
				await start_text_update()
			sunny_sprite_animation.play("Blinking")
		3:
			sunny_sprite.visible = true
			sunny_sprite_animation.play("Suspicious_Talking")
			if is_typing:
				await start_text_update()
			sunny_sprite_animation.play("Suspicious_Blinking")
		4: 
			rain_sprite.visible = true
			rain_sprite_animation.play("worried")
			if is_typing:
				await start_text_update()
		5:
			elay_sprite.visible = true
			elay_animation.play("talking")
			if is_typing:
				await start_text_update()
			elay_animation.play("blinking")
	
func update_background(background_index: int):
	var background_texture: Texture
	var stand_texture: Texture
	stand.visible = false
	match background_index:
		0:
			background_texture = preload("res://assets/backgrounds/judgesSide.png")
		1:
			background_texture = preload("res://assets/backgrounds/prosecutorSide.jpg")
			stand_texture = preload("res://assets/backgrounds/prosecutor-bench.png")
			stand.visible = true
		2:
			background_texture = preload("res://assets/backgrounds/defenseSide.png")
			stand_texture = preload("res://assets/backgrounds/defense-bench.png")
			stand.visible = true
		3:
			background_texture = preload("res://assets/backgrounds/cocounselSide.png")
		4:
			background_texture = preload("res://assets/backgrounds/witnessSide.jpg")
			stand_texture = preload("res://assets/backgrounds/witness-stand.png")
			stand.visible = true
			# Default background if needed
	
	background_sprite.texture = background_texture
	stand.texture = stand_texture
	
