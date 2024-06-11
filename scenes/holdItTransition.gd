extends CanvasLayer

@onready var holdItBubble = $HoldItBubble as Sprite2D
@onready var animation_player = $HoldItBubble/AnimationPlayer as AnimationPlayer

func _ready():
	holdItBubble.visible = false
	
func load_scene(target_scene: String):
	holdItBubble.visible = true
	$HoldItBubble/AudioStreamPlayer2D.play()
	animation_player.play("Appear")
	await animation_player.animation_finished
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file(target_scene)
