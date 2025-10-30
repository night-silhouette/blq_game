extends State

func enter():
	for item in $"..".get_children():
		item.is_use=false
