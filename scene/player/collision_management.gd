extends State_machine

@onready var main_collision=$"../main_collision"


const normal=preload("res://scene/player/collision_shape/normal.tres")
const crouch=preload("res://scene/player/collision_shape/crouch.tres")

var shape_map={
	"normal":normal,
	"crouch":crouch
}
func change_before(next_state_name):
	main_collision.shape=shape_map[next_state_name]


func _physics_process(delta: float) -> void:
	if gameInputControl.is_crouch:
		change_state("crouch")
	else :
		change_state("normal")
