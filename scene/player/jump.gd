extends State
func enter() :
	if obj.is_back_has_rigid:
		obj.velocity.y=-obj.jump_ability*0.6
		obj.velocity.x=obj.jump_ability*1.1*obj.face_dir

	else:
		obj.velocity.y-=obj.jump_ability
	
func exit() :
	pass

func update(_delta: float):
	pass
func physics_process(_delta: float):
	pass
	
func handled_input(_event: InputEvent):
	pass
