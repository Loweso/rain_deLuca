extends Control

var dialogues = [
	"Are you absolutely certain Ms. Yala entered the pool alone? Could someone else have been there?",
	"I’m... certain, sir. There was no one else around at 3:00 PM.",
	'Did you see Ms. Yala leave the pool area at any point?',
	"No, I didn’t see her leave.",
	'Are you certain that Ms. Alexa Yala had interaction with the victim?',
	"No, sir... I’m not sure. But there was CCTV footage available from the pool area that could prove that.",
	"CCTV footage?",
	"That CCTV footage is currently going through a forensic analysis, Rain.",
	"Hmm... and where is this CCTV footage, Elay?",
	"(...where is this heading?!)",
	"There was a problem with the footage making the recordings irrelevant to the case.",
	"Sorry, but I am cross-examining the witness, not you.",
	"(He’s really getting under my skin!)",
	"I assure you Mr. de Luca, the investigation team has already handled that.",
	"I wasn't asking you, but thank you for sharing, I guess."
]

var char_names = [
	"Rain",
	"Elay",
	"Rain",
	"Elay",
	"Rain",
	"Elay",
	"Rain",
	"Ms. Cris",
	"Rain",
	"Sunny",
	"Sunny",
	"Rain",
	"Sunny",
	"Sunny",
	"Rain",
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
	2,
	1,
	1
]

# spriteToDisplay 0 = No sprite to display
# spriteToDisplay 1 = Elay, talking and then blinking

var spriteToDisplay = [
	3,
	1,
	3,
	1,
	2,
	1,
	3,
	5,
	3,
	8,
	8,
	2,
	7,
	8,
	2,
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
	1
]

# background 0 = Judge Side
# background 1 = Prosecutor Side
# background 2 = Defense Side
# background 3 = Co-Counsel Side
# background 4 = Witness Side

var backgrounds = [
	2,
	4,
	2,
	4,
	2,
	4,
	2,
	3,
	2,
	1,
	1,
	2,
	1,
	1,
	2,
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
@onready var bang = $bang

@onready var elay_sprite = $Background/ElaySprite
@onready var elay_animation = $Background/ElaySprite/AnimationPlayer
@onready var rain_sprite = $rain_sprite
@onready var rain_sprite_animation = $rain_sprite/rain_sprite_animation
@onready var rain_sprite_animation2 = $rain_sprite/rain_sprite_animation2
@onready var rain_sprite_animation3 = $rain_sprite/AnimationPlayer
@onready var sunny_sprite = $sunny_sprite
@onready var sunny_sprite_animation = $sunny_sprite/AnimationPlayer
@onready var sunny_sprite_animation2 = $sunny_sprite/sunny_sprite_animation2
@onready var mscris_sprite = $mscris_sprite
@onready var mscris_sprite_animation = $mscris_sprite/mscris_sprite_animation

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
		var press_states_path = "user://press_states.txt"
		var press_states
		var file = FileAccess.open(press_states_path, FileAccess.READ)
		if file:
			press_states = file.get_var()
			file.close()
		else:
			press_states = [false, false, false, false]
			
		if press_states[0] and press_states[1] and press_states[2] and press_states[3]:
			get_tree().change_scene_to_file("res://scenes/scene6.tscn")
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
	rain_sprite.visible = false
	sunny_sprite.visible = false
	mscris_sprite.visible = false
	rain_sprite_animation.stop()
	rain_sprite_animation2.stop()
	rain_sprite_animation3.stop()
	sunny_sprite_animation.stop()
	sunny_sprite_animation2.stop()
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
		
		2:
			rain_sprite.visible = true
			rain_sprite_animation.play("Talking")
			if is_typing:
				await start_text_update()
			rain_sprite_animation.play("Blinking")
		
		3: 
			rain_sprite.visible = true
			if current_index == 0:
				rain_sprite_animation3.play("TakeThat")
				bang.play()
				await get_tree().create_timer(0.9).timeout
			rain_sprite_animation3.play("TakeThatTalking")
			if is_typing:
				await start_text_update()
			rain_sprite_animation3.play("TakeThatBlinking")
					
		4: 
			sunny_sprite.visible = true
			sunny_sprite_animation.play("Counter")
			if is_typing:
				await start_text_update()
			sunny_sprite_animation.play("Grit")
		
		5:
			mscris_sprite.visible = true
			mscris_sprite_animation.play("Talking")
			if is_typing:
				await start_text_update()
			mscris_sprite_animation.play("Blinking")
		
		6: 
			rain_sprite.visible = true
			rain_sprite_animation2.play("Blinking")
			if is_typing:
				await start_text_update()
		7:
			sunny_sprite.visible = true
			sunny_sprite_animation.play("Grit")
			if is_typing:
				await start_text_update()
		
		8:
			sunny_sprite.visible = true
			sunny_sprite_animation2.play("NormalTalk")
			if is_typing:
				await start_text_update()
			sunny_sprite_animation2.play('Blinking')
				
