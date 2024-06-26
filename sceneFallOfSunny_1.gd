extends Control

var dialogues = [
	"Now, we need to piece this together... Any ideas on how your DNA ended up at the crime scene with the handkerchief?"
]

var char_names = [
	"Ms. Cris"
]

# Text style 1 = White, Spoken Dialogue
# Text style 2 = Blue, Inner Thoughts
# Text style 3 = Green, centered, Current setting (time and place)

var text_styles = [
	1
]

# spriteToDisplay 0 = No sprite to display
# spriteToDisplay 1 = Ms.Cris

var spriteToDisplay = [
	1
]

var text_sound = [
	1
]

# background 0 = Judge Side
# background 1 = Prosecutor Side
# background 2 = Defense Side
# background 3 = Co-Counsel Side
# background 4 = Witness Side

var backgrounds = [
	3
]

var current_index = 0
var char_index = 0
var is_typing = false
var text_speed = 0.05
var current_text = ""
var current_audio
var save_file_path = "user://current_index.txt"

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

@onready var yes_button = $Yes as Button
@onready var no_button = $No as Button

@onready var blip = $blip
@onready var typewrite = $typewrite

@onready var mscris_sprite = $mscris_sprite
@onready var mscris_sprite_animation = $mscris_sprite/mscris_sprite_animation

func _ready():
	update_dialogue()
	yes_button.visible = false
	no_button.visible = false
	
	name_label.horizontal_alignment = 1
	dialogueBoxButton.pressed.connect(dialogue_button_pressed)
	courtRecButton.pressed.connect(courtRecButton_pressed)
	
	yes_button.pressed.connect(yes_scene)
	no_button.pressed.connect(no_scene)

func yes_scene():
	get_tree().change_scene_to_file("res://scenes/scene_ClosingStart.tscn")
	
func no_scene():
	get_tree().change_scene_to_file("res://scenes/scene_FallOfSunny_2.tscn")

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
	dialogueBoxButton.visible = false
	yes_button.visible = true
	no_button.visible = true
	is_typing = false

func complete_dialogue():
	dialogue_label.text = current_text
	dialogueBoxButton.visible = false
	yes_button.visible = true
	no_button.visible = true
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
	mscris_sprite.visible = false
	match sprite:
		0:
			if is_typing:
				await start_text_update()
		1:
			mscris_sprite.visible = true
			mscris_sprite_animation.play("Talking")
			if is_typing:
				await start_text_update()
			mscris_sprite_animation.play("Blinking")
		_:
			if is_typing:
				await start_text_update()

func save_num(num: int, filePath: String):
	var file = FileAccess.open(filePath, FileAccess.WRITE)
	file.store_var(num)
	file.close()
