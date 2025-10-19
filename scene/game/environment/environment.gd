extends Node2D

@onready var obj=$"../player"


var is_on_floor=false
func _physics_process(delta: float) -> void:
	if !obj.is_on_floor() and is_on_floor:
		is_on_floor=false

		
	if obj.is_on_floor() and !is_on_floor:
		is_on_floor=true
		
	
