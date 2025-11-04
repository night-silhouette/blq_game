extends Area2D
@onready var attack_state_machine=$"../../attack_state_machine"
@onready var obj=$"../.."
@onready var gameinputcontrol=$"../../GameInputControl"
var attack_lock=true
@onready var move_state_machine=$"../../move_state_machine"

func down_attack_jump():#下批
	obj.velocity.y=-obj.attack_jump_ability
	if move_state_machine.cur_state_name=="jump":
		$"../../move_state_machine/air/jump".s_fall.emit()

func _ready() -> void:
	body_entered.connect(func(body):
		if attack_state_machine.attack_mode==1:
			body.be_hurted(obj.damage*obj.long_attack_coefficient)
		else :
			body.be_hurted(obj.damage*obj.short_attack_coefficient)
			
		if attack_lock:#帧保护
			
			if gameinputcontrol.column_dir==1:
				attack_lock=false
				get_tree().create_timer(0.12).timeout.connect(func():attack_lock=true)
				down_attack_jump()
				gameinputcontrol.dash_control_flag=true

		)
		
		
		
