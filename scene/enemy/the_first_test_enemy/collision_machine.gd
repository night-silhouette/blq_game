extends State_machine

@onready var main_collision=$"../main_collision"


const normal=preload("res://scene/enemy/the_first_test_enemy/collision/normal.tres")


var shape_map={
	"normal":normal,

}
func change_before(next_state_name):
	main_collision.shape=shape_map[next_state_name]


func _physics_process(delta: float) -> void:
	pass
