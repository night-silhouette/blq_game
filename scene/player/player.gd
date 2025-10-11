extends CharacterBody2D
@onready var animationPlayer=$AnimationPlayer
@onready var state_machine=$State_machine
@onready var collision_management=$Collision_management
@onready var gameInputControl=$GameInputControl

@export var accerleration=900;
@export var speed=220;
@export var friction=1200;
var is_special_state=false
func _ready():
	state_machine.init(self,animationPlayer,collision_management,gameInputControl)
	gameInputControl.special_state_start.connect(func(state):is_special_state=true)
	gameInputControl.special_state_end.connect(func(state):is_special_state=false)
func _physics_process(delta: float) -> void:
	if not is_special_state:#一些特殊状态 ban常规逻辑
		velocity.y+=GlobalValue.gravity
		if gameInputControl.row_dir>0:
			velocity.x=move_toward(velocity.x,speed,accerleration*delta)
		if gameInputControl.row_dir<0:
			velocity.x=move_toward(velocity.x,-speed,accerleration*delta)
		if gameInputControl.row_dir==0:
			velocity.x=move_toward(velocity.x,0,friction*delta)
	

		
	move_and_slide()
