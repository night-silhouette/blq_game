extends State
func enter() :
	change_use_all(false)
	Util.set_time(obj.dash_time,func():change_use_all(true))
	
func exit() :
	pass

func update(_delta: float):
	pass
	
func physics_process(_delta: float):
	obj.velocity.x=obj.face_dir*obj.dash_speed
	obj.velocity.y=0
	
func handled_input(_event: InputEvent):
	pass
