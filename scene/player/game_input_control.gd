extends GameInputControl


var row_dir:float
var is_jump:bool
var is_dash=false
var dash_control_flag:bool=true
signal special_state_start(state)
signal special_state_end(state)



func _physics_process(delta: float) -> void:
	
	if (!dash_control_flag and obj.is_on_floor()):
		dash_control_flag=true
	
	
	row_dir=Input.get_axis("move_l","move_r")
	is_jump=obj.is_on_floor() and Input.is_action_just_pressed("jump")
	is_dash=func():
		if(dash_control_flag and Input.is_action_just_pressed("dash")):
			dash_control_flag=false
			special_state_start.emit("dash")
			await get_tree().create_timer(obj.dash_time).timeout.connect(func():special_state_end.emit("dash"),CONNECT_ONE_SHOT)

			return true
		else :
			return false
		
