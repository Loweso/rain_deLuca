extends Control

var dialogues = [
	"Oh, really? I don’t quite see what you’re talking about.",
	"I hope the defense would try to reflect and recollect their marbles before making claims like that.",
	'(Did I really choose wrong? I know someone had said that Rain really was at the tennis court at the time of the crime...)'
]

var char_names = [
	"Sunny",
	"Judge",
	'Ms. Cris'
]

# Text style 1 = White, Spoken Dialogue
# Text style 2 = Blue, Inner Thoughts
# Text style 3 = Green, centered, Current setting (time and place)

var text_styles = [
	1,
	1,
	2
]

# spriteToDisplay 0 = No sprite to display
# spriteToDisplay 1 = Elay, talking and then blinking

var spriteToDisplay = [
	3,
	6,
	5
]

var text_sound = [
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
	1,
	0,
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

@onready var rain_sprite = $Background/WitnessSprite
@onready var rain_sprite_animation = $Background/WitnessSprite/AnimationPlayer
@onready var mscris_sprite = $mscris_sprite
@onready var mscris_sprite_animation = $mscris_sprite/AnimationPlayer
@onready var sunny_sprite = $sunny_sprite
@onready var sunny_sprite_animation = $sunny_sprite/AnimationPlayer
@onready var sunny_sprite_animation2 = $sunny_sprite/sunny_sprite_animation
@onready var sunny_sprite_animation3 = $sunny_sprite/sunny_sprite_animation2
@onready var judge_sprite = $judge_sprite
@onready var judge_sprite_animation = $judge_sprite/judge_sprite_animation

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
		SceneTransition.load_scene("res://scenes/crossExam3.tscn")

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
	rain_sprite.visible = false
	mscris_sprite.visible = false
	sunny_sprite.visible = false
	sunny_sprite_animation.stop()
	sunny_sprite_animation2.stop()
	sunny_sprite_animation3.stop()
	match sprite:
		0:
			if is_typing:
				await start_text_update()
		1:
			rain_sprite.visible = true
			rain_sprite_animation.play("talk")
			if is_typing:
				await start_text_update()
			rain_sprite_animation.play("blink")
			
		2:
			mscris_sprite.visible = true
			mscris_sprite_animation.play("Talking")
			if is_typing:
				await start_text_update()
			mscris_sprite_animation.play("Blinking")
			
		3:
			sunny_sprite.visible = true
			sunny_sprite_animation3.play("NormalTalk")
			if is_typing:
				await start_text_update()
			sunny_sprite_animation3.play("Blinking")
		
		4:
			sunny_sprite.visible = true
			sunny_sprite_animation2.play("Suspicious_Talking")
			if is_typing:
				await start_text_update()
			sunny_sprite_animation2.play("Suspicious_Blinking")
			
		5: 
			mscris_sprite.visible = true
			mscris_sprite_animation.play("Thinking")
			if is_typing:
				await start_text_update()
	
		6: 
			judge_sprite.visible = true
			judge_sprite_animation.play("Talking")
			if is_typing:
				await start_text_update()
			judge_sprite_animation.play("Blinking")
			
