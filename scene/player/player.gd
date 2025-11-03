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
@onready var player_hp_bar=get_tree().get_nodes_in_group("ui").filter(func(value):return value.ui_name=="player血条")[0]


@export_category("properties")#------------------------------------------------
@export_group("physical_prop")
@export var jump_speed=300
@export var hurt_time=0.3#僵直时长
@export var accerleration=2500;
@export var speed=230;
@export var friction=3000;
@export var jump_ability=400
@export var dash_time=0.15
@export var dash_speed=700;
@export var dash_span=0.65
@export var max_fall_speed=100
@export var unbeatable_time=0.3
@export var climb_ability=500

@export_group("attack_prop")
@export var long_attack_span=0.4
@export var short_attack_span=0.3
@export var long_attack_coefficient=1
@export var short_attack_coefficient=1.2
@export var damage=30

@export_group("state_prop")

@export var Max_HP:float =100:
	set(value):
		Max_HP=value
		if player_hp_bar:
			player_hp_bar.max_hp=Max_HP
		if Max_HP<now_HP:
			now_HP=Max_HP
@export var now_HP:float =100:
	set(value):
		if (value>Max_HP):
			now_HP=Max_HP
		elif(value<=0):
			now_HP=0
			move_state_machine.change_state("died")
		else :
			now_HP=value
		if player_hp_bar:
			player_hp_bar.now_hp=now_HP
var is_special_state=false
var now_attack_dir=1    #1：上  2：下  3：左  4：右

func init_max_hp():
	player_hp_bar.max_hp=Max_HP
	player_hp_bar.now_hp=now_HP
func _ready():
	call_deferred("init_max_hp")
	
	
	#init state_machine    --starting--
	move_state_machine.init(self,ani_move,gameInputControl)
	collision_management.init(self,null,gameInputControl)
	attack_state_machine.init(self,ani_attack,gameInputControl)
	#init state_machine    --ending--
	
	
	@warning_ignore("unused_parameter")
	gameInputControl.special_state_start.connect(func(state):is_special_state=true)
	@warning_ignore("unused_parameter")
	gameInputControl.special_state_end.connect(func(state):is_special_state=false)
	
var face_dir=1
var is_front_has_rigid:bool=false
var is_back_has_rigid:bool=false

func _physics_process(delta: float) -> void:
	$hp.text=str(now_HP)+"hp"
	debug.text="速度<%d,%d> %s" %[velocity.x,velocity.y,move_state_machine.cur_state_name]
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
	
	
var hurt_lock=true
func be_hurted(damage):
	if hurt_lock:
		now_HP-=damage
		hurt_lock=false
		move_state_machine.change_state("hurt")
		get_tree().create_timer(unbeatable_time).timeout.connect(func():hurt_lock=true)
		
		
		
		
		
		
		
		
