extends State_machine

func phy_middleware():
	if(gameInputControl.is_fall):
		change_state("fall")
	if(gameInputControl.is_idle):
		change_state("idle")
	if(gameInputControl.is_run):
		change_state("run")
	if(gameInputControl.is_jump):
		change_state("jump")
	if(gameInputControl.is_dash):
		change_state("dash")
	if(obj.is_front_has_rigid):
		change_state("climb")
	if(gameInputControl.is_crouch):
		change_state("crouch")
