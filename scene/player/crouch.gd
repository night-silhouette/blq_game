extends State

func enter():
	$"../../main_collision".position.y+=6
	$"../../front_head".enabled=false
	$"../../back_head".enabled=false
func exit():
	$"../../main_collision".position.y-=6
	$"../../front_head".enabled=true
	$"../../back_head".enabled=true
