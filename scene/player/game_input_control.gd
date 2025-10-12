extends GameInputControl


var row_dir:float
var is_jump:bool
var is_dash:bool=false
var dash_control_flag:bool=true#dash时长控制用的
var dash_span_flag:bool=true
signal special_state_start(state)
signal special_state_end(state)

func is_dash_temp():
	if(dash_control_flag and Input.is_action_just_pressed("dash")):
		dash_control_flag=false
		dash_span_flag=false
		special_state_start.emit("dash")
		get_tree().create_timer(obj.dash_time).timeout.connect(func():special_state_end.emit("dash"),CONNECT_ONE_SHOT)
		get_tree().create_timer(obj.dash_span).timeout.connect(func():dash_span_flag=true,CONNECT_ONE_SHOT)
		return true
	else :
		return false

func _physics_process(delta: float) -> void:
	
	if (!dash_control_flag and obj.is_on_floor() and dash_span_flag):
		dash_control_flag=true
	
	
	row_dir=Input.get_axis("move_l","move_r")
	is_jump=obj.is_on_floor() and Input.is_action_just_pressed("jump")
	is_dash=is_dash_temp()

		
