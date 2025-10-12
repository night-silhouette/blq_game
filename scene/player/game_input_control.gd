extends GameInputControl


@onready var left_head=$"../left_head"
@onready var right_head=$"../right_head"


var row_dir:float
var is_jump:bool
var is_dash:bool=false
var is_crouch:bool=false
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

var crouch_flag=1

func is_crouch_temp():
	if Input.is_action_just_pressed("crouch"):
		crouch_flag=2
	if Input.is_action_just_released("crouch"):
		crouch_flag=3
	if crouch_flag==1 :
		return false
	elif crouch_flag==2:
		return true
	elif crouch_flag==3 :
		if !left_head.is_colliding() and !right_head.is_colliding():
			crouch_flag = 1
			return false
		else :
			return true
		

func _physics_process(delta: float) -> void:
	
	if (!dash_control_flag and obj.is_on_floor() and dash_span_flag):
		dash_control_flag=true
	
	
	row_dir=Input.get_axis("move_l","move_r")
	is_jump=obj.is_on_floor() and Input.is_action_just_pressed("jump")
	is_dash=is_dash_temp()
	
	is_crouch=is_crouch_temp()
		
		
		
		
		
		
		
