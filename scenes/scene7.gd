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
	"Judge",
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
	5,
	9,
	9,
	3,
	8,
	5,
	9,
	9,
	8,
	10,
	8,
	3,
	3,
	5,
	8,
	6,
	7,
	7,
	6,
	5,
	5,
	3,
	5,
	5,
	9,
	3,
	6,
	3,
	6,
	5,
	5
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
	2,
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
@onready var bang = $bang

@onready var elay_sprite = $Background/ElaySprite
@onready var elay_animation = $Background/ElaySprite/AnimationPlayer
@onready var rain_sprite = $rain_sprite
@onready var rain_sprite_animation = $rain_sprite/rain_sprite_animation
@onready var rain_sprite_animation2 = $rain_sprite/rain_sprite_animation2
@onready var rain_sprite_animation3 = $rain_sprite/AnimationPlayer
@onready var sunny_sprite = $sunny_sprite
@onready var sunny_sprite_animation = $sunny_sprite/AnimationPlayer
@onready var sunny_sprite_animation2 = $sunny_sprite/sunny_sprite_animation
@onready var sunny_sprite_animation3 = $sunny_sprite/sunny_sprite_animation2
@onready var judge_sprite = $judge_sprite
@onready var judge_sprite_animation = $judge_sprite/judge_sprite_animation
@onready var mscris_sprite = $mscris_sprite
@onready var mscris_sprite_animation = $mscris_sprite/AnimationPlayer



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
			current_index += 1
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
	elay_sprite.visible = false
	rain_sprite.visible = false
	sunny_sprite.visible = false
	mscris_sprite.visible = false
	rain_sprite_animation.stop()
	rain_sprite_animation2.stop()
	rain_sprite_animation3.stop()
	sunny_sprite_animation.stop()
	sunny_sprite_animation2.stop()
	sunny_sprite_animation3.stop()
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
			if current_index == 3 || current_index == 11 || current_index == 21:
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
			judge_sprite.visible = true
			judge_sprite_animation.play("Talking")
			if is_typing:
				await start_text_update()
			judge_sprite_animation.play("Blinking")
		
		6:
			mscris_sprite.visible = true
			mscris_sprite_animation.play("WorriedTalk")
			if is_typing:
				await start_text_update()
			mscris_sprite_animation.play("WorriedStare")
		
		7: 
			rain_sprite.visible = true
			rain_sprite_animation2.play("Blinking")
			if is_typing:
				await start_text_update()
				
		8: 
			sunny_sprite.visible = true
			sunny_sprite_animation2.play("Suspicious_Talking")
			if is_typing:
				await start_text_update()
			sunny_sprite_animation2.play("Suspicious_Blinking")
			
		9:
			sunny_sprite.visible = true
			sunny_sprite_animation3.play("NormalTalk")
			if is_typing:
				await start_text_update()
			sunny_sprite_animation3.play("Blinking")
		
		10:
			rain_sprite.visible = true
			rain_sprite_animation.play("Embarassed")
			if is_typing:
				await start_text_update()
			rain_sprite_animation.play("Embarassed_Blinking")
		
		
