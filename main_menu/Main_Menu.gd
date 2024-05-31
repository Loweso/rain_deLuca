extends Control

@onready var startButton = $StartGameButton as Button
@onready var quitButton = $QuitButton as Button
@onready var transition = $SceneTransition
@onready var buttonBlip = $buttonblip

func _ready():
	quitButton.pressed.connect(_on_exit_pressed)
	startButton.pressed.connect(_start_scene_play)

func _on_exit_pressed():
	buttonBlip.play()
	get_tree().quit()

func _start_scene_play():
	buttonBlip.play()
	SceneTransition.load_scene("res://scenes/scene1.tscn")
	#transition.transition_to("res://scenes/scene1.tscn")

