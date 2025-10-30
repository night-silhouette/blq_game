extends State



func enter() :
	pass
	
func exit() :
	pass

func update(_delta: float):
	pass
func physics_process(_delta: float):
	if obj.velocity.y > obj.max_fall_speed:
		obj.velocity.y=obj.max_fall_speed
	if(Input.is_action_just_pressed("jump")):
		obj.velocity.y=-410
		obj.velocity.x=-370*obj.face_dir
		finished.emit("fall")
func handled_input(_event: InputEvent):
	pass
