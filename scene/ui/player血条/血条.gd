extends Node2D
var ui_name="player血条"

var max_hp:float:
	set(value):
		max_hp=value
		textureProgressBar.max_value=max_hp
@onready var textureProgressBar=$TextureProgressBar
@onready var up=$up
@onready var under=$under

func tween_transform(value):
	var tween:Tween=get_tree().create_tween()
	tween.tween_property(textureProgressBar,"value",value,0.2)
	tween.set_trans(Tween.TRANS_EXPO)
	
var now_hp:float:
	set(value):
		now_hp=value
		tween_transform(value)
		
		
		
		

 



func _ready() -> void:
	pass
	
