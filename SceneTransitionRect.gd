extends ColorRect

@export_file var next_scene_path: String

@onready var _anim_player = $AnimationPlayer as AnimationPlayer

func _ready():
	_anim_player.play_backwards("Fade")

func transition_to(_next_scene: String = next_scene_path) -> void:
	_anim_player.play("Fade")
	await _anim_player.animation_finished
	get_tree().change_scene_to_file("res://scenes/scene1.tscn")
