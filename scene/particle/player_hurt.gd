extends AnimatedSprite2D
func _ready() -> void:
	play()

func _process(delta: float) -> void:

	animation_finished.connect(func():queue_free())
	
	
	
