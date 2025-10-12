extends CharacterBody2D
@onready var animationPlayer=$AnimationPlayer
@onready var state_machine=$State_machine
@onready var collision_management=$Collision_management
@onready var gameInputControl=$GameInputControl
@onready var front_foot=$front_foot
@onready var front_head=$front_head
@onready var front_body=$front_body
@onready var back_foot=$back_foot
@onready var back_head=$back_head
@onready var back_body=$back_body
@onready var debug=$debug


@export var accerleration=1000;
@export var speed=220;
@export var friction=1200;
@export var jump_ability=300
@export var dash_time=0.20
@export var dash_speed=550;
@export var dash_span=0.5
@export var max_fall_speed=80
var is_special_state=false
func _ready():
	state_machine.init(self,animationPlayer,collision_management,gameInputControl)
	gameInputControl.special_state_start.connect(func(state):is_special_state=true)
	gameInputControl.special_state_end.connect(func(state):is_special_state=false)
	
var face_dir=1
var is_front_has_rigid:bool=false
var is_back_has_rigid:bool=false

func _physics_process(delta: float) -> void:
	debug.text="<%d,%d>" %[velocity.x,velocity.y]
	
	
	
	if not is_special_state:#一些特殊状态 ban常规逻辑
		velocity.y+=GlobalValue.gravity
		if gameInputControl.row_dir>0:
			velocity.x=move_toward(velocity.x,speed,accerleration*delta)
		if gameInputControl.row_dir<0:
			velocity.x=move_toward(velocity.x,-speed,accerleration*delta)
		if gameInputControl.row_dir==0:
			velocity.x=move_toward(velocity.x,0,friction*delta)
	

		
	move_and_slide()
	
	
	if gameInputControl.row_dir!=0:
		var new_face_dir=gameInputControl.row_dir
		if face_dir!=new_face_dir:
			front_foot.scale.x*=-1
			front_head.scale.x*=-1
			front_body.scale.x*=-1
			back_foot.scale.x*=-1
			back_head.scale.x*=-1
			back_body.scale.x*=-1
		face_dir = new_face_dir
	is_front_has_rigid=front_foot.is_colliding() or front_head.is_colliding() or front_body.is_colliding()
	is_back_has_rigid=back_foot.is_colliding() or back_head.is_colliding() or back_body.is_colliding()
	
	
		
		
		
		
		
		
		
		
		
		
