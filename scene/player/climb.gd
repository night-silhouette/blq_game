extends State



func enter() :
	pass
	
func exit() :
	pass

func update(_delta: float):
	pass
func physics_process(_delta: float):
	gameInputControl.dash_control_flag=true
	if (! obj.is_front_has_rigid):
		finished.emit("idle")
	if obj.velocity.y > obj.max_fall_speed:
		obj.velocity.y=obj.max_fall_speed
	if(Input.is_action_just_pressed("jump")):
		obj.velocity.y=-obj.climb_ability
		obj.velocity.x=-obj.climb_ability*0.9*obj.face_dir
		finished.emit("fall")
func handled_input(_event: InputEvent):
	pass
