extends State_machine

var attack_mode=1#"long"

func phy_middleware():
	if gameInputControl.is_switch:
		attack_mode=-attack_mode
	if gameInputControl.is_attack:
		pass
