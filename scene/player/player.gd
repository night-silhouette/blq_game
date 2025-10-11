extends CharacterBody2D
@onready var animationPlayer=$AnimationPlayer
@onready var state_machine=$State_machine
@onready var collision_management=$Collision_management
@onready var gameInputControl=$GameInputControl

@export var accerleration=900;
@export var speed=220;
@export var friction=1200;
func _ready():
	state_machine.init(self,animationPlayer,collision_management,gameInputControl)
	

func _physics_process(delta: float) -> void:
	velocity.y+=GlobalValue.gravity
	if gameInputControl.row_dir>0:
		velocity.x=move_toward(velocity.x,speed,accerleration*delta)
	if gameInputControl.row_dir<0:
		velocity.x=move_toward(velocity.x,-speed,accerleration*delta)
	if gameInputControl.row_dir==0:
		velocity.x=move_toward(velocity.x,0,friction*delta)
	
	if gameInputControl.is_jump:
		velocity.y-=300
		
	move_and_slide()
