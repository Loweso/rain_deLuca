extends Control

@onready var startButton = $StartGameButton as Button
@onready var quitButton = $QuitButton as Button
@onready var transition = $SceneTransition

func _ready():
	quitButton.pressed.connect(_on_exit_pressed)
	startButton.pressed.connect(_start_scene_play)

func _on_exit_pressed():
	get_tree().quit()

func _start_scene_play():
	SceneTransition.load_scene("res://scenes/scene1.tscn")
	#transition.transition_to("res://scenes/scene1.tscn")

