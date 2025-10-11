extends GameInputControl


var row_dir:float
var is_jump:bool
signal special_state_start(state)
signal special_state_end(state)

func _physics_process(delta: float) -> void:
	
	row_dir=Input.get_axis("move_l","move_r")
	is_jump=obj.is_on_floor() and Input.is_action_just_pressed("jump")
