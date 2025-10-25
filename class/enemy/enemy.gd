@icon("res://class/enemy/怪物图标.png")
extends CharacterBody2D
class_name	Enemy 



@export_category("Node_references")#------------------------------------------------
@export_group("State Machines")
@export var behavior_machine_path: NodePath
@export var physical_machine_path: NodePath
@export var collision_machine_path: NodePath

@export_category("properties")#------------------------------------------------
@export_group("state_prop")
@export var Max_HP:float
@export var now_HP:float


@onready var behavior_machine: State_machine = get_node(behavior_machine_path)#主状态机，管理行为
@onready var physical_machine: State_machine = get_node(physical_machine_path)
@onready var collision_machine: State_machine = get_node(collision_machine_path)

func _ready() -> void:
	behavior_machine.init(self)
	physical_machine.init(self)
	collision_machine.init(self)
	
	
func _physics_process(delta: float) -> void:
	velocity.y+=GlobalValue.gravity
	
	move_and_slide()
	
	
	
