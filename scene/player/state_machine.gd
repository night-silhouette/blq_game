extends State_machine

func phy_middleware():
	if(gameInputControl.row_dir==0 and obj.is_on_floor() and !obj.is_front_has_rigid):
		change_state("idle")
	if(gameInputControl.row_dir!=0 and obj.is_on_floor() and !obj.is_front_has_rigid):
		change_state("run")
	if(gameInputControl.is_jump):
		change_state("jump")
	if(!obj.is_on_floor() and !obj.is_front_has_rigid):
		change_state("fall")
	if(gameInputControl.is_dash):
		change_state("dash")
	if(obj.is_front_has_rigid):
		change_state("climb")
	if(gameInputControl.is_crouch):
		change_state("crouch")
