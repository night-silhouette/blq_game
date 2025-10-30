extends State

var hurt_particle=preload("res://scene/particle/player_hurt.tscn")
func enter():
	obj.add_child(hurt_particle.instantiate())
	gameInputControl.special_state_start.emit("hurt")
	change_use_all(false)
	obj.velocity.y=0
	obj.velocity.x=0
	Util.set_time(obj.hurt_time,func():
		change_use_all(true)
		gameInputControl.special_state_end.emit("hurt")
		)
