extends State
@onready var sprite=$"../../attack_sprite"
func enter():
	sprite.attack_reversed.emit()
	$"../../attack_sprite/ShortAttack".can_reverse=false
	self.is_use=false
	animation_player.play("short_attack")
	animation_end_finished("normal")
	get_tree().create_timer(obj.short_attack_span).timeout.connect(func():is_use=true)

func exit():
	$"../../attack_sprite/ShortAttack".can_reverse=true
