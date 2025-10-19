extends State

const jump_dust=preload("res://scene/game/environment/jump_dust/jump_dust.tscn")

func enter() :
	
	var temp=jump_dust.instantiate()
	temp.global_position=obj.global_position
	obj.get_parent().add_child(temp)
	
	
	
	if obj.is_back_has_rigid:
		obj.velocity.y=-obj.jump_ability*1
		obj.velocity.x=obj.jump_ability*0.9*obj.face_dir

	else:
		obj.velocity.y=-obj.jump_ability
	
func exit() :
	pass

func update(_delta: float):
	pass
func physics_process(_delta: float):
	pass
	
func handled_input(_event: InputEvent):
	pass
