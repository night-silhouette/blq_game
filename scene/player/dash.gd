extends State
func enter() :
	pass
	
func exit() :
	pass

func update(_delta: float):
	pass
func physics_process(_delta: float):
	obj.velocity.x=obj.face_dir*obj.dash_speed
	obj.velocity.y=0
func handled_input(_event: InputEvent):
	pass
