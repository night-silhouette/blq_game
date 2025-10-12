extends State_machine

func phy_middleware():
	if(gameInputControl.row_dir==0 and current_state.name!="idle"):
		change_state("idle")
	if(gameInputControl.row_dir!=0 and current_state.name!="run"):
		change_state("run")
	if(gameInputControl.is_jump and current_state.name!="jump"):
		change_state("jump")
	if(gameInputControl.is_dash and current_state.name!="dash"):
		change_state("dash")
