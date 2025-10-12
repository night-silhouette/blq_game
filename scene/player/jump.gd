extends State
func enter() :
	obj.velocity.y-=obj.jump_ability
	
func exit() :
	pass

func update(_delta: float):
	pass
func physics_process(_delta: float):
	pass
	
func handled_input(_event: InputEvent):
	pass
