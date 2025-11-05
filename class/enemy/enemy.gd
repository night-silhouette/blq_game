@icon("res://class/enemy/怪物图标.png")
extends CharacterBody2D
class_name	Enemy 



var hp_bar_scene = preload("res://scene/ui/enemy血条/enemy_hp_bar.tscn")
var hp_bar
@export_category("pysical")#------------------------------------------------
@export var hp_bar_position:Vector2=Vector2.ZERO
@export var hp_bar_scale:Vector2=Vector2(1,1)
@export var died_animation_time:float
@export var knock_distance=8

@export_category("Node_references")#------------------------------------------------

@export var behavior_machine_path: NodePath
@export var physical_machine_path: NodePath
@export var animationplayer_path: NodePath
@export var main_collision_path:NodePath
@export var attack_area_path:NodePath
@export var sprite_path:NodePath

@export_category("properties")#------------------------------------------------
@export_group("state_prop")
@export var Max_HP:float :
	set(value):
		Max_HP=value
		if Max_HP<now_HP:
			now_HP=Max_HP
		if hp_bar:
			hp_bar.max_hp=Max_HP	
@export var now_HP:float :
	set(value):
		if (value>Max_HP):
			now_HP=Max_HP
		elif(value<=0):
			now_HP=0
			Util.set_time(died_animation_time,queue_free)
		else :
			now_HP=value
		if hp_bar:
			hp_bar.now_hp=now_HP
@export var level:int

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
	
func init_max_hp():
	hp_bar.max_hp=Max_HP
	hp_bar.now_hp=now_HP
func _ready() -> void:
	call_deferred("init_max_hp")

	hp_bar= hp_bar_scene.instantiate()
	hp_bar.position=hp_bar_position
	hp_bar.scale=hp_bar_scale
	hp_bar.level=level
	self.add_child(hp_bar)
	
	set_attack_layer()
	attack_area.body_entered.connect(func(body):player.be_hurted(collision_hurt))
	
	
	
	behavior_machine.init(self,animationplayer)
	physical_machine.init(self,animationplayer)


	set_pysical_layer()
var player_is_vertical_attack:bool
func _physics_process(delta: float) -> void:
	velocity.y+=GlobalValue.gravity
	move_and_slide()
	player_is_vertical_attack=player.now_attack_dir==1 or player.now_attack_dir==2

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
	
func knock_back():
	if !player_is_vertical_attack:
		var distance_x=player.global_position.x-self.global_position.x
		self.global_position.x-=knock_distance*sign(distance_x)
var hurt_lock=true

var hurt_number_scene=preload("res://scene/ui/伤害数字/hurt_number.tscn")
func hurt_number(value):
	var hurt_num=hurt_number_scene.instantiate()
	var flag
	if value>=Max_HP*0.4:
		flag=true
	else :
		flag=false
	self.add_child(hurt_num)
	hurt_num.setup_and_play(value,flag)
	

func be_hurted(damage):
	if hurt_lock:
		hurt_lock=false
		get_tree().create_timer(0.12).timeout.connect(func():hurt_lock=true)
		
		spill_blood()
		set_modulate_white()
		knock_back()
		hurt_number(damage)
	now_HP-=damage
	
	
