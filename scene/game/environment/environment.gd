extends Node2D

@onready var obj=$"../player"
const down_dust=preload("res://scene/game/environment/down_dust/down_dust.tscn")

var is_on_floor=false


func add_on_play(scene:PackedScene,bias:Vector2	):
	var temp=scene.instantiate()
	temp.position=obj.position+bias
	add_child(temp)

func _physics_process(delta: float) -> void:
	if !obj.is_on_floor() and is_on_floor:
		is_on_floor=false

		
	if obj.is_on_floor() and !is_on_floor:
		is_on_floor=true
		add_on_play(down_dust,Vector2(10,0))
		
	
