extends Node2D
@onready var obj=$".."
@onready var gameinputcontrol=$"../GameInputControl"
signal attack_reversed()

@onready var children=get_children()
func _ready() -> void:
	
	
	
	

	for child in children:
		var texture=child.get_texture()
		var w=texture.get_width()
		var h=texture.get_height()
		attack_reversed.connect(func():

			if gameinputcontrol.column_dir==0:
				if (obj.face_dir==1):
					child.rotation=PI
				elif (obj.face_dir==-1):
					child.rotation=-2*PI
			else:
				if gameinputcontrol.column_dir==1:
					child.rotation=3*PI/2
				else:
					child.rotation=PI/2
					
			
		
			
			)
func _physics_process(delta: float) -> void:
	pass
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
