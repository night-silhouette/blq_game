extends Node2D
var ui_name="player血条"

var max_hp:float:
	set(value):
		max_hp=value
		textureProgressBar_up.max_value=max_hp
		textureProgressBar_under.max_value=max_hp
@onready var textureProgressBar_up=$TextureProgressBar_up
@onready var textureProgressBar_under=$TextureProgressBar_under
@onready var up=$up
@onready var under=$under

func tween_transform(value):
	var tween:Tween=get_tree().create_tween()
	tween.tween_property(textureProgressBar_up,"value",value,0.4)
	tween.set_trans(Tween.TRANS_EXPO)
	
var now_hp:float:
	set(value):
		now_hp=value
		textureProgressBar_under.value=value
		tween_transform(value)
		
		
		
		

 



func _ready() -> void:
	pass
	
