extends Control

var dialogues = [
	"- Rain's Testimony -",
	"I spent most of the morning finishing some paperwork and then came to the tennis venue to support Alexa Yala.",
	"While waiting for the match, I bought Alexa Yala merchandise.",
	"My focus was primarily on the tennis event, and I didn’t have any reason to visit the pool area.",
	"There was one individual who caught my attention. It was Sunny Flower, the prosecutor in this case. Why she was there, I don’t know.",
	"I… I really have nothing else to add. I didn’t do it.",
]

var char_names = [
	"",
	"Elay",
	"Elay",
	"Elay",
	"Elay",
	"Elay",
]

var text_sound = [
	2,
	1,
	1,
	1,
	1,
	1,
]

# Text style 1 = White, Spoken Dialogue
# Text style 2 = Blue, Inner Thoughts
# Text style 3 = Green, centered, Current setting (time and place)
# Text style 4 = Green, left-aligned, Witness Testimony Cross-examination
# Text style 5 = Red-Orange, center-aligned, CrossExamination title

var text_styles = [
	5,
	4,
	4, 
	4,
	4,
	4,
]

# spriteToDisplay 0 = No sprite to display
# spriteToDisplay 1 = Maya, looking forward
# spriteToDisplay 2 = Maya, talking

var spriteToDisplay = [
	0,
	2,
	1, 
	2,
	0,
	2,
]

# background 0 = Judge Side
# background 1 = Prosecutor Side
# background 2 = Defense Side
# background 3 = Co-Counsel Side
# background 4 = Witness Side

var backgrounds = [
	4,
	4,
	4, 
	4,
	4,
	4,
]

# witness_anim 0 = witness blinking
# witness_anim 1 = witness talking

var witness_anim = [
	0,
	1,
	1,
	1,
	1,
	1,
]

var current_index = 0
var current_crossExam = 0
var current_no_mistakes = 0
var save_file_path = "user://current_index.txt"
var no_of_mistakes_path = "user://mistakes_num.txt"

var current_audio
var is_typing = false
var char_index = 0
var current_text = ""
var text_speed = 0.05
var dialoguetime = 0

@onready var background_sprite = $Background as TextureRect
@onready var dialogue_label = $DialogueText as Label
@onready var name_label = $PersonNameText as Label
@onready var personNameBox = $PersonNameBox as Polygon2D
@onready var dialogueBox = $DialogueBox as Polygon2D
@onready var dialogueBoxButton = $DialogueBoxButton as Button
@onready var courtRecButton = $CourtRecordButton as Button
@onready var witness_sprite = $Background/WitnessSprite
@onready var witness_animation = $Background/WitnessSprite/AnimationPlayer

@onready var evidenceBox = $Evidence
@onready var inv: Inv

@onready var nextButton = $NextButton as Button
@onready var prevButton = $PrevButton as Button
@onready var pressButton = $PressButton as Button
@onready var mistakesContainer = $MistakesContainer
@onready var mistakes: Array = $MistakesContainer.get_children()
@onready var holdItTransition = $HoldItTransition

@onready var blip = $blip
@onready var typewrite = $typewrite

func _ready():
	dialogueBoxButton.visible = false
	load_current_index()
	update_dialogue()
	
	if current_index == 0:
		dialogueBoxButton.visible = true
	
	var mistakesFile = FileAccess.open(no_of_mistakes_path, FileAccess.READ)
	if mistakesFile:
		current_no_mistakes = mistakesFile.get_var()
		mistakesFile.close()
	else:
		save_num(0, no_of_mistakes_path)
	
	if current_index == 0:
		personNameBox.visible = false
		courtRecButton.visible = false
		nextButton.visible = false
		prevButton.visible = false
		pressButton.visible = false
		mistakesContainer.visible = false
		witness_sprite.visible = true
		mistakesContainer.layout_direction = 2
		
	for i in range(current_no_mistakes):
		mistakes[i].visible = false
	
	dialogueBoxButton.pressed.connect(dialogue_button_pressed)
	nextButton.pressed.connect(dialogue_button_pressed)
	prevButton.pressed.connect(prev_button_pressed)
	courtRecButton.pressed.connect(courtRecButton_pressed)
	pressButton.pressed.connect(press_button_pressed)

func load_current_index():
	var file = FileAccess.open(save_file_path, FileAccess.READ)
	if file:
		current_index = file.get_var()
		print(current_index)
		file.close()
	else:
		save_num(0, save_file_path)

func save_num(num: int, filePath: String):
	var file = FileAccess.open(filePath, FileAccess.WRITE)
	file.store_var(num)
	file.close()

func courtRecButton_pressed():
	evidenceBox.toggle(current_crossExam, current_index)

func dialogue_button_pressed():
	dialogueBoxButton.visible = false
	dialogueBox.visible = true
	personNameBox.visible = true
	courtRecButton.visible = true
	nextButton.visible = true
	pressButton.visible = true
	mistakesContainer.visible = true
	
	current_index += 1
	update_dialogue()
		
func prev_button_pressed():
	current_index -= 1
	update_dialogue()

func update_dialogue():
	is_typing = true
	if current_index >= dialogues.size():
		save_num(1, save_file_path)
		get_tree().change_scene_to_file("res://scenes/convoScene1.tscn")
	else:
		current_text = dialogues[current_index]
		dialogue_label.text = ""
		name_label.text = char_names[current_index]
		apply_text_sound(text_sound[current_index])
		apply_text_style(text_styles[current_index])
		update_background(backgrounds[current_index])
		update_sprites(witness_anim[current_index])
		update_buttons_visibility()
	
	
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
		4:
			color = Color(15 / 255.0, 242 / 255.0, 79 / 255.0)
			dialogue_label.horizontal_alignment = 0
		5:
			color = Color(255 / 255.0, 80 / 255.0, 63 / 255.0)
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
	
	background_sprite.texture = background_texture
	
func update_sprites(sprite: int):
	match sprite:
		0:
			witness_animation.play("blinking")
			if is_typing:
				await start_text_update()
		1:
			witness_animation.play("talking")
			if is_typing:
				await start_text_update()
			witness_animation.play("blinking")
		_:
			pass

func apply_text_sound(text_value:int):
	match text_value:
		1: 
			current_audio = blip
		2:
			current_audio = typewrite

func update_buttons_visibility():
	if current_index <= 1:
		prevButton.visible = false
	else:
		prevButton.visible = true
		
func press_button_pressed():
	match current_index:
		1:	
			# Put the next index of the current index in save_current_index
			save_num(2, save_file_path)
			holdItTransition.load_scene("res://scenes/pressScene1_1.tscn")
		2:	
			save_num(3, save_file_path)
			holdItTransition.load_scene("res://scenes/pressScene1_2.tscn")
		3:	
			save_num(4, save_file_path)
			holdItTransition.load_scene("res://scenes/pressScene1_3.tscn")
		4:	
			save_num(5, save_file_path)
			holdItTransition.load_scene("res://scenes/pressScene1_4.tscn")
		5:	
			save_num(1, save_file_path)
			holdItTransition.load_scene("res://scenes/pressScene1_5.tscn")
		_:
			pass
