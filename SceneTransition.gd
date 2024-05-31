extends CanvasLayer

@onready var color_rect = $ColorRect as ColorRect
@onready var animation_player = $ColorRect/AnimationPlayer as AnimationPlayer
@onready var black_rect = $BlackRect as ColorRect

func _ready():
	color_rect.visible = false
	black_rect.visible = false

func load_scene(target_scene: String):
	color_rect.visible = true
	black_rect.visible = true
	animation_player.play("Fade")
	await animation_player.animation_finished
	get_tree().change_scene_to_file(target_scene)
	animation_player.play("Fade_Backwards")
	await animation_player.animation_finished
	black_rect.visible = false

func reload_scene():
	animation_player.play("Fade")
	await animation_player.animation_finished
	get_tree().reload_current_scene()
	animation_player.play("Fade_Backwards")
	await animation_player.animation_finished
