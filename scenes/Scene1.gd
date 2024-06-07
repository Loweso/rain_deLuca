extends Control

var dialogues = [
	"June 7, 10:30 AM\nDistrict Court\nDefendant Lobby No. 1",
	"(…)",
	"(*sigh*)",
	'What’s wrong, Rain?',
	'It’s been days since it happened, but I still can’t quite believe it.',
	'Well, I have to say Rain, I’m impressed!',
	'Not everyone takes on a murder trial right off the bat like this.',
	'Uhm... Thanks.',
	'Actually, it’s because I owe her a favor.',
	'A favor? You mean you knew the defendant before this case?',
	'Yes. She is a good friend of mine.',
	'A well-known tennis player drowned in an olympic sized pool.',
	'The person they arrested was her opponent for a match she was going to play at the time.',
	'Alexa Yala... my best friend since grade school.',
	'She has always been bubbly, you’d never see her faulty during a crisis.',
	'And I know her better than anyone. Which is why I took the case.',
	'I want to help her out in any way I can.',
]

var char_names = [
	"",
	"Rain",
	"Rain",
	"Ms. Cris",
	"Rain",
	"Ms. Cris",
	"Ms. Cris",
	"Rain",
	"Rain",
	"Ms. Cris",
	"Rain",
	"Rain",
	"Rain",
	"Rain",
	"Rain",
	"Rain",
	"Rain",
]

# Text style 1 = White, Spoken Dialogue
# Text style 2 = Blue, Inner Thoughts
# Text style 3 = Green, centered, Current setting (time and place)

var text_styles = [
	3,
	2,
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
# spriteToDisplay 1 = Maya, listening
# spriteToDisplay 2 = Maya, talking
# 3 = maya, talking longer
#4 = maya, talking longer than ever
#5 maya listening 2

var spriteToDisplay = [
	0,
	1,
	1, 
	3,
	1,
	3,
	3,
	1,
	2,
	3,
	1,
	2,
	1, 
	2,
	1,
	1, 
	2
]

var text_sound = [
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
]

var backgrounds = [
	0,
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

var current_index = 0

var char_index = 0
var current_text = ""
var current_name = ""
var text_speed = 0.05
var is_typing = false
var current_audio

@onready var background_sprite = $Background as TextureRect
@onready var dialogue_label = $DialogueText as Label
@onready var BlackBg = $BlackBg
@onready var name_label = $PersonNameText as Label
@onready var personNameBox = $PersonNameBox as Polygon2D
@onready var dialogueBox = $DialogueBox as Polygon2D
@onready var dialogueBoxButton = $DialogueBoxButton as Button
@onready var courtRecButton = $CourtRecordButton as Button
@onready var transition = $SceneTransition

@onready var inventory = $Inventory_UI
@onready var inv: Inv

@onready var mscris_sprite = $MsCris
@onready var mscris_sprite_animation = $MsCris/MsCrisTalking

@onready var blip = $blip
@onready var typewrite = $typewriter



func _ready():
	mscris_sprite.visible = false
	name_label.horizontal_alignment = 1
	personNameBox.visible = false
	courtRecButton.visible = false
	name_label.visible = false
	await update_dialogue()
	
	var file = FileAccess.open("user://mistakes_num.txt", FileAccess.WRITE)
	file.store_var(0)
	file.close()
	
	dialogueBoxButton.pressed.connect(dialogue_button_pressed)
	courtRecButton.pressed.connect(courtRecButton_pressed)

func courtRecButton_pressed():
	inventory.toggle()

func dialogue_button_pressed():
	if current_index == dialogues.size():
		dialogueBoxButton.visible = false
	if current_index < dialogues.size():
		if is_typing:
			complete_dialogue()
		else:
			current_index += 1
			update_dialogue()
			
		if current_index > 0:
			name_label.visible = true
			dialogueBox.visible = true
			personNameBox.visible = true
			courtRecButton.visible = true
		
			
	else:
		complete_dialogue()
		await get_tree().create_timer(1).timeout
		SceneTransition.load_scene("res://scenes/scene2.tscn")

func update_dialogue():
	is_typing = true
	if current_index < dialogues.size():
		current_text = dialogues[current_index]
		current_name = char_names[current_index]
		dialogue_label.text = ""
		name_label.text = current_name
		apply_text_sound(text_sound[current_index])
		apply_text_style(text_styles[current_index])
		update_background(backgrounds[current_index])
		update_sprites(spriteToDisplay[current_index])
		if current_index == 0 && is_typing:
			await start_text_update()
	
		
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
	is_typing = false
	dialogue_label.text = current_text

func complete_dialogue():
	dialogue_label.text = current_text
	is_typing = false
	current_audio.stop() 
		
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
	mscris_sprite.visible = false
	
	match sprite:
		1:
			mscris_sprite.visible = true
			mscris_sprite_animation.play("Listening")
			if is_typing:
				await start_text_update()
		2: 
			mscris_sprite.visible = true
			mscris_sprite_animation.play("Listening_2")
			if is_typing:
				await start_text_update()
		3:
			mscris_sprite.visible = true
			mscris_sprite_animation.play("Talking")
			if is_typing:
				await start_text_update()
			mscris_sprite.visible = true
			mscris_sprite_animation.play("Listening")
			
func apply_text_sound(text_value:int):
	match text_value:
		1: 
			current_audio = blip
		2:
			current_audio = typewrite
			
func update_background(background_index: int):
	var background_texture: Texture
	background_texture = preload("res://assets/backgrounds/Courtlobby.png")
	match background_index:
		0:
			BlackBg.visible = true
		1:
			BlackBg.visible = false
					
	background_sprite.texture = background_texture
