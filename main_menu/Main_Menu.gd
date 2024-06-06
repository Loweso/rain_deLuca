extends Control

var index_path = "user://current_index.txt"
var no_of_mistakes_path = "user://mistakes_num.txt"
var press_states_path = "user://press_states.txt"
var press_states = [false, false, false, false]

@onready var startButton = $StartGameButton as Button
@onready var quitButton = $QuitButton as Button
@onready var transition = $SceneTransition
@onready var buttonBlip = $buttonblip

func _ready():
	quitButton.pressed.connect(_on_exit_pressed)
	startButton.pressed.connect(_start_scene_play)
	
	save_num(0, index_path)
	save_num(0, no_of_mistakes_path)
	save_press_states()

func _on_exit_pressed():
	buttonBlip.play()
	get_tree().quit()

func _start_scene_play():
	buttonBlip.play()
	SceneTransition.load_scene("res://scenes/scene1.tscn")
	
func save_num(num: int, filePath: String):
	var file = FileAccess.open(filePath, FileAccess.WRITE)
	file.store_var(num)
	file.close()

func save_press_states():
	var file = FileAccess.open(press_states_path, FileAccess.WRITE)
	if file:
		file.store_var(press_states)
		file.close()
