extends CanvasLayer

@onready var takeThatBubble = $TakeThatBubble as Sprite2D
@onready var animation_player = $TakeThatBubble/AnimationPlayer as AnimationPlayer

func _ready():
	takeThatBubble.visible = false
	
func load_scene(target_scene: String):
	takeThatBubble.visible = true
	$TakeThatBubble/AudioStreamPlayer2D.play()
	animation_player.play("Appear")
	await animation_player.animation_finished
	get_tree().change_scene_to_file(target_scene)
