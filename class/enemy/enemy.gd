@icon("res://class/enemy/怪物图标.png")
extends CharacterBody2D
class_name	Enemy 
@export_category("neccessary_setting_prop")#------------------------------------------------
@export var died_animation_time:float

@export_category("Node_references")#------------------------------------------------

@export var behavior_machine_path: NodePath
@export var physical_machine_path: NodePath
@export var animationplayer_path: NodePath
@export var main_collision_path:NodePath
@export var attack_area_path:NodePath
@export var sprite_path:NodePath

@export_category("properties")#------------------------------------------------
@export_group("state_prop")
@export var Max_HP:float 
@export var now_HP:float :
	set(value):
		if (value>Max_HP):
			now_HP=Max_HP
		elif(value<=0):
			now_HP=0
			Util.set_time(died_animation_time,queue_free)
		else :
			now_HP=value

@export_group("attack_prop")
@export var collision_hurt:float

@onready var behavior_machine: State_machine = get_node(behavior_machine_path)#主状态机，管理行为
@onready var physical_machine: State_machine = get_node(physical_machine_path)
@onready var animationplayer: AnimationPlayer = get_node(animationplayer_path)
@onready var player=get_tree().get_nodes_in_group("player")[0]
@onready var attack_area:Area2D=get_node(attack_area_path)
@onready var sprite=get_node(sprite_path)



func set_pysical_layer():
	set_collision_layer_value(3,true)
	set_collision_layer_value(1,false)
	set_collision_mask_value(2,true)
	set_collision_mask_value(3,true)	

func set_attack_layer():
	attack_area.set_collision_layer_value(5,true)
	attack_area.set_collision_layer_value(1,false)
	attack_area.set_collision_mask_value(2,true)
	attack_area.set_collision_mask_value(1,false)
	
func _ready() -> void:
	set_attack_layer()
	attack_area.body_entered.connect(func(body):player.be_hurted(collision_hurt))
	
	
	
	behavior_machine.init(self,animationplayer)
	physical_machine.init(self,animationplayer)


	set_pysical_layer()
func _physics_process(delta: float) -> void:
	velocity.y+=GlobalValue.gravity
	
	move_and_slide()


var blood=preload("res://scene/particle/spill_blood.tscn")



func spill_blood():
	var temp=blood.instantiate()
	temp.emitting=true
	
	match player.now_attack_dir:
		4:
			temp.process_material.direction.x=1
			temp.process_material.direction.y=0
			temp.process_material.angle=Vector2(-10,10)
			
		3:
			temp.process_material.direction.x=-1
			temp.process_material.direction.y=0	
			temp.process_material.angle=Vector2(-10,10)
		2:
			temp.process_material.direction.y=1
			temp.process_material.direction.x=0
			temp.process_material.angle=Vector2(80,100)
		1:
			temp.process_material.direction.y=-1
			temp.process_material.direction.x=0
			temp.process_material.angle=Vector2(80,100)
	add_child(temp)

func set_sprite_prop(prop,value):
	var children = sprite.get_children()
	for item in children:
		item[prop]=value
		
const HIT_COLOR: Color = Color(2.5, 2.5, 2.5, 1.0)
const NORMAL_COLOR: Color = Color.WHITE
var hit_time=0.15
func set_modulate_white():
	set_sprite_prop("modulate",HIT_COLOR)
	Util.set_time(hit_time,func():set_sprite_prop("modulate",NORMAL_COLOR))
var hurt_lock=true
func be_hurted(damage):
	if hurt_lock:
		hurt_lock=false
		get_tree().create_timer(0.12).timeout.connect(func():hurt_lock=true)
		spill_blood()
		set_modulate_white()
	now_HP-=damage
	
	
