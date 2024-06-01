extends Control

var dialogues = [
	'April 26, 10:45 AM\nDistrict Court\nCourtroom No. 1',
	'Court is now in session for the trial of Alexa Yala.',
	'Alexa Yala... That must be your client?',
	'Yeah... that’s her.',
	'You better be ready. This is gonna be one hell of a trial.',
	'(Confidence... All I need is confidence...)',
	'Before proceeding, I’d like to ask a few test questions.',
	'Please state the name of the defendant in this case.',
	'The defendant? Well, that’s Alexa Yala, Your Honor.',
	'Correct. Just keep your wits about you and you’ll do fine.',
	'Is the prosecution ready?',
	'The prosecution is ready, Your Honor.',
	'The, um, defense is also ready, Your Honor.',
	"Thank you. Let's proceed with opening statements. Prosecutor, you may begin.",
	'Certainly.',
	'Ladies and gentlemen, today we seek justice for the tragic loss of Sirina Thirsty.',
	"The evidence will reveal that Alexa Yala is responsible for her death. We will prove Ms. Yala's guilt beyond doubt.",
	"Next, question. This is a murder trial. Tell me, Mr. de Luca, what is the victim’s name?",
	"The victim's name is in the Court Records. Use the Court Records button to check anytime, okay?",
	"Remember to check it often!",
	'Mr. de Luca, who is the victim in this case?',
	'Uhm... the victim’s name is Sirina Thirsty.',
	'Very well... and why was she killed?',
	'She died of drowning, Your Honor',
	'Correct. You seem fairly confident, Mr. de Luca.',
	'Of course, I always am.',
	'Now, Ms. Sunny Flower...',
	'Yes, Your Honor?',
	'Ms. Flower, the prosecution may call its first witness.',
	'The prosecution would like to call the defendant, Ms. Yala, to the stand.'
]

var char_names = [
	"",
	"Judge",
	'Ms. Cris',
	'Rain',
	'Ms. Cris',
	'Rain',
	'Judge',
	'Judge',
	'Rain',
	'Judge',
	'Judge',
	"Sunny",
	"Rain",
	"Judge",
	'Sunny',
	'Sunny',
	'Sunny',
	"Judge",
	'Ms. Cris',
	'Ms. Cris',
	"Judge",
	"Rain",
	"Judge",
	'Rain',
	'Judge',
	'Rain',
	'Judge',
	'Sunny',
	"Judge",
	'Sunny',
	
]

# Text style 1 = White, Spoken Dialogue
# Text style 2 = Blue, Inner Thoughts
# Text style 3 = Green, centered, Current setting (time and place)

var text_styles = [
	3,
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
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
]

# background 0 = Judge Side
# background 1 = Prosecutor Side
# background 2 = Defense Side
# background 3 = Co-Counsel Side

var backgrounds = [
	5,
	0,
	3,
	2,
	3,
	2,
	0,
	0,
	2,
	0,
	0,
	1,
	2,
	0,
	1,
	1,
	1,
	0,
	3,
	3,
	0,
	2,
	0,
	2,
	0,
	2,
	0,
	1,
	0,
	1,
]

#1 blip
#2 typewrite

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
var current_index_adder = 0

var char_index = 0
var current_text = ""
var current_name = ""
var text_speed = 0.05
var is_typing = false
var current_audio

@onready var background_sprite = $Background as TextureRect
@onready var dialogue_label = $DialogueText as Label
@onready var name_label = $PersonNameText as Label
@onready var personNameBox = $PersonNameBox as Polygon2D
@onready var dialogueBox = $DialogueBox as Polygon2D
@onready var dialogueBoxButton = $DialogueBoxButton as Button
@onready var courtRecButton = $CourtRecordButton as Button
@onready var Blackbg = $Blackbg
@onready var AlexaYalaButton = $AlexaYala
@onready var MsCrisButton = $MsCris
@onready var RainButton = $Rain
@onready var SirinaThirsty = $SirinaThirsty
@onready var SerenaWilliams = $SerenaWilliams
@onready var SirinaWillie = $SirinaWillie
@onready var Poisoned = $Poisoned
@onready var Strangled = $Strangled
@onready var Drowned = $Drowned

@onready var inventory = $Inventory_UI
@onready var inv: Inv

@onready var blip = $blip
@onready var typewrite = $typewriter
@onready var gavel = $gavel
@onready var selected = $selected


@onready var hammer = $hammer

func _ready():
	name_label.horizontal_alignment = 1
	hammer.visible = false
	personNameBox.visible = false
	courtRecButton.visible = false
	AlexaYalaButton.visible = false
	MsCrisButton.visible = false
	RainButton.visible = false
	SirinaThirsty.visible = false
	SerenaWilliams.visible = false
	SirinaWillie.visible = false
	Poisoned.visible = false
	Strangled.visible = false
	Drowned.visible = false

	
	await update_dialogue()
	current_index += 1
	
	dialogueBoxButton.pressed.connect(dialogue_button_pressed)
	courtRecButton.pressed.connect(courtRecButton_pressed)
	AlexaYalaButton.pressed.connect(AlexaYalaButton_pressed)
	MsCrisButton.pressed.connect(MsCrisButton_pressed)
	RainButton.pressed.connect(RainButton_pressed)
	SirinaThirsty.pressed.connect(SirinaThirsty_pressed)
	SerenaWilliams.pressed.connect(SerenaWilliams_pressed)
	SirinaWillie.pressed.connect(SirinaWillie_pressed)
	Poisoned.pressed.connect(Poisoned_pressed)
	Strangled.pressed.connect(Strangled_pressed)
	Drowned.pressed.connect(Drowned_pressed)

func AlexaYalaButton_pressed():
	selected.play()
	MsCrisButton.visible = false
	RainButton.visible = false
	AlexaYalaButton.visible = false
	dialogueBoxButton.visible = true
	update_dialogue()
	current_index += 1

func MsCrisButton_pressed():
	selected.play()
	MsCrisButton.visible = false
	RainButton.visible = false
	AlexaYalaButton.visible = false
	dialogueBoxButton.visible = true
	dialogues[8] = 'The defendant? Well, that’s Ms.Cris, Your Honor.'
	dialogues[9] = "Wrong! It's Alexa Yala!"
	dialogues.insert(10, "(How... How could I forget my client's name...)")
	dialogues.insert(11, "I am sorry, Your Honor. I will never do that again.")
	dialogues.insert(12,'Just keep your wits about you and you’ll do fine.')
	char_names.insert(10, 'Rain')
	char_names.insert(11, 'Rain')
	char_names.insert(12, 'Judge')
	text_styles.insert(10, 2)
	text_styles.insert(11, 1)
	text_styles.insert(12, 1)
	text_sound.insert(10,1)
	text_sound.insert(11,1)
	text_sound.insert(12,1)
	spriteToDisplay.insert(10,0)
	spriteToDisplay.insert(11,0)
	spriteToDisplay.insert(12,0)
	backgrounds.insert(10,2)
	backgrounds.insert(11,2)
	backgrounds.insert(12,0)
	current_index_adder += 3
	update_dialogue()
	current_index += 1

func RainButton_pressed():
	selected.play()
	MsCrisButton.visible = false
	RainButton.visible = false
	AlexaYalaButton.visible = false
	dialogueBoxButton.visible = true
	dialogues[8] = 'The defendant? Well, that’s Rain de Luca, Your Honor.'
	dialogues[9] = "Wrong! It's Alexa Yala! "
	dialogues.insert(10, "(How... How could I forget my client's name...)")
	dialogues.insert(11, "I am sorry, Your Honor. I will never do that again.")
	dialogues.insert(12,'Just keep your wits about you and you’ll do fine.')
	char_names.insert(10, 'Rain')
	char_names.insert(11, 'Rain')
	char_names.insert(12, 'Judge')
	text_styles.insert(10, 2)
	text_styles.insert(11, 1)
	text_styles.insert(12, 1)
	text_sound.insert(10,1)
	text_sound.insert(11,1)
	text_sound.insert(12,1)
	spriteToDisplay.insert(10,0)
	spriteToDisplay.insert(11,0)
	spriteToDisplay.insert(12,0)
	backgrounds.insert(10,2)
	backgrounds.insert(11,2)
	backgrounds.insert(12,0)
	current_index_adder += 3
	update_dialogue()
	current_index += 1
	
func SirinaThirsty_pressed():
	selected.play()
	SirinaThirsty.visible = false
	SerenaWilliams.visible = false
	SirinaWillie.visible = false
	dialogueBoxButton.visible = true
	update_dialogue()
	current_index += 1
	
func SerenaWilliams_pressed():
	selected.play()
	SirinaThirsty.visible = false
	SerenaWilliams.visible = false
	SirinaWillie.visible = false
	dialogueBoxButton.visible = true
	dialogues[21 + current_index_adder] = 'Uhm... the victim’s name is Serena Williams.'
	dialogues.insert(22 + current_index_adder, "Wrong! It's Sirina Thirsty!")
	dialogues.insert(23 + current_index_adder, "(How... How could I forget the victim's name..)")
	dialogues.insert(24 + current_index_adder, "I am sorry, Your Honor. I will never do that again.")
	dialogues.insert(25 + current_index_adder, "Focus, Rain! This is a serious matter!")
	char_names.insert(22 + current_index_adder, 'Judge')
	char_names.insert(23 + current_index_adder, 'Rain')
	char_names.insert(24 + current_index_adder,'Rain')
	char_names.insert(25 + current_index_adder, 'Ms. Cris')
	text_styles.insert(22 + current_index_adder, 1)
	text_styles.insert(23 + current_index_adder, 2)
	text_styles.insert(24 + current_index_adder, 1)
	text_styles.insert(25 + current_index_adder, 1)
	text_sound.insert(22 + current_index_adder,1)
	text_sound.insert(23 + current_index_adder,1)
	text_sound.insert(24 + current_index_adder,1)
	text_sound.insert(25 + current_index_adder,1)
	spriteToDisplay.insert(22 + current_index_adder,0)
	spriteToDisplay.insert(23 + current_index_adder,0)
	spriteToDisplay.insert(24 + current_index_adder,0)
	spriteToDisplay.insert(25 + current_index_adder,0)
	backgrounds.insert(22 + current_index_adder,0)
	backgrounds.insert(23 + current_index_adder,2)
	backgrounds.insert(24 + current_index_adder,2)
	backgrounds.insert(25 + current_index_adder,3)
	current_index_adder += 4
	update_dialogue()
	current_index += 1
	
func SirinaWillie_pressed():
	selected.play()
	SirinaThirsty.visible = false
	SerenaWilliams.visible = false
	SirinaWillie.visible = false
	dialogueBoxButton.visible = true
	dialogues[21 + current_index_adder] = 'Uhm... the victim’s name is Sirina Willie'
	dialogues.insert(22 + current_index_adder, "Wrong! It's Sirina Thirsty!")
	dialogues.insert(23 + current_index_adder, "(How... How could I forget the victim's name..)")
	dialogues.insert(24 + current_index_adder, "I am sorry, Your Honor. I will never do that again.")
	dialogues.insert(25 + current_index_adder, "Focus, Rain! This is a serious matter!")
	char_names.insert(22 + current_index_adder, 'Judge')
	char_names.insert(23 + current_index_adder, 'Rain')
	char_names.insert(24 + current_index_adder, 'Rain')
	char_names.insert(25 + current_index_adder, 'Ms. Cris')
	text_styles.insert(22 + current_index_adder, 1)
	text_styles.insert(23 + current_index_adder, 2)
	text_styles.insert(24 + current_index_adder, 1)
	text_styles.insert(25 + current_index_adder, 1)
	text_sound.insert(22 + current_index_adder,1)
	text_sound.insert(23 + current_index_adder,1)
	text_sound.insert(24 + current_index_adder,1)
	text_sound.insert(25 + current_index_adder,1)
	spriteToDisplay.insert(22 + current_index_adder,0)
	spriteToDisplay.insert(23 + current_index_adder,0)
	spriteToDisplay.insert(24 + current_index_adder,0)
	spriteToDisplay.insert(25 + current_index_adder,0)
	backgrounds.insert(22 + current_index_adder,0)
	backgrounds.insert(23 + current_index_adder,2)
	backgrounds.insert(24 + current_index_adder,2)
	backgrounds.insert(25 + current_index_adder,3)
	current_index_adder += 4
	update_dialogue()
	current_index += 1
	
func Poisoned_pressed():
	selected.play()
	Poisoned.visible = false
	Strangled.visible = false
	Drowned.visible = false
	dialogueBoxButton.visible = true
	dialogues[23 + current_index_adder] = 'She died of poisoning, Your Honor'
	dialogues[24 + current_index_adder] = "I'll let that slide for now Mr.de Luca"
	dialogues[25 + current_index_adder] = "Thank you, Your Honor."
	dialogues.insert(24 + current_index_adder, "Wrong! She died of drowning!")
	dialogues.insert(25 + current_index_adder, "(How... How could I forget how the victim died...)")
	dialogues.insert(26 + current_index_adder, "I am sorry, Your Honor. I will never do that again.")
	dialogues.insert(27 + current_index_adder, "Rain! focus!")
	char_names.insert(24 + current_index_adder, 'Judge')
	char_names.insert(25 + current_index_adder, 'Rain')
	char_names.insert(26 + current_index_adder, 'Rain')
	char_names.insert(27 + current_index_adder, 'Ms.Cris')
	text_styles.insert(24 + current_index_adder, 1)
	text_styles.insert(25 + current_index_adder, 2)
	text_styles.insert(26 + current_index_adder, 1)
	text_styles.insert(27 + current_index_adder, 1)
	text_sound.insert(24 + current_index_adder,1)
	text_sound.insert(25 + current_index_adder,1)
	text_sound.insert(26 + current_index_adder,1)
	text_sound.insert(27 + current_index_adder,1)
	spriteToDisplay.insert(24 + current_index_adder,0)
	spriteToDisplay.insert(25 + current_index_adder,0)
	spriteToDisplay.insert(26 + current_index_adder,0)
	spriteToDisplay.insert(27 + current_index_adder,0)
	backgrounds.insert(24 + current_index_adder,0)
	backgrounds.insert(25 + current_index_adder,2)
	backgrounds.insert(26 + current_index_adder,2)
	backgrounds.insert(27 + current_index_adder,3)
	update_dialogue()
	current_index += 1

func Strangled_pressed():
	selected.play()
	Poisoned.visible = false
	Strangled.visible = false
	Drowned.visible = false
	dialogueBoxButton.visible = true
	dialogues[23 + current_index_adder] = 'She died of strangling, Your Honor'
	dialogues[24 + current_index_adder] = "I'll let that slide for now Mr.de Luca"
	dialogues[25 + current_index_adder] = "Thank you, Your Honor."
	dialogues.insert(24 + current_index_adder, "Wrong! She died of drowning!")
	dialogues.insert(25 + current_index_adder, "(How... How could I forget how the victim died...)")
	dialogues.insert(26 + current_index_adder, "I am sorry, Your Honor. I will never do that again.")
	dialogues.insert(27 + current_index_adder, "Rain! focus!")
	char_names.insert(24 + current_index_adder, 'Judge')
	char_names.insert(25 + current_index_adder, 'Rain')
	char_names.insert(26 + current_index_adder, 'Rain')
	char_names.insert(27 + current_index_adder, 'Ms.Cris')
	text_styles.insert(24 + current_index_adder, 1)
	text_styles.insert(25 + current_index_adder, 2)
	text_styles.insert(26 + current_index_adder, 1)
	text_styles.insert(27 + current_index_adder, 1)
	text_sound.insert(24 + current_index_adder,1)
	text_sound.insert(25 + current_index_adder,1)
	text_sound.insert(26 + current_index_adder,1)
	text_sound.insert(27 + current_index_adder,1)
	spriteToDisplay.insert(24 + current_index_adder,0)
	spriteToDisplay.insert(25 + current_index_adder,0)
	spriteToDisplay.insert(26 + current_index_adder,0)
	spriteToDisplay.insert(27 + current_index_adder,0)
	backgrounds.insert(24 + current_index_adder,0)
	backgrounds.insert(25 + current_index_adder,2)
	backgrounds.insert(26 + current_index_adder,2)
	backgrounds.insert(27 + current_index_adder,3)
	update_dialogue()
	current_index += 1
	
func Drowned_pressed():
	selected.play()
	Poisoned.visible = false
	Strangled.visible = false
	Drowned.visible = false
	dialogueBoxButton.visible = true
	update_dialogue()
	current_index += 1
	
	
func courtRecButton_pressed():
	inventory.toggle()

func dialogue_button_pressed():
	if current_index < dialogues.size():
		if current_index == 1:
			hammer.visible = true
			hammer.play()
			gavel.play()
			await get_tree().create_timer(0.8).timeout
			hammer.visible = false
		if current_index == 8:
			AlexaYalaButton.visible = true
			MsCrisButton.visible = true
			RainButton.visible = true
			dialogueBoxButton.visible = false
		if (current_index == 24 && current_index_adder == 3) || (current_index == 21 && current_index_adder == 0):
			SirinaThirsty.visible = true
			SerenaWilliams.visible = true
			SirinaWillie.visible = true
			dialogueBoxButton.visible = false
		
		if (current_index == 23 && current_index_adder == 0) ||  (current_index == 27 && current_index_adder == 4) || (current_index == 30 && current_index_adder == 7) || (current_index == 26 && current_index_adder == 3):
			Poisoned.visible = true
			Strangled.visible = true
			Drowned.visible = true
			dialogueBoxButton.visible = false
		
		dialogueBox.visible = true
		personNameBox.visible = true
		courtRecButton.visible = true
		
		if is_typing:
			complete_dialogue()
		else:
			update_dialogue()
			current_index += 1
	else:
		complete_dialogue()
		await get_tree().create_timer(1).timeout
		SceneTransition.load_scene("res://scenes/crossExam1.tscn")

func update_dialogue():
	if current_index < dialogues.size():
		current_text = dialogues[current_index]
		current_name = char_names[current_index]
		dialogue_label.text = ""
		name_label.text = current_name
		apply_text_sound(text_sound[current_index])
		apply_text_style(text_styles[current_index])
		update_background(backgrounds[current_index])
		is_typing = true
		if is_typing:
			await start_text_update()
	else:
		dialogue_label.text = "End of dialogues."
		
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
	is_typing = false
	dialogue_label.text = current_text
	blip.stop() 
		
		
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
	match background_index:
		0:
			background_texture = preload("res://assets/backgrounds/judgesSide.png")
		1:
			background_texture = preload("res://assets/backgrounds/prosecutorSide.jpg")
		2:
			background_texture = preload("res://assets/backgrounds/defenseSide.png")
		3:
			background_texture = preload("res://assets/backgrounds/cocounselSide.png")
		4:
			background_texture = preload("res://assets/backgrounds/witnessSide.jpg") # Default background if needed
		5:
			Blackbg.visible = true
	
	background_sprite.texture = background_texture

func apply_text_sound(text_value:int):
	match text_value:
		1: 
			current_audio = blip
		2:
			current_audio = typewrite
