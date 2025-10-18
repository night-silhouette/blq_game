extends State

func enter():
	$"../../main_collision".position.y+=6
	$"../../front_head".enabled=false
	$"../../back_head".enabled=false
	$"../../move_state_machine/jump".is_use=false
	$"../../move_state_machine/climb".is_use=false
	$"../../move_state_machine/dash".is_use=false
func exit():
	$"../../main_collision".position.y-=6
	$"../../front_head".enabled=true
	$"../../back_head".enabled=true
	$"../../move_state_machine/jump".is_use=true
	$"../../move_state_machine/climb".is_use=true
	$"../../move_state_machine/dash".is_use=true
