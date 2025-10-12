extends State
func enter() :
	obj.speed*=0.7
	
func exit() :
	obj.speed/=0.7

func update(_delta: float):
	pass 
func physics_process(_delta: float):
	pass
	
func handled_input(_event: InputEvent):
	pass
