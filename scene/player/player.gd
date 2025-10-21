extends CharacterBody2D
@onready var ani_move=$ani_move 
@onready var ani_attack=$ani_attack
@onready var move_state_machine=$move_state_machine
@onready var collision_management=$Collision_management
@onready var gameInputControl=$GameInputControl
@onready var front_foot=$front_foot
@onready var front_head=$front_head
@onready var front_body=$front_body
@onready var back_foot=$back_foot
@onready var back_head=$back_head
@onready var back_body=$back_body
@onready var debug=$debug
@onready var attack_state_machine=$attack_state_machine
@onready var sprite=$sprite

@export var accerleration=2500;
@export var speed=230;
@export var friction=3000;
@export var jump_ability=400
@export var dash_time=0.15
@export var dash_speed=700;
@export var dash_span=0.65
@export var max_fall_speed=100
@export var long_attack_span=0.4
@export var short_attack_span=0.3
var is_special_state=false
func _ready():
	
	
	move_state_machine.init(self,ani_move,gameInputControl)
	collision_management.init(self,null,gameInputControl)
	attack_state_machine.init(self,ani_attack,gameInputControl)
	#init state_machine --ending--
	
	
	@warning_ignore("unused_parameter")
	gameInputControl.special_state_start.connect(func(state):is_special_state=true)
	@warning_ignore("unused_parameter")
	gameInputControl.special_state_end.connect(func(state):is_special_state=false)
	
var face_dir=1
var is_front_has_rigid:bool=false
var is_back_has_rigid:bool=false

func _physics_process(delta: float) -> void:
	debug.text="速度<%d,%d>" %[velocity.x,velocity.y]
	if attack_state_machine.attack_mode==1:
		$attack_mode.text="矛"
	else:
		$attack_mode.text="刀"
	
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
	
	
		
		
		
		
		
		
		
		
		
		
