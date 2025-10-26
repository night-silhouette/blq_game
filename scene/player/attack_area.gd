extends Area2D
func _ready() -> void:
	print(1)
	body_entered.connect(func(body):
		print(1)
		
		)
		
