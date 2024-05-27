extends Control

var dialogues = [
	"Welcome to our game!",
	"This is the second line of dialogue.",
	"And here is the third line.\nThis is to test newlines.",
	"Good luck on your journey!"
]

var char_names = [
	"Rain",
	"Sunny",
	"Rain",
	"Serena"
]

# Text style 1 = White, Spoken Dialogue
# Text style 2 = Blue, Inner Thoughts
# Text style 3 = Green, centered, Current setting (time and place)

var text_styles = [
	1,
	2, 
	3,
	2
]

# spriteToDisplay 0 = No sprite to display
# spriteToDisplay 1 = Maya, looking forward
# spriteToDisplay 2 = Maya, talking

var spriteToDisplay = [
	2,
	1, 
	2,
	0
]

var current_index = 0

var char_index = 0
var current_text = ""
var current_name = ""
var text_speed = 0.08
var is_typing = false

@onready var dialogue_label = $DialogueText as Label
@onready var name_label = $PersonNameText as Label
@onready var personNameBox = $PersonNameBox as Polygon2D
@onready var dialogueBox = $DialogueBox as Polygon2D
@onready var dialogueBoxButton = $DialogueBoxButton as Button
@onready var courtRecButton = $CourtRecordButton as Button
@onready var transition = $SceneTransition

@onready var inventory = $Inventory_UI
@onready var inv: Inv

@onready var rain_sprite = $RainSprite as Sprite2D
@onready var rain_sprite_animation = $RainSprite/RainTalking as AnimationPlayer

@onready var blip = $blip


func _ready():
	name_label.horizontal_alignment = 1
	personNameBox.visible = false
	courtRecButton.visible = false
	
	dialogueBoxButton.pressed.connect(dialogue_button_pressed)
	courtRecButton.pressed.connect(courtRecButton_pressed)

func courtRecButton_pressed():
	inventory.toggle()

func dialogue_button_pressed():
	if current_index < dialogues.size():
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
		SceneTransition.load_scene("res://scenes/scene2.tscn")

func update_dialogue():
	if current_index < dialogues.size():
		current_text = dialogues[current_index]
		current_name = char_names[current_index]
		dialogue_label.text = ""
		name_label.text = current_name
		apply_text_style(text_styles[current_index])
		update_sprites(spriteToDisplay[current_index])
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
		blip.play()
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
	
func update_sprites(sprite: int):
	rain_sprite.visible = false
	
	match sprite:
		1:
			rain_sprite.visible = true
			rain_sprite_animation.play("Listening")
		2:
			rain_sprite.visible = true
			rain_sprite_animation.play("Talking")
