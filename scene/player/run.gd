extends State
func enter() :
	pass
	
func exit() :
	pass

func update(_delta: float):
	if(gameInputControl.row_dir==0):
		finished.emit("idle")
	if(gameInputControl.is_jump):
		finished.emit("jump")
func physics_process(_delta: float):
	pass
	
func handled_input(_event: InputEvent):
	pass
