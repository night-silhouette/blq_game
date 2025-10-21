extends Button


func _ready() -> void:
	pressed.connect(func():get_tree().change_scene_to_file("res://scene/game/game.tscn"))
	
	
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("setting"):
		get_tree().change_scene_to_file("res://scene/game/game.tscn")
