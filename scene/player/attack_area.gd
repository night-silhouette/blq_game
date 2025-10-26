extends Area2D
@onready var attack_state_machine=$"../../attack_state_machine"
@onready var obj=$"../.."
func _ready() -> void:
	body_entered.connect(func(body):
		if attack_state_machine.attack_mode==1:
			body.be_hurted(obj.damage*obj.long_attack_coefficient)
		else :
			body.be_hurted(obj.damage*obj.short_attack_coefficient)
		)
		
