extends Control

@onready var startButton = $StartGameButton as Button
@onready var quitButton = $QuitButton as Button

func _ready():
	quitButton.pressed.connect(_on_exit_pressed)
	startButton.pressed.connect(_start_scene_play)

func _on_exit_pressed() -> void:
	get_tree().quit()

func _start_scene_play() -> void:
	get_tree().change_scene_to_file("res://scenes/scene1.tscn")
