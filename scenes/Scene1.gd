extends Control

var dialogues = [
	"Welcome to our game!",
	"This is the second line of dialogue.",
	"And here is the third line.",
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

var current_index = 0

@onready var dialogue_label = $DialogueText as Label
@onready var name_label = $PersonNameText as Label

@onready var rain_sprite = $RainSprite as Sprite2D
@onready var rain_sprite_animation = $RainSprite/RainTalking as AnimationPlayer

func _ready():
	name_label.horizontal_alignment = 1

func _input(event):
	if event is InputEventMouseButton and event.is_pressed():
		_on_Button_pressed()

func update_dialogue():
	if current_index < dialogues.size():
		dialogue_label.text = dialogues[current_index]
		name_label.text = char_names[current_index]
		apply_text_style(text_styles[current_index])
		update_sprites(char_names[current_index])
	else:
		dialogue_label.text = "End of dialogues."

func _on_Button_pressed():
	update_dialogue()
	update_sprites(name_label.text)
	current_index += 1
	if current_index >= dialogues.size():
		current_index = 0
		
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
	
func update_sprites(character_name: String):
	rain_sprite.visible = false
	
	match character_name:
		"Rain":
			rain_sprite.visible = true
			rain_sprite_animation.play("Talking")
