extends Control

var dialogues = [
	"Ms. Flower, let's cut to the chase. Your attempts to dance around the truth are futile.",
	"You were caught red-handed on CCTV, entering and leaving the scene of the crime.",
	"I... I don’t know what you’re talking about. You must be sick in the head having all these conclusions…",
	"Don’t play coy with me, Ms. Flower. We both know you were there, and we both know what you did. The evidence is clear, and your lies won’t hold up in court.",
	"I didn’t do anything wrong! You can’t prove anything!",
	"Oh, I beg to differ. The CCTV footage, the stolen handkerchief...",
	"So why don’t you spare us the charade and admit to what you’ve done?",
	"I... I...",
	"Well, Ms. Flower?",
	"Oh, to hell with you, you horned beetle-looking louse!",
	"Wipe that adamant brow off your face! Oh, how I hate your guts!",
	"To never see that face every again, especially in this courtroom!",
	"Wow, look at her mad...",
	"Okay, I admit - I had my hands dirty with Sirina. One push and...",
	"Just how close I was to never, ever coming across you in life, ever!",
	"(...What is this... this cruel kind of hatred...)",
	"This is a serious confession, Ms. Flower. Your actions not only led to a tragic loss of life but also to an elaborate attempt to frame an innocent person.",
	"The court will now deliberate on your confession and the appropriate charges.",
	"You can’t do this to me! I had it all perfectly thought out!",
	"...You were so eager to destroy me?",
	"Just you wait, de Luca! Just you wait!",
	"Well, you went too far and look what it got you.",
	"I hope this way, at least we do not have to face each other for long.",
	"Alexa, thank God you're going to be alright. We did it.",
	"Thank you, Rain. I never doubted you for a second.",
	"Well, all's well that ends well.",
	"That was quite a ride, wasn't it?",
	"It was indeed. Thank you, Rain, Ms. Cris.",
	"Matters on Prosecutor Sunny Flower's trial will be posted ona further date. Related parties, keep posted for further notice.",
	"For now, at least, one thing's for sure.",
	"Alexa Yala, this court proclaims you...",
	"Not guilty."
]

var char_names = [
	'Rain',
	'Rain',
	'Sunny',
	'Rain',
	'Sunny',
	'Rain',
	'Rain',
	'Sunny',
	'Rain',
	'Sunny',
	'Sunny',
	'Sunny',
	"Ms. Cris",
	'Sunny',
	'Sunny',
	"Rain",
	"Judge",
	"Judge",
	"Sunny",
	"Rain",
	'Sunny',
	"Rain",
	"Rain",
	"Rain",
	"Alexa",
	"Ms. Cris",
	"Ms. Cris",
	"Alexa",
	"Judge",
	"Judge",
	"Judge",
	"Judge",
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
	2,
	4,
	2,
	4,
	2,
	2,
	4,
	2,
	4,
	4,
	4,
	3,
	4,
	4,
	2,
	0,
	0,
	4,
	2,
	4,
	2,
	2,
	2,
	4,
	3,
	3,
	4,
	0,
	0,
	0,
	0,
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
		SceneTransition.load_scene("res://scenes/crossExam4.tscn")

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
	rain_sprite_animation.stop()
	rain_sprite_animation2.stop()
	rain_sprite_animation3.stop()
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
			rain_sprite_animation2.play("Talking")
			if is_typing:
				await start_text_update()
			rain_sprite_animation2.play("Blinking")
		
		4:
			rain_sprite.visible = true
			if current_index == 0:
				rain_sprite_animation3.play("TakeThat")
				bang.play()
				await get_tree().create_timer(0.9).timeout
			rain_sprite_animation3.play("TakeThatTalking")
			if is_typing:
				await start_text_update()
			rain_sprite_animation3.play("TakeThatBlinking")
			
		_:
			if is_typing:
				await start_text_update()
