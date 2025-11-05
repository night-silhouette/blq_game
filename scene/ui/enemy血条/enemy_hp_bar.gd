extends Node2D
@onready var player=get_tree().get_nodes_in_group("player")[0]
var max_hp:float:
	set(value):
		max_hp=value
		textureProgressBar_up.max_value=max_hp
		textureProgressBar_under.max_value=max_hp
@onready var textureProgressBar_up=$TextureProgressBar_up
@onready var textureProgressBar_under=$TextureProgressBar_under

func tween_transform(value):
	var tween:Tween=get_tree().create_tween()
	tween.set_trans(Tween.TRANS_QUINT)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(textureProgressBar_under,"value",value,0.5)
	textureProgressBar_under.tint_progress=Color.RED
	Util.set_time(0.2,func():textureProgressBar_under.tint_progress=Color.WHITE)
	
	
var now_hp:float:
	set(value):
		now_hp=value
		textureProgressBar_up.value=value
		tween_transform(value)

@onready var level_label=$level_label
var level:int

var color=[Color("ffffff"),Color("ff4a4e"),Color("b5001e")]
func change_color_by_level(player_level):
	var res
	var level_diff=level-player_level
	if level_diff<=0:
		res=color[0]
	elif level_diff<=2:
		res=color[1]
	else:
		res=color[2]
	textureProgressBar_up.modulate=res
	level_label.modulate=res
func _ready() -> void:
	change_color_by_level(player.level)
	player.on_level_change.connect(change_color_by_level)
	level_label.text=str(level)
	
	
	
	
	
