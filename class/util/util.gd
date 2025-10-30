extends Node

func set_time(time,callback):
	get_tree().create_timer(time).timeout.connect(callback,CONNECT_ONE_SHOT)
