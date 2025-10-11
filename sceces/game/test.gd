extends CharacterBody2D
var accelerate=1200;
var f=550
var max_v=Vector2(250,250);
func _physics_process(delta: float) -> void:
	var dir:Vector2 = Vector2(Input.get_axis("left","right"),-Input.get_axis("crouch","jump"));
	if dir.x>0:
		velocity.x=move_toward(velocity.x,max_v.x,accelerate*delta)
	if dir.x<0:
		velocity.x=move_toward(velocity.x,-max_v.x,accelerate*delta)
	if dir.y>0:
		velocity.y=move_toward(velocity.y,max_v.y,accelerate*delta)
	if dir.y<0:
		velocity.y=move_toward(velocity.y,-max_v.y,accelerate*delta)
	if dir.x==0:
		velocity.x=move_toward(velocity.x,0,f*delta)
	if dir.y==0:
		velocity.y=move_toward(velocity.y,0,f*delta)
	print(dir)
	print(velocity)
	move_and_slide();
		
