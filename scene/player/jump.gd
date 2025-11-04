extends State

const jump_dust=preload("res://scene/game/environment/jump_dust/jump_dust.tscn")




func fall():
		change_use_all(true)
		finished.emit("fall")
signal s_fall

func enter() :
	obj.velocity.y=-obj.jump_speed
	s_fall.connect(fall,CONNECT_ONE_SHOT)
	
	var temp=jump_dust.instantiate()
	temp.global_position=obj.global_position
	obj.get_parent().add_child(temp)
	
	
	
	if obj.is_back_has_rigid:
		obj.velocity.y=-obj.climb_ability
		obj.velocity.x=obj.climb_ability*0.9*obj.face_dir
		
		
	change_use_all(false)
	$"../../hurt".is_use=true
	$"../../died".is_use=true


	
	
func exit():
	temp=GlobalValue.gravity
	frame=0
func update(_delta: float):
	pass
var temp=GlobalValue.gravity#用来调谐重力
var frame=0
func physics_process(_delta: float):
	frame+=_delta*obj.jump_ability
	temp=(1-ease(frame,0.32))*GlobalValue.gravity#重力变化曲线
	if Input.is_action_pressed("jump"):
		obj.velocity.y=move_toward(obj.velocity.y,-obj.jump_speed,temp*_delta)
	if Input.is_action_just_released("jump"):
		s_fall.emit()
	if obj.velocity.y>=0:
		s_fall.emit()
			
func handled_input(_event: InputEvent):
	pass
