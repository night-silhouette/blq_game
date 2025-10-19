extends Node2D
@onready var animationplayer=$AnimationPlayer
func _ready() -> void:
	animationplayer.play("jump_dust")
	animationplayer.animation_finished.connect(func(_t):
		self.queue_free()
		
		)
